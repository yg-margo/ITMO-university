{
module Tokens where
}

%wrapper "basic"

$alpha = [A-Z]
$variableSymbols = [$alpha 0-9 \']
$spaces = [\ \t \r]

tokens :-
  $white+                       ;
  \(                            { \x -> TokenOP }
  \)                            { \x -> TokenCP }
  \|                            { \x -> TokenOr }
  \,                            { \x -> TokenComma }
  &                             { \x -> TokenAnd }
  "_|_"                         { \x -> TokenFalse }
  "->"                          { \x -> TokenImplication }
  $alpha[$variableSymbols]*     { \x -> TokenVariable x }

{
data Token
      = TokenVariable String
      | TokenAnd
      | TokenOr
      | TokenComma
      | TokenFalse
      | TokenImplication
      | TokenOP
      | TokenCP
      deriving Show
}
