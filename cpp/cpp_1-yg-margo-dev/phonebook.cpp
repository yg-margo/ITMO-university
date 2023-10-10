#include "phonebook.h"

bool Book::operator<(const Book &a)
{
	int res = Surname.compare(a.Surname);
	if (res < 0)
	{
		return true;
	}
	else if (res > 0)
	{
		return false;
	}

	res = Name.compare(a.Name);
	if (res < 0)
	{
		return true;
	}
	else if (res > 0)
	{
		return false;
	}

	res = Patronymic.compare(a.Patronymic);
	if (res < 0)
	{
		return true;
	}
	else if (res > 0)
	{
		return false;
	}

	return (Number < a.Number);
}

bool Book::operator>(const Book &a)
{
	int res = Surname.compare(a.Surname);
	if (res > 0)
	{
		return true;
	}
	else if (res < 0)
	{
		return false;
	}

	res = Name.compare(a.Name);
	if (res > 0)
	{
		return true;
	}
	else if (res < 0)
	{
		return false;
	}

	res = Patronymic.compare(a.Patronymic);
	if (res > 0)
	{
		return true;
	}
	else if (res < 0)
	{
		return false;
	}

	return (Number > a.Number);
}
