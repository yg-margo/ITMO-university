{
module Grammar (parseExpression) where

import Tokens
import Expression
}

%name parseExpression
%tokentype { Token }
%error { parseError }

%token
      VARIABLE               { TokenVariable $$ }
      AND                    { TokenAnd }
      OR                     { TokenOr }
      IMPLICATION            { TokenImplication }
      FALSE                  { TokenFalse }
      OPENP                  { TokenOP }
      CLOSEP                 { TokenCP }
      COMMA                  { TokenComma }

-- In order of increasing precedence
%right IMPLICATION
%left OR
%left AND

%%

Expression : Expression IMPLICATION Expression { BinaryOperator Implication $1 $3 }
	  | Expression OR Expression           { BinaryOperator Or $1 $3 }
	  | Expression AND Expression          { BinaryOperator And $1 $3 }
          | VARIABLE                           { Variable $1 }
          | FALSE                              { FalseItem }
          | OPENP Expression CLOSEP            { $2 }


{
parseError :: [Token] -> a
parseError e = error $ "Parse error " ++ (show e)
}
