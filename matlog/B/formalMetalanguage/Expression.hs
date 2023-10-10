module Expression (Expression (..), Operator (..), Context (..), Assertion (..)) where

import Data.List (intercalate)

data Expression = BinaryOperator Operator Expression Expression
                | Not Expression
                | Variable String

data Operator = And | Or | Implication

data Context = Ctx [Expression]

data Assertion = Assert Context Expression

instance Eq Operator where
    (==) op1 op2 = (show op1) == (show op2)

instance Eq Expression where
    (==) exp1 exp2 = (show exp1) == (show exp2)

instance Eq Assertion where
    (==) a b = (show a) == (show b)

instance Ord Operator where
    compare op1 op2 = compare (show op1) (show op2)

instance Ord Expression where
    compare exp1 exp2 = compare (show exp1) (show exp2)

instance Ord Assertion where
    compare a1 a2 = compare (show a1) (show a2)

    --compare (BinaryOperator op1 exp1 exp2) (BinaryOperator op2 exp3 exp4)
        -- = case compare op1 op2 of
            --EQ -> (case compare exp1 exp3 of
                --EQ -> compare exp2 exp4
                --x -> x)
            --x -> x

instance Show Assertion where
    show (Assert ctx exp) = concat [show ctx, "|-", show exp]

instance Show Context where
    show (Ctx expr) = intercalate "," (map show expr)

instance Show Expression where
    --show (BinaryOperator Implication expl expr) = concat [show expl, show Implication, show expr]
    --show (BinaryOperator And (BinaryOperator And exp1 exp2) expr)
    --    = concat ["(", show exp1, show And, show exp2
    --                         , show And, show expr, ")"]
    --show (BinaryOperator Or (BinaryOperator Or exp1 exp2) expr)
    --    = concat ["(", show exp1, show Or, show exp2
    --                         , show Or, show expr, ")"]
    --show (BinaryOperator Implication expr (BinaryOperator Implication exp1 exp2))
    --    = concat ["(", show exp1, show Implication, show exp2
    --                         , show Implication, show expr, ")"]
    show (BinaryOperator op expl expr)
        = concat ["(", show expl, show op, show expr, ")"]
    show (Not exp) = inBrackets $ '!' : show exp
    show (Variable str) = str

instance Show Operator where
    show Implication = "->"
    show Or = "|"
    show And = "&"

inBrackets x = concat ["(", x, ")"]
