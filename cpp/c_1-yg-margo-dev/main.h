#ifndef MAIN_H
#define MAIN_H

#include <stdio.h>

#define CHUNK_TYPE_LENGTH 4

#define ZLIB
//#define LIBDEFLATE
//#define ISAL

#if defined(ZLIB) && (defined(LIBDEFLATE) || defined(ISAL))
    #error More than one zip library defined
#elif defined(LIBDEFLATE) && (defined(ZLIB) || defined(ISAL))
    #error More than one zip library defined
#elif defined(ISAL) && (defined(ZLIB) || defined(LIBDEFLATE))
    #error More than one zip library defined
#endif

#if defined (ZLIB)
    #include <zlib.h>
#elif defined(LIBDEFLATE)
    #include <libdeflate.h>
#elif defined(ISAL)
    #include <include/igzip_lib.h>
#else
    #error No zip libraries defined
#endif

#define MIN_INT(a, b) (a < b ? a : b)

typedef struct PNGChunk
{
    unsigned char type[CHUNK_TYPE_LENGTH];
    unsigned int dataSize;
    unsigned char *data;
} PNGChunk_t;

typedef struct PNGImage
{
    unsigned char *data;
    unsigned char *idatData;
    unsigned int width;
    unsigned int height;
    unsigned int type;
    unsigned int pixelSize;
    unsigned int size;
} PNGImage_t;

PNGChunk_t PNGChunk();
void pngchunk_clear(PNGChunk_t *chunk);
PNGImage_t PNGImage();
void pngimage_clear(PNGImage_t *img);
unsigned int read_uint(unsigned char *arr);
int pngchunk_read(FILE *file, PNGChunk_t *chunk);
int pngimage_read(const char *infile, PNGImage_t *image);
int parse_IHDR(PNGImage_t *image, PNGChunk_t *chunk);
int parse_IDAT(PNGImage_t *image, PNGChunk_t *chunk);
int parse_IEND(PNGImage_t *image);
int write_to_PNM(PNGImage_t *image, const char *outfile);

int inflateData(size_t inSize, unsigned char *inData, size_t outSize, unsigned char *outData);

#endif // MAIN_H
