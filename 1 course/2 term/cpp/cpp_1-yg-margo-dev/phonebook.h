#ifndef PHONEBOOK_H
#define PHONEBOOK_H

#include <string>

class Book
{
  public:
	std::string Surname;
	std::string Name;
	std::string Patronymic;
	uint64_t Number;

	bool operator<(const Book &a);
	bool operator>(const Book &a);
};

#endif	  // PHONEBOOK_H
