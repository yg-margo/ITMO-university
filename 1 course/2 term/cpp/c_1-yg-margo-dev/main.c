#include <string.h>
#include <stdlib.h>
#include <return_codes.h>
#include <main.h>


PNGChunk_t PNGChunk()
{
    PNGChunk_t res;
    memset(res.type, 0, CHUNK_TYPE_LENGTH);
    res.dataSize = 0;
    res.data = NULL;
    return res;
}

void pngchunk_clear(PNGChunk_t *chunk)
{
    chunk->dataSize = 0;
    if (chunk->data != NULL)
    {
        free(chunk->data);
        chunk->data = NULL;
    }
}


PNGImage_t PNGImage()
{
    PNGImage_t res;
    res.data = NULL;
    res.idatData = NULL;
    res.width = 0;
    res.height = 0;
    res.type = 0;
    res.pixelSize = 1;
    res.size = 0;

    return res;
}

void pngimage_clear(PNGImage_t *img)
{
    if (img->data != NULL)
    {
        free(img->data);
        img->data = NULL;
    }
    if (img->idatData != NULL)
    {
        free(img->idatData);
        img->idatData = NULL;
    }
}

unsigned int read_uint(unsigned char* arr)
{
    unsigned int res = 0;
    for (int i = 0; i < 4; i++)
    {
        res <<= 8;
        res |= arr[i];
    }
    return res;
}

int pngchunk_read(FILE *file, PNGChunk_t *chunk)
{
    int rc = ERROR_SUCCESS;
    size_t bytes_read;

    unsigned char buffer[4];
    bytes_read = fread(buffer, 1, 4, file);
    if (bytes_read < 4)
    {
        fprintf(stderr, "Error reading chunk data size, expected bytes: 4, read bytes: %d", bytes_read);
        rc = ERROR_INVALID_DATA;
    }
    else
    {
        chunk->dataSize = read_uint(buffer);
    }

    if (rc == ERROR_SUCCESS)
    {
        bytes_read = fread(chunk->type, 1, 4, file);
        if (bytes_read < 4)
        {
            fprintf(stderr, "Error reading chunk type, expected bytes: 4, read bytes: %d", bytes_read);
            rc = ERROR_INVALID_DATA;
        }
    }

    if ((rc == ERROR_SUCCESS) && (chunk->dataSize != 0))
    {
        chunk->data = (unsigned char*)malloc(chunk->dataSize);
        if (chunk->data == NULL)
        {
            fprintf(stderr, "Failed to allocate memory for PNG chunk data");
            rc = ERROR_NOT_ENOUGH_MEMORY;
        }
        else
        {
            bytes_read = fread(chunk->data, 1, chunk->dataSize, file);
            if (bytes_read != chunk->dataSize)
            {
                fprintf(stderr, "Error reading chunk data, expected bytes: %d, read bytes: %d", chunk->dataSize, bytes_read);
                rc = ERROR_INVALID_DATA;
            }
        }
    }

    if (rc == ERROR_SUCCESS)
    {
        bytes_read = fread(buffer, 1, 4, file);
        if (bytes_read != 4)
        {
            fprintf(stderr, "Error bypassing chunk CRC, expected bytes: 4, read bytes: %d", bytes_read);
            rc = ERROR_INVALID_DATA;
        }
    }

    return rc;
}


int pngimage_read(const char *infile, PNGImage_t *image)
{
    int rc = ERROR_SUCCESS;
    char buffer[8];
    const char pngSignature[8] = {137, 80, 78, 71, 13, 10, 26, 10};
    size_t bytes_read;

    FILE *file = fopen(infile, "rb");
    if (NULL == file)
    {
        fprintf(stderr, "Error opening file '%s', exiting", infile);
        rc = ERROR_FILE_NOT_FOUND;
    }

    if (rc == ERROR_SUCCESS)
    {
        bytes_read = fread(buffer, 1, 8, file);
        if (bytes_read != 8)
        {
            fprintf(stderr, "Failed to read PNG signature, expected bytes: 8, read bytes: %d", bytes_read);
            rc = ERROR_INVALID_DATA;
        }
        else if (memcmp(buffer, pngSignature, 8) != 0)
        {
            fprintf(stderr, "Wrong PNG signature");
            rc = ERROR_INVALID_DATA;
        }
    }

    if (rc == ERROR_SUCCESS)
    {
        int finished = 0;
        PNGChunk_t chunk = PNGChunk();
        const unsigned char type_IHDR[4] = {'I', 'H', 'D', 'R'};
        const unsigned char type_IDAT[4] = {'I', 'D', 'A', 'T'};
        const unsigned char type_IEND[4] = {'I', 'E', 'N', 'D'};
        while ((rc == ERROR_SUCCESS) && (finished == 0))
        {
            pngchunk_clear(&chunk);
            rc = pngchunk_read(file, &chunk);
            if (rc == ERROR_SUCCESS)
            {
                if (0 == memcmp(chunk.type, type_IHDR, 4))
                {
                    rc = parse_IHDR(image, &chunk);
                }
                else if (0 == memcmp(chunk.type, type_IDAT, 4))
                {
                    rc = parse_IDAT(image, &chunk);
                }
                else if (0 == memcmp(chunk.type, type_IEND, 4))
                {
                    rc = parse_IEND(image);
                    finished = 1;
                }
                else
                {
                    char wrongType[5];
                    memcpy(wrongType, chunk.type, 4);
                    wrongType[4] = '\0';
                    fprintf(stderr, "Unexpected chunk type found: '%s', stopped", wrongType);
                    rc = ERROR_INVALID_DATA;
                }
            }
        }

        pngchunk_clear(&chunk);
    }

    fclose(file);
    return rc;
}

int parse_IHDR(PNGImage_t *image, PNGChunk_t *chunk)
{
    int rc = ERROR_SUCCESS;

    image->width = read_uint(chunk->data);
    image->height = read_uint(&(chunk->data[4]));

    int bitDepth = (int)chunk->data[8];
    if (bitDepth != 8)
    {
        fprintf(stderr, "Unsupported bit depth, expected: 8, read: %d", bitDepth);
        rc = ERROR_INVALID_DATA;
    }

    int colorType = 0;
    if (rc == ERROR_SUCCESS)
    {
        colorType = (int)chunk->data[9];
        if ((colorType != 0) && (colorType != 2))
        {
            fprintf(stderr, "Unsupported color type, expected: 0 or 2, read: %d", colorType);
            rc = ERROR_INVALID_DATA;
        }
        else
        {
            image->pixelSize = (colorType == 2) ? 3 : 1;
            image->type = (image->pixelSize == 3) ? 6 : 5;
        }
    }

    int compressionMethod = 0;
    if (rc == ERROR_SUCCESS)
    {
        compressionMethod = (int)chunk->data[10];
        if (compressionMethod != 0)
        {
            fprintf(stderr, "Unsupported compression method, expected: 0, read: %d", compressionMethod);
            rc = ERROR_INVALID_DATA;
        }
    }

    int filterMethod = 0;
    if (rc == ERROR_SUCCESS)
    {
        filterMethod = (int)chunk->data[11];
        if (filterMethod != 0)
        {
            fprintf(stderr, "Unsupported filter method, expected: 0, read: %d", filterMethod);
            rc = ERROR_INVALID_DATA;
        }
    }

    int interlaceMethod = 0;
    if (rc == ERROR_SUCCESS)
    {
        interlaceMethod = (int)chunk->data[12];
        if (interlaceMethod != 0)
        {
            fprintf(stderr, "Unsupported interlace method, expected: 0, read: %d", interlaceMethod);
            rc = ERROR_INVALID_DATA;
        }
    }

    return rc;
}


int parse_IDAT(PNGImage_t *image, PNGChunk_t *chunk)
{
    int rc = ERROR_SUCCESS;

    unsigned char *buffer = (unsigned char*)malloc(image->size + chunk->dataSize);
    if (NULL == buffer)
    {
        fprintf(stderr, "parse_IDAT(): Failed to allocate buffer of size %d", image->size + chunk->dataSize);
        rc = ERROR_NOT_ENOUGH_MEMORY;
    }

    if (rc == ERROR_SUCCESS)
    {
        if (image->size != 0)
        {
            memcpy(buffer, image->idatData, image->size);
            free(image->idatData);
        }
        memcpy(buffer + image->size, chunk->data, chunk->dataSize);
        image->size += chunk->dataSize;
        image->idatData = (unsigned char*)malloc(image->size);
        if (NULL == image->idatData)
        {
            fprintf(stderr, "parse_IDAT(): Failed to allocate image->idatData of size %d", image->size);
            rc = ERROR_NOT_ENOUGH_MEMORY;
        }
    }

    if (rc == ERROR_SUCCESS)
    {
        memcpy(image->idatData, buffer, image->size);
    }
    free(buffer);

    return rc;
}

int parse_IEND(PNGImage_t *image)
{
    int rc = ERROR_SUCCESS;

    size_t m_width = (image->pixelSize * image->width + 1);
    unsigned char *rawData = (unsigned char*)malloc(m_width * image->height);
    if (NULL == rawData)
    {
        fprintf(stderr, "parse_IEND(): Failed to allocate rawData buffer of size %d", m_width * image->height);
        rc = ERROR_NOT_ENOUGH_MEMORY;
    }

    if (rc == ERROR_SUCCESS)
    {
        rc = inflateData(image->size, image->idatData, m_width * image->height, rawData);
    }

    if (rc == ERROR_SUCCESS)
    {
        image->data = (unsigned char*)malloc(image->pixelSize * image->height * image->width);
        if (NULL == image->data)
        {
            fprintf(stderr, "parse_IEND(): Failed to allocate image->data buffer of size %d", image->pixelSize * image->height * image->width);
            rc = ERROR_NOT_ENOUGH_MEMORY;
        }
    }

    if (rc == ERROR_SUCCESS)
    {
        int k = 0;
        int delta;
        int dist_u, dist_l, dist_ul;
        int upper, left, upper_left;

        for (size_t i = 0; i < image->height; i++)
        {
            int filter = (int) rawData[i * m_width];
            for (size_t j = 1; j < m_width; j++)
            {
                switch (filter)
                {
                    case 0: 
                        delta = 0;
                        break;
                    case 1: 
                        delta = (j <= image->pixelSize) ? 0 : image->data[i * image->width * image->pixelSize + j - image->pixelSize - 1];
                        break;
                    case 2: 
                        delta = (i == 0) ? 0 : image->data[(i - 1) * image->width * image->pixelSize + j - 1];
                        break;
                    case 3: 
                        delta = 0;
                        if (i != 0)
                            delta += image->data[(i - 1) * image->width * image->pixelSize + j - 1];
                        if (j > image->pixelSize)
                            delta += image->data[i * image->width * image->pixelSize + j - image->pixelSize - 1];
                        delta /= 2;
                        break;
                    case 4: 
                        upper = (i == 0) ? 0 : image->data[(i - 1) * image->width * image->pixelSize + j - 1];
                        left = (j <= image->pixelSize) ? 0 : image->data[i * image->width * image->pixelSize + j - image->pixelSize - 1];
                        upper_left = (i == 0 || j <= image->pixelSize) ?
                                        0 :
                                        image->data[(i - 1) * image->width * image->pixelSize + j - image->pixelSize - 1];

                        delta = upper + left - upper_left;
                        dist_u = abs(delta - upper);
                        dist_l = abs(delta - left);
                        dist_ul = abs(delta - upper_left);

                        delta = upper_left;
                        const int min_lul = MIN_INT(dist_l, dist_ul);
                        const int min_ulul = MIN_INT(dist_u, min_lul);
                        if (min_ulul == dist_u)
                            delta = upper;
                        else if (min_ulul == dist_l)
                            delta = left;
                        break;
                    default:
                        break;
                }
                image->data[k++] = (unsigned char) ((delta + (int) rawData[i * m_width + j]) & 255);
            }
        }
    }

    if (NULL != rawData)
    {
        free(rawData);
    }

    return rc;
}

int write_to_PNM(PNGImage_t *image, const char *outfile)
{
    int rc = ERROR_SUCCESS;

    FILE *file = fopen(outfile, "wb");
    if (NULL == file)
    {
        fprintf(stderr, "Cannot open the output PNM file '%s'", outfile);
        rc = ERROR_NOT_FOUND;
    }

    if (rc == ERROR_SUCCESS)
    {
        if (fprintf(file, "P%d\n%d %d\n%d\n", image->type, image->width, image->height, 255) < 0 ||
            fwrite(image->data, 1, image->width * image->height * image->pixelSize, file) != image->width * image->height * image->pixelSize)
        {
            fprintf(stderr, "Error writing image to file '%s'", outfile);
            rc = ERROR_UNKNOWN;
        }
        fclose(file);
    }

    return rc;
}



int inflateData(size_t inSize, unsigned char *inData, size_t outSize, unsigned char *outData)
{
    int rc = ERROR_SUCCESS;

#if defined(ZLIB)

    z_stream inf;
    inf.zalloc = Z_NULL;
    inf.zfree = Z_NULL;
    inf.opaque = Z_NULL;

    inf.avail_in = inSize;          
    inf.next_in = (Bytef*)inData;   
    inf.avail_out = outSize;        
    inf.next_out = (Bytef*)outData; 

    inflateInit(&inf);
    inflate(&inf, Z_NO_FLUSH);
    inflateEnd(&inf);

#elif defined(LIBDEFLATE)
    struct libdeflate_decompressor *decomp = libdeflate_alloc_decompressor();
    size_t actual_out_bytes;
    enum libdeflate_result res = libdeflate_deflate_decompress(decomp, inData, inSize, outData, outSize, &actual_out_bytes);
    switch (res)
    {
    case LIBDEFLATE_BAD_DATA:
        fprintf(stderr, "libdeflate: invalid data");
        rc = ERROR_INVALID_DATA;
        break;
    case LIBDEFLATE_SHORT_OUTPUT:
        fprintf(stderr, "libdeflate: the decompressed data is shorted than expected");
        rc = ERROR_INVALID_DATA;
        break;
    case LIBDEFLATE_INSUFFICIENT_SPACE:
        fprintf(stderr, "libdeflate: the decompressed data is longer than expected");
        rc = ERROR_INVALID_DATA;
        break;
    default:
        break;
    }
#elif defined(ISAL)
    #error Not supported yet
#else
    #error No ZIP library defined
#endif

    return rc;
}


int main(int argc, char* argv[])
{
    int rc = ERROR_SUCCESS;
    if (argc != 3)
    {
        fprintf(stderr, "Incorrect arguments count; must be 2 files: <input>.png and <output>.pnm");
        rc = ERROR_INVALID_PARAMETER;
    }

    PNGImage_t image = PNGImage();
    if (rc == ERROR_SUCCESS)
    {
        rc = pngimage_read(argv[1], &image);
    }

    if (rc == ERROR_SUCCESS)
    {
        rc = write_to_PNM(&image, argv[2]);
    }

    pngimage_clear(&image);

    return rc;
}
