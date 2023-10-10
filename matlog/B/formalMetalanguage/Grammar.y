{
module Grammar (parseAssertion) where

import Tokens
import Expression
}

%name parseAssertion
%tokentype { Token }
%error { parseError }

%token
      VARIABLE               { TokenVariable $$ }
      AND                    { TokenAnd }
      OR                     { TokenOr }
      IMPLICATION            { TokenImplication }
      ASSERTION              { TokenAssertion }
      NOT                    { TokenNot }
      OPENP                  { TokenOP }
      CLOSEP                 { TokenCP }
      COMMA                  { TokenComma }

-- In order of increasing precedence
%nonassoc ASSERTION
%right IMPLICATION
%left OR
%left AND
%nonassoc NOT

%%

Assertion : ASSERTION Expression             { Assert (Ctx []) $2 }
	  | Context ASSERTION Expression     { Assert $1 $3 }

Context : Expression                         { Ctx [$1] }
	| Expression COMMA Context           { Ctx ($1:(case $3 of Ctx expr -> expr)) }

Expression : Expression IMPLICATION Expression { BinaryOperator Implication $1 $3 }
	  | Expression OR Expression           { BinaryOperator Or $1 $3 }
	  | Expression AND Expression          { BinaryOperator And $1 $3 }
          | VARIABLE                           { Variable $1 }
          | NOT Expression                     { Not $2 }
          | OPENP Expression CLOSEP            { $2 }


{
parseError :: [Token] -> a
parseError e = error $ "Parse error " ++ (show e)
}
