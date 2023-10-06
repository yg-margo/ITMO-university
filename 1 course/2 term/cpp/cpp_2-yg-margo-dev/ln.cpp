#include "ln.h"

#include <algorithm>
#include <cstring>
#include <limits>
#include <stdexcept>

LN::LN()
{
	// In this case the LN is set to NaN
	// We consider a LN to be NaN when n_digits = 0
	sign = 1;
	n_digits = 0;
	digits = nullptr;
}

LN::~LN()
{
	if (digits != nullptr)
	{
		delete[] digits;
	}
}

// Copy constructor
LN::LN(const LN &value) : sign(value.sign), n_digits(value.n_digits), digits(new unsigned char[value.n_digits])
{
	std::memcpy(digits, value.digits, value.n_digits);
}

// Move constructor
LN::LN(LN &&value) : sign(value.sign), n_digits(value.n_digits), digits(value.digits)
{
	value.digits = nullptr;
}

// Create LN from long long value
LN::LN(const long long &value)
{
	long long x = value;
	// Initialize sign
	sign = 1;
	if (x < 0)
	{
		sign = -1;
		x = -x;
	}
	if (x == 0)
	{
		n_digits = 1;
		digits = new unsigned char[1];
		digits[0] = 0;
	}
	else
	{
		// Max long long takes 19 decimal places
		unsigned char buf[20];
		int counter = 0;
		// Get less significant decimal digit from x, add it to buffer, then divide x by 10
		while (x > 0)
		{
			buf[counter++] = x % 10;
			x /= 10;
		}
		// set the NL values
		n_digits = counter;
		digits = new unsigned char[counter];
		std::memcpy(digits, buf, n_digits);
	}
}

// Create LN from std::string_view
LN::LN(const std::string_view &value)
{
	// Initialize as NaN
	sign = 1;
	n_digits = 0;
	digits = nullptr;
	// Nothing to process
	if (value.size() == 0)
	{
		return;
	}

	size_t pos = 0;
	// Process sign, if present
	if (value[0] == '+')
	{
		pos = 1;
	}
	else if (value[0] == '-')
	{
		pos = 1;
		sign = -1;
	}

	// Skip leading 0's
	// We don't chek the last char in order to avoid an additional IF
	// Character codes for '0'...'9' are 48...57, so we subtract 48 in order to get the digit
	while ((pos < value.size() - 1) && (value[pos] == 48))
	{
		pos++;
	}

	// Before allocating the 'digits' array, check the remaining part of string for validity
	bool ok = true;
	for (size_t i = pos; ok && (i < value.size()); i++)
	{
		ok = (value[i] >= 48) && (value[i] <= 57);
	}
	if (!ok)
	{
		throw std::invalid_argument("Wrong number format");
	}

	// Construction
	n_digits = value.size() - pos;
	digits = new unsigned char[n_digits];
	for (size_t i = 0; i < n_digits; i++)
	{
		digits[n_digits - 1 - i] = value[pos++] - 48;
	}
	trim();
	if (is_zero())
	{
		sign = 1;
	}
}

// Remove leading zeros
void LN::trim()
{
	if (n_digits == 0)
	{
		return;
	}
	// We don't reallocate the digits array, it's ok if it is larger than n_digit chars
	for (int i = n_digits - 1; (i >= 0) && (digits[i] == 0); i--)
	{
		n_digits--;
	}
	if (n_digits == 0)
	{
		sign = 1;
		n_digits = 1;
		digits[0] = 0;
	}
}

// Check for 0
bool LN::is_zero() const
{
	return ((n_digits == 1) && (digits[0] == 0));
}

// Check for NaN
bool LN::is_nan() const
{
	return (n_digits == 0);
}

// Copy assignment
LN &LN::operator=(const LN &value)
{
	// Free the existing buffer if any
	if (digits != nullptr)
	{
		delete[] digits;
		digits = nullptr;
	}

	// Copy data from the parameter
	sign = value.sign;
	n_digits = value.n_digits;
	if (n_digits > 0)
	{
		// Allocate the array
		digits = new unsigned char[n_digits];
		// Copy digits
		std::memcpy(digits, value.digits, n_digits);
	}

	return *this;
}

// Move assignment
LN &LN::operator=(LN &&value)
{
	// Free the existing buffer if any
	if (digits != nullptr)
	{
		delete[] digits;
		digits = nullptr;
	}

	// Move the data from the parameter
	sign = value.sign;
	n_digits = value.n_digits;
	// Set the digits pointer to the array from the parameter
	digits = value.digits;
	// Remove the reference from the parameter
	value.digits = nullptr;

	return *this;
}

// Assignment of long long
LN &LN::operator=(const long long value)
{
	// Free the existing digits array
	if (digits != nullptr)
	{
		delete[] digits;
		digits = nullptr;
	}

	sign = 1;
	long long x = value;
	// Negative x
	if (x < 0)
	{
		sign = -1;
		x = -x;
	}

	if (x == 0)
	{
		n_digits = 1;
		digits = new unsigned char[1];
		digits[0] = 0;
	}
	else
	{
		// Max long long takes 19 decimal places
		unsigned char buf[20];
		int counter = 0;
		// Get less significant decimal digit from x, add it to buffer, then divide x by 10
		while (x > 0)
		{
			buf[counter++] = x % 10;
			x /= 10;
		}
		// Set the LN data
		n_digits = counter;
		digits = new unsigned char[counter];
		std::memcpy(digits, buf, n_digits);
		trim();
	}

	return *this;
}

LN &LN::operator=(const long value)
{
	*this = (long long)value;
	return *this;
}

LN &LN::operator=(const int value)
{
	*this = (long long)value;
	return *this;
}

// Unary minus
LN LN::operator-() const
{
	if (is_nan())
	{
		// If NaN, return NaN
		return LN();
	}
	// Copy the object and change the sign
	LN x = *this;
	x.sign = -sign;
	return (x);
}

// Convert to long long if possible
LN::operator long long() const
{
	// The LN is NaN or has no digits
	if ((n_digits == 0) || (digits == nullptr))
	{
		throw std::invalid_argument("Argument is empty");
	}
	// We can't convert the numbers outside of the long long range
	if ((*this > LN(std::numeric_limits< long long int >::max())) || (*this < LN(std::numeric_limits< long long int >::min())))
	{
		throw std::out_of_range("Argument is too big or too small");
	}
	long long res = 0;
	// Multiply result by 10 and add the next digit
	for (size_t i = 0; i < n_digits; i++)
	{
		res = res * 10 + digits[n_digits - 1 - i];
	}
	return (sign == 1) ? res : -res;
}

// Convert to bool (true, if LN != 0)
LN::operator bool() const
{
	return (*this != 0LL);
}

// External functions
// Addition
const LN operator+(const LN &value1, const LN &value2)
{
	// If any of arguments is NaN, the result is NaN
	if (value1.is_nan() || value2.is_nan())
	{
		return LN();
	}

	// Now we transform a + b to one of the forms a + b, a - (-b), -(-a - b), -(-a + (-b))
	// So that both arguments were positive
	if ((value1.sign > 0) && (value2.sign < 0))
	{
		return value1 - (-value2);
	}
	else if (value1.sign < 0)
	{
		if (value2.sign > 0)
		{
			return -(-value1 - value2);
		}
		else
		{
			return -(-value1 + (-value2));
		}
	}

	// Both operands are positive
	// Create resulting value
	LN ans;
	ans.sign = 1;
	// The maximum number of digits in result is one more than in bigger of the arguments
	ans.n_digits = std::max(value1.n_digits, value2.n_digits) + 1;
	ans.digits = new unsigned char[ans.n_digits];
	// Set the most significant digit to 0 since we may need to add 1 to it
	ans.digits[ans.n_digits - 1] = 0;
	// Carry flag
	unsigned char carry = 0;
	// Number of digits in the shorter of the arguments
	size_t min_digits = std::min(value1.n_digits, value2.n_digits);
	// Number of digits in the longer of the arguments
	size_t max_digits = ans.n_digits - 1;
	size_t i;

	// Adding parts where digits from both arguments are present
	for (i = 0; i < min_digits; i++)
	{
		unsigned char s = value1.digits[i] + value2.digits[i] + carry;
		if (s >= 10)
		{
			// Resulting digit
			ans.digits[i] = s - 10;
			// Carry flag
			carry = 1;
		}
		else
		{
			// Resulting digit
			ans.digits[i] = s;
			// No carry
			carry = 0;
		}
	}

	// Processing the remaining part of the longer argument
	// It is necessary since the remaining carry flag can be 1

	// Set a pointer to the remaining digits (it points either into the value1.digits or into the value2.digits)
	unsigned char *rest = (value1.n_digits >= value2.n_digits) ? &(value1.digits[i]) : &(value2.digits[i]);
	while (i < max_digits)
	{
		// Add carry flag
		unsigned char s = *rest + carry;
		if (s >= 10)
		{
			ans.digits[i] = s - 10;
			carry = 1;
		}
		else
		{
			ans.digits[i] = s;
			carry = 0;
		}
		rest++;
		i++;
	}

	// If we still have the carry flag, set it to the most significant digit of the result
	if (carry > 0)
	{
		ans.digits[ans.n_digits - 1] = 1;
	}

	ans.trim();
	return ans;
}

// Subtraction of two LN values
const LN operator-(const LN &value1, const LN &value2)
{
	// If any of arguments is NaN, return NaN
	if (value1.is_nan() || value2.is_nan())
	{
		return LN();
	}

	// Convert a - b so that a, b >= 0 and a >= b
	// We get one of the forms a - b, a + (-b), -(-a + b), -(-a - (-b)), -(b - a)
	if ((value1.sign > 0) && (value2.sign < 0))
	{
		return value1 + (-value2);
	}
	else if (value1.sign < 0)
	{
		if (value2.sign >= 0)
		{
			return -(-value1 + value2);
		}
		else
		{
			return -(-value1 - (-value2));
		}
	}
	else if (value2 > value1)
	{
		return -(value2 - value1);
	}

	// Main case (a - b where a,b >= 0, a >= b)

	// Initialize th result
	LN ans;
	ans.sign = 1;
	// The maximum number of digits is the same as in value1
	ans.n_digits = std::max(value1.n_digits, value2.n_digits);
	ans.digits = new unsigned char[ans.n_digits];

	size_t i;
	// Carry flag
	unsigned char carry = 0;
	for (i = 0; i < value1.n_digits; i++)
	{
		// What we have to subtract from the next digit of value1?
		// Carry flag
		unsigned char to_subtract = carry;
		if (i < value2.n_digits)
		{
			// Plus the corresponding digit of value2
			to_subtract += value2.digits[i];
		}
		if (value1.digits[i] < to_subtract)
		{
			// If the value1 digit is less then to_subtract, we take 10 from the next decimal place and set the carry
			// flag
			ans.digits[i] = value1.digits[i] + 10 - to_subtract;
			carry = 1;
		}
		else
		{
			// Else just subtract
			ans.digits[i] = value1.digits[i] - to_subtract;
			carry = 0;
		}
	}

	ans.trim();
	return ans;
}

// Multiply 2 LN values
const LN operator*(const LN &value1, const LN &value2)
{
	// Proces NaN
	if (value1.is_nan() || value2.is_nan())
	{
		return LN();
	}

	// Initialize result
	LN ans = 0;

	// p = 10
	// Sum(a[i] * p^i) * Sum(b[j] * p^j) = Sum(Sum(a[k] * b[s - k]) * p^s), i=0..n, j=0..m, s=0..n + m - 2, k = 0..s
	for (size_t s = 0; s <= value1.n_digits + value2.n_digits - 2; s++)
	{
		// Collect the coeffitients at 10^s
		// We take the digit at 10^i from the first argument and 10^(s - i) from the second one
		LN acc = 0;
		for (size_t i = 0; i <= s; i++)
		{
			size_t j = s - i;
			if ((i < value1.n_digits) && (j < value2.n_digits))
			{
				// Add the digits product to the accumulator
				acc += value1.digits[i] * value2.digits[j];
			}
		}
		// Multiply acc by 10^s
		// We just shift the acc value by s decimal places to the left
		LN acc_mul;
		acc_mul.sign = 1;
		acc_mul.n_digits = acc.n_digits + s;
		acc_mul.digits = new unsigned char[acc_mul.n_digits];
		std::memset(acc_mul.digits, 0, s);
		std::memcpy(&(acc_mul.digits[s]), acc.digits, acc.n_digits);
		ans += acc_mul;
	}
	// Sign of the result
	ans.sign = value1.sign * value2.sign;

	ans.trim();
	return ans;
}

// Is the 1st argument greater than the second one?
bool operator>(const LN &value1, const LN &value2)
{
	// NaNs
	if (value1.is_nan() || value2.is_nan())
	{
		return false;
	}

	// Arguments of different signs
	if (value2.sign != value1.sign)
	{
		return value1.sign > value2.sign;
	}
	// Different number of digits
	if (value1.n_digits != value2.n_digits)
	{
		return (value1.sign >= 0) ? (value1.n_digits > value2.n_digits) : (value1.n_digits < value2.n_digits);
	}
	// Digit-wise comparison from the most significant to the least significant
	for (int i = value1.n_digits - 1; i >= 0; --i)
	{
		// Different digits found
		if (value1.digits[i] != value2.digits[i])
		{
			return (value1.sign > 0) ? value1.digits[i] > value2.digits[i] : value1.digits[i] < value2.digits[i];
		}
	}
	return false;
}

// Is value1 equal to value2?
bool operator==(const LN &value1, const LN &value2)
{
	// NaNs
	if (value1.is_nan() || value2.is_nan())
	{
		return false;
	}
	// Different signs
	if (value2.sign != value1.sign)
	{
		return false;
	}
	// Different number of digits
	if (value1.n_digits != value2.n_digits)
	{
		return false;
	}
	// Are all digits equal?
	for (int i = value1.n_digits - 1; i >= 0; --i)
	{
		if (value1.digits[i] != value2.digits[i])
		{
			return false;
		}
	}
	return true;
}

// Abs value
const LN abs(const LN &value)
{
	// NaN
	if (value.is_nan())
	{
		return LN();
	}
	// Just set the sign to 1
	LN ans = value;
	ans.sign = 1;
	return ans;
}

// Square root
const LN sqrt(const LN &value)
{
	// NaN or negative - return NaN
	if (value.is_nan() || (value < 0LL))
	{
		return LN();
	}
	// Use bisection (binary search) algorithm
	LN l = 0LL, r = value, mid;
	while (r >= l)
	{
		mid = (l + r) / 2;
		if (mid * mid <= value)
		{
			l = mid + 1;
		}
		else
		{
			r = mid - 1;
		}
	}
	// The result is expected to be not greater than the real square root
	if (r * r > value)
	{
		r -= 1;
	}
	r.trim();
	return r;
}

// String representation of the LN
// This uses strings, i.e. STL, but the function is not a member of the LN class
const std::string to_string(const LN &value)
{
	// NaN
	if (value.is_nan())
	{
		return "NaN";
	}
	// Zero
	if (value.is_zero())
	{
		return "0";
	}
	// The length of the result string
	size_t slen = value.n_digits + ((value.sign == 1) ? 0 : 1);
	// Fill with spaces
	std::string res(slen, ' ');

	// Scan the digits array from the begin (less significant digit)
	int k = slen - 1;
	for (size_t i = 0; i < value.n_digits; i++)
	{
		res[k--] = value.digits[i] + 48;
	}
	// The sign
	if (value.sign == -1)
	{
		res[0] = '-';
	}
	return res;
}

// Helper function for the division operations
// We have to find a number d from 1 to 9 so that d * q <= p, (d + 1) * q > p
unsigned char get_quotient_digit(const LN &p, const LN &q)
{
	unsigned char d = 5;
	while (true)
	{
		LN qd = q * d;
		if ((qd <= p) && (qd + q > p))
		{
			return d;
		}
		if (qd > p)
		{
			d--;
		}
		else
		{
			d++;
		}
	}
}

// Division with remainder
// Returns pair (x / y, x % y)
std::pair< LN, LN > big_integer_division(const LN &x, const LN &y)
{
	// if y ==  0, return NaNs
	if (y.is_zero())
	{
		return { LN(), LN() };
	}
	// NaNs
	if (x.is_nan() || y.is_nan())
	{
		return { LN(), LN() };
	}

	// We divide positive numbers, then set the result sign
	LN xx = abs(x);
	LN yy = abs(y);

	std::pair< LN, LN > ans;
	// Classic column division
	LN p = 0LL;	   // quotient
	LN r = 0LL;	   // remainder
	// Start from the most significant digit of xx
	int i = xx.n_digits - 1;
	while (i >= 0)
	{
		// Pick up digits from xx while rr < yy
		while ((r < yy) && (i >= 0))
		{
			r = r * 10 + xx.digits[i--];
		}
		// If not enough digits, we are done
		if (r < yy)
		{
			p.sign = x.sign * y.sign;
			p.trim();
			r.trim();
			ans.first = p;
			ans.second = r;
			return ans;
		}
		// Get the next digit of the quotient
		unsigned char next_digit = get_quotient_digit(r, yy);
		// Append the digit to the quotient
		p = p * 10 + next_digit;
		// Subtract d * yy from remainder
		r -= yy * next_digit;
	}
	// Set up the result
	p.sign = x.sign * y.sign;
	p.trim();
	r.trim();
	ans.first = p;
	ans.second = r;
	return ans;
}

std::ostream &operator<<(std::ostream &stream, const LN &value)
{
	stream << to_string(value);
	return stream;
}

std::istream &operator>>(std::istream &stream, LN &value)
{
	std::string number;
	stream >> number;
	value = LN(number);
	return stream;
}

// _ln literals
LN operator"" _ln(const char *str)
{
	return LN(str);
}
