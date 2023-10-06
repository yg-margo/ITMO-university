#include "quicksort.h"
#include "return_codes.h"
#include <algorithm>
#include <fstream>
#include <iostream>
#include <sstream>

template< typename T >
std::string toString(const T &val)
{
	return std::to_string(val);
}

template<>
std::string toString< Book >(const Book &val)
{
	std::stringstream stream;
	stream << val.Surname << " " << val.Name << " " << val.Patronymic << " " << val.Number;
	return stream.str();
}

template< typename T >
bool fromString(const std::string &val, T *res, std::string &err)
{
	err = "";
	std::istringstream iss(val);
	if (!(iss >> *res))
	{
		err = "Error reading value from string '" + val + "'";
		return false;
	}
	return true;
}

template<>
bool fromString< Book >(const std::string &val, Book *res, std::string &err)
{
	err = "";
	std::istringstream iss(val);
	if (!(iss >> res->Surname >> res->Name >> res->Patronymic >> res->Number))
	{
		err = "Error reading value from string '" + val + "'";
		return false;
	}
	return true;
}

int main(int argc, char *argv[])
{
	int rc = ERROR_SUCCESS;

	if (argc != 3)
	{
		std::cerr << "Incorrect arguments count; must be 2 file names: <input_file_name> <output_file_name>" << std::endl;
		rc = ERROR_INVALID_PARAMETER;
	}

	if (rc == ERROR_SUCCESS)
	{
		if ((argv[1] == nullptr) || (argv[2] == nullptr))
		{
			std::cerr << "Either <input_file_name> or <output_file_name> is nullptr" << std::endl;
			rc = ERROR_INVALID_PARAMETER;
		}
	}

	std::string inFileName = "";
	std::string outFileName = "";
	std::ifstream inStream;
	if (rc == ERROR_SUCCESS)
	{
		inFileName = argv[1];
		outFileName = argv[2];

		inStream.open(inFileName, std::ios::in);
		if (!inStream.is_open())
		{
			std::cerr << "Error opening file '" << inFileName << "'" << std::endl;
			rc = ERROR_FILE_NOT_FOUND;
		}
	}

	std::string dataType = "";
	std::string sortType = "";
	int nItems = 0;
	if (rc == ERROR_SUCCESS)
	{
		if (!(inStream >> dataType >> sortType >> nItems))
		{
			std::cerr << "Error reading the input file header" << std::endl;
			inStream.close();
			rc = ERROR_INVALID_DATA;
		}
	}

	bool is_int = false;
	bool is_float = false;
	bool is_book = false;
	if (rc == ERROR_SUCCESS)
	{
		std::string dataTypeOrig = dataType;
		std::transform(dataType.begin(), dataType.end(), dataType.begin(), ::tolower);
		is_int = (dataType.compare("int") == 0);
		is_float = (dataType.compare("float") == 0);
		is_book = (dataType.compare("phonebook") == 0);
		if (!is_int && !is_float && !is_book)
		{
			std::cerr << "Unexpected data type '" << dataTypeOrig << "' in input file" << std::endl;
			inStream.close();
			rc = ERROR_CALL_NOT_IMPLEMENTED;
		}
	}

	bool ascending = true;
	if (rc == ERROR_SUCCESS)
	{
		std::string sortTypeOrig = sortType;
		std::transform(sortType.begin(), sortType.end(), sortType.begin(), ::tolower);
		if ((sortType.compare("ascending") != 0) && (sortType.compare("descending") != 0))
		{
			std::cerr << "Unexpected sort type '" << sortTypeOrig << "' in input file" << std::endl;
			inStream.close();
			rc = ERROR_INVALID_DATA;
		}
		else
		{
			ascending = (sortType.compare("ascending") == 0);
		}
	}

	if (rc == ERROR_SUCCESS)
	{
		if (nItems <= 0)
		{
			std::cerr << "Unexpected value of nItems: " << nItems << "; must be positive" << std::endl;
			inStream.close();
			rc = ERROR_INVALID_DATA;
		}
	}

	std::vector< int > *vi = nullptr;
	std::vector< float > *vf = nullptr;
	std::vector< Book > *vb = nullptr;

	if (rc == ERROR_SUCCESS)
	{
		int counter = 0;
		std::string line;
		int ei;
		float ef;
		Book eb;
		std::string err;

		if (is_int)
		{
			vi = new std::vector< int >(nItems);
			while ((rc == ERROR_SUCCESS) && (counter < nItems) && (inStream >> line))
			{
				if (fromString< int >(line, &ei, err))
				{
					(*vi)[counter++] = ei;
				}
				else
				{
					std::cerr << err << std::endl;
					rc = ERROR_INVALID_DATA;
				}
			}
		}
		else if (is_float)
		{
			vf = new std::vector< float >(nItems);
			while ((rc == ERROR_SUCCESS) && (counter < nItems) && (inStream >> line))
			{
				if (fromString< float >(line, &ef, err))
				{
					(*vf)[counter++] = ef;
				}
				else
				{
					std::cerr << err << std::endl;
					rc = ERROR_INVALID_DATA;
				}
			}
		}
		else if (is_book)
		{
			vb = new std::vector< Book >(nItems);
			std::string f, n, p;
			uint64_t pn;
			while ((rc == ERROR_SUCCESS) && (counter < nItems) && (inStream >> f >> n >> p >> pn))
			{
				eb.Surname = f;
				eb.Name = n;
				eb.Patronymic = p;
				eb.Number = pn;
				(*vb)[counter++] = eb;
				Book eb;
			}
		}
		inStream.close();
		if ((rc == ERROR_SUCCESS) && (counter != nItems))
		{
			std::cerr << "Wrong number of items in file, expected " << nItems << ", read " << counter << std::endl;
			rc = ERROR_INVALID_DATA;
		}
	}

	std::ofstream outStream;
	if (rc == ERROR_SUCCESS)
	{
		outStream.open(outFileName);
		if (!outStream.is_open())
		{
			std::cerr << "Error creating output file '" << outFileName << "'" << std::endl;
			rc = ERROR_FILE_NOT_FOUND;
		}
	}

	if (rc == ERROR_SUCCESS)
	{
		if (is_int)
		{
			if (ascending)
			{
				quicksort< int, false >(*vi);
			}
			else
			{
				quicksort< int, true >(*vi);
			}
			for (size_t i = 0; i < vi->size(); i++)
			{
				outStream << toString< int >(vi->at(i)) << std::endl;
			}
		}
		else if (is_float)
		{
			if (ascending)
			{
				quicksort< float, false >(*vf);
			}
			else
			{
				quicksort< float, true >(*vf);
			}
			for (size_t i = 0; i < vf->size(); i++)
			{
				outStream << toString< float >(vf->at(i)) << std::endl;
			}
		}
		else if (is_book)
		{
			if (ascending)
			{
				quicksort< Book, false >(*vb);
			}
			else
			{
				quicksort< Book, true >(*vb);
			}
			for (size_t i = 0; i < vb->size(); i++)
			{
				outStream << toString< Book >(vb->at(i)) << std::endl;
			}
		}

		outStream.close();
	}

	// Clear memory
	if (vi != nullptr)
	{
		delete vi;
	}
	else if (vf != nullptr)
	{
		delete vf;
	}
	else if (vb != nullptr)
	{
		delete vb;
	}

	return rc;
}
