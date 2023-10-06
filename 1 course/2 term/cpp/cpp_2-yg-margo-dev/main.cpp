#include "ln.h"
#include "return_codes.h"

#include <map>
#include <vector>

// Operation codes
enum ops
{
	OP_ADD = 0,
	OP_SUBTRACT = 1,
	OP_MULTIPLY = 2,
	OP_DIVIDE = 3,
	OP_MOD = 4,
	OP_LT = 5,
	OP_GT = 6,
	OP_LE = 7,
	OP_GE = 8,
	OP_NE = 9,
	OP_EQ = 10,
	OP_MINUS = 11,
	OP_SQRT = 12
};

// Useful constants
const LN LN_ZERO(0);
const LN LN_ONE(1);

int performOperation(const int op, std::vector< LN > &stack);

int main(int argc, char **argv)
{
	// Return code
	int rc = ERROR_SUCCESS;

	// We expect 2 arguments: input file and output file
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
	std::ofstream outStream;

	if (rc == ERROR_SUCCESS)
	{
		// Create output file
		inFileName = argv[1];
		outFileName = argv[2];
		outStream.open(outFileName);
		if (!outStream.is_open())
		{
			// Error - display message and set return code
			std::cerr << "Error creating output file '" << outFileName << "'" << std::endl;
			rc = ERROR_FILE_NOT_FOUND;
		}
	}

	if (rc == ERROR_SUCCESS)
	{
		// Open input file
		inStream.open(inFileName);
		if (!inStream.is_open())
		{
			std::cerr << "Error opening input file '" << inFileName << "'" << std::endl;
			outStream.close();
			rc = ERROR_FILE_NOT_FOUND;
		}
	}

	// Map operation symbols to codes
	std::map< std::string, int > operations{
		{ "+", OP_ADD }, { "-", OP_SUBTRACT }, { "*", OP_MULTIPLY }, { "/", OP_DIVIDE }, { "%", OP_MOD },
		{ "<", OP_LT },	 { ">", OP_GT },	   { "<=", OP_LE },		 { ">=", OP_GE },	 { "!=", OP_NE },
		{ "==", OP_EQ }, { "_", OP_MINUS },	   { "~", OP_SQRT }
	};

	// Create stack for operands
	std::vector< LN > stack;
	// Reserve some space to avoid excess reallocations
	stack.reserve(1000);
	// Variable to store a line from the input file
	std::string term;

	// Main loop. Read next line from the input file
	while ((rc == ERROR_SUCCESS) && (std::getline(inStream, term)))
	{
		if (operations.count(term) > 0)
		{
			// The term is an operation symbol
			try
			{
				// Trying to execute the operation
				rc = performOperation(operations[term], stack);
			} catch (std::exception ex)
			{
				// Handle exception
				std::cerr << "Error performing operation " << term << ": '" << ex.what() << "'" << std::endl;
				rc = ERROR_INVALID_DATA;
			}
		}
		else
		{
			// Term is an operand. Try to convert it to LN and push on top of the stack
			try
			{
				stack.push_back(LN(term));
			} catch (std::exception ex)
			{
				std::cerr << "Error creating LN from '" << term << "': " << ex.what() << std::endl;
				rc = ERROR_INVALID_DATA;
			}
		}
	}

	// Close the input file
	inStream.close();

	// Dump stack to the output file
	for (int i = stack.size() - 1; i >= 0; i--)
	{
		outStream << to_string(stack[i]) << std::endl;
	}
	// Close the output file
	outStream.close();
	// Clear the stack
	stack.clear();

	return rc;
}

// Execute an operation
// Parameters:
// - op - the operation code
// - stack - the stack with operation arguments
// Returns an error code
int performOperation(const int op, std::vector< LN > &stack)
{
	int rc = ERROR_SUCCESS;
	// Stack is empty
	if (stack.size() < 1)
	{
		std::cerr << "No data for operation on stack" << std::endl;
		rc = ERROR_INVALID_DATA;
	}
	// The operation requires 2 arguments, we got only one
	else if ((op < OP_MINUS) && (stack.size() < 2))
	{
		std::cerr << "Not enough operands for binary operation on stack" << std::endl;
		rc = ERROR_INVALID_DATA;
	}

	// Argument on top of the stack
	// It will we the only argument for unary operations
	// and the second (right) argument for binary ones
	LN op2(stack.back());
	stack.pop_back();
	LN op1;
	if (op < OP_MINUS)
	{
		// If the operation is binary, pick up the first (left) argument
		op1 = stack.back();
		stack.pop_back();
	}

	if (rc == ERROR_SUCCESS)
	{
		// Analyze the op code and perform the operation
		try
		{
			switch (op)
			{
			case OP_ADD:
				stack.push_back(op1 + op2);
				break;
			case OP_SUBTRACT:
				stack.push_back(op1 - op2);
				break;
			case OP_MULTIPLY:
				stack.push_back(op1 * op2);
				break;
			case OP_DIVIDE:
				stack.push_back(op1 / op2);
				break;
			case OP_MOD:
				stack.push_back(op1 % op2);
				break;
			case OP_LT:
				stack.push_back((op1 < op2) ? LN_ONE : LN_ZERO);
				break;
			case OP_GT:
				stack.push_back((op1 > op2) ? LN_ONE : LN_ZERO);
				break;
			case OP_LE:
				stack.push_back((op1 <= op2) ? LN_ONE : LN_ZERO);
				break;
			case OP_GE:
				stack.push_back((op1 >= op2) ? LN_ONE : LN_ZERO);
				break;
			case OP_NE:
				stack.push_back((op1 != op2) ? LN_ONE : LN_ZERO);
				break;
			case OP_EQ:
				stack.push_back((op1 == op2) ? LN_ONE : LN_ZERO);
				break;
			case OP_MINUS:
				stack.push_back(-op2);
				break;
			case OP_SQRT:
				stack.push_back(sqrt(op2));
				break;
			default:
				// Unknown operation
				std::cerr << "Unknown operation met" << std::endl;
				rc = ERROR_INVALID_DATA;
				break;
			}
		} catch (std::exception ex)
		{
			// Exception handling
			std::cerr << "Error performing operation " << op << "'" << ex.what() << "'" << std::endl;
			rc = ERROR_INVALID_DATA;
		}
	}

	return rc;
}
