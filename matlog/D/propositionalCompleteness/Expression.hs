module Expression (Expression (..), Operator (..), Context (..), Statement (..), neg) where

import Data.List (intercalate)

data Expression = BinaryOperator Operator Expression Expression
                | Variable String
                | FalseItem deriving (Eq, Ord)

data Operator = And | Or | Implication deriving (Eq, Ord)

newtype Context = Context [Expression] deriving (Eq, Ord)

data Statement = Statement Context Expression deriving (Eq, Ord)

neg :: Expression -> Expression
neg a = BinaryOperator Implication a FalseItem

instance Show Context where
    show (Context expr) = intercalate "," (map show expr)

instance Show Expression where
    show (BinaryOperator op expl expr)
        = concat ["(", show expl, show op, show expr, ")"]
    show FalseItem = "_|_"
    show (Variable str) = str

instance Show Statement where
    show (Statement context expression) = show context ++ "|-" ++ show expression

instance Show Operator where
    show Implication = "->"
    show Or = "|"
    show And = "&"
