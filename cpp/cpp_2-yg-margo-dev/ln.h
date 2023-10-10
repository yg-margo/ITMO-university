#ifndef LN_H
#define LN_H

#include <string_view>

#include <fstream>
#include <iomanip>
#include <iostream>
#include <string>

class LN
{
  public:
	// Constructors
	LN();
	LN(const LN &value);
	LN(LN &&value);
	LN(const int &value) : LN((long long)value) {}
	LN(const long &value) : LN((long long)value) {}
	LN(const long long &value);
	LN(const std::string_view &value);
	LN(const char *value) : LN(std::string_view(value)) {}
	// Destructor
	~LN();

	// Member functions and operators
	size_t size() { return n_digits; }
	bool is_zero() const;
	bool is_nan() const;
	LN &operator=(const LN &value);
	LN &operator=(LN &&value);
	LN &operator=(const long long value);
	LN &operator=(const long value);
	LN &operator=(const int value);
	LN operator-() const;
	LN operator~() const { return sqrt(*this); }

	LN &operator+=(const LN &value) { return (*this = *this + value); }

	LN &operator-=(const LN &value) { return (*this = *this - value); }

	LN &operator*=(const LN &value) { return (*this = *this * value); }

	LN &operator%=(const LN &value) { return (*this = *this % value); }

	LN &operator/=(const LN &value) { return (*this = *this / value); }

	explicit operator long long() const;

	explicit operator bool() const;

	// External functions
	friend const LN operator+(const LN &value1, const LN &value2);
	friend const LN operator-(const LN &value1, const LN &value2);
	friend const LN operator*(const LN &value1, const LN &value2);
	friend const LN operator%(const LN &value1, const LN &value2)
	{
		return big_integer_division(value1, value2).second;
	}
	friend const LN operator/(const LN &value1, const LN &value2) { return big_integer_division(value1, value2).first; }
	friend bool operator>(const LN &value1, const LN &value2);
	friend bool operator<(const LN &value1, const LN &value2) { return value2 > value1; }
	friend bool operator<=(const LN &value1, const LN &value2) { return !(value1 > value2); }
	friend bool operator>=(const LN &value1, const LN &value2) { return !(value1 < value2); }
	friend bool operator==(const LN &value1, const LN &value2);
	friend bool operator!=(const LN &value1, const LN &value2) { return !(value1 == value2); }
	friend const LN abs(const LN &value);
	friend const LN sqrt(const LN &value);
	friend const std::string to_string(const LN &value);

  private:
	int sign;
	size_t n_digits;
	unsigned char *digits;

	void trim();
	friend unsigned char get_quotient_digit(const LN &p, const LN &q);
	friend std::pair< LN, LN > big_integer_division(const LN &x, const LN &y);
};

std::ostream &operator<<(std::ostream &stream, const LN &value);
std::istream &operator>>(std::istream &stream, LN &value);

LN operator"" _ln(const char *str);

#endif	  // LN_H
