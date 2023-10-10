{-# LANGUAGE InstanceSigs #-}
module CounterExample (CounterExample (..), VariableEstimate (..), variableMappings, evaluate, findCounterExample) where
-- module Expression (Expression (..), Operator (..), Context (..), Statement (..)) where

import Expression
import Data.Map (Map)
import qualified Data.Map as Map
import Data.List (nub, find, intercalate)
import Data.Maybe (fromJust)

newtype VariableEstimate = VariableEstimate (Map String Bool)

newtype CounterExample = CounterExample VariableEstimate

variableMappings :: Expression -> [VariableEstimate]
variableMappings expr =
    makeMappings [Map.empty] uniqueVariables
    where
        makeMappings :: [Map String Bool] -> [String] -> [VariableEstimate]
        makeMappings m [] = map VariableEstimate m
        makeMappings m (var:other) =
            let m1 = map (Map.insert var False) m
                m2 = map (Map.insert var True) m
            in  makeMappings m1 other ++ makeMappings m2 other

        uniqueVariables :: [String]
        uniqueVariables = nub $ nonUniqueVariables expr

        nonUniqueVariables :: Expression -> [String]
        nonUniqueVariables FalseItem = []
        nonUniqueVariables (Variable x) = [x]
        nonUniqueVariables (BinaryOperator _ left right) = nonUniqueVariables left ++ nonUniqueVariables right

evaluate :: VariableEstimate -> Expression -> Bool
evaluate _ FalseItem = False
evaluate (VariableEstimate mapping) (Variable var) = fromJust $ Map.lookup var mapping
evaluate vars (BinaryOperator operator left right) =
    let leftResult = evaluate vars left
        rightResult = evaluate vars right
    in  case operator of
        Implication -> not leftResult || rightResult
        And -> leftResult && rightResult
        Or -> leftResult || rightResult

findCounterExample :: Expression -> Maybe CounterExample
findCounterExample expr = CounterExample <$> find (\vars -> not $ evaluate vars expr) (variableMappings expr)

instance Show CounterExample where
    show :: CounterExample -> String
    show (CounterExample (VariableEstimate mapping)) = "Formula is refutable [" ++ body ++ "]"
        where
            body :: String
            body = intercalate "," $ Map.elems $ Map.mapWithKey (\var value -> var ++ ":=" ++ boolString value) mapping

            boolString :: Bool -> String
            boolString True = "T"
            boolString False = "F"

instance Show VariableEstimate where
    show :: VariableEstimate -> String
    show (VariableEstimate m) = show m