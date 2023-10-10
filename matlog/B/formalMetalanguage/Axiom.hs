module Axiom where

import Expression
import Data.Bool

data AxiomCheck = AxiomSch Integer
           | NoAxiom

instance Show AxiomCheck where
    show (AxiomSch i) = "[Ax. sch. " ++ show i ++ "]"
    show NoAxiom = ""


checkAxiom1 :: Expression -> Bool
checkAxiom1 (BinaryOperator Implication a (BinaryOperator Implication b c))
    | a == c = True
    | otherwise = False
checkAxiom1 exp = False

checkAxiom2 :: Expression -> Bool
checkAxiom2 (BinaryOperator Implication ab (BinaryOperator Implication abc ac))
    = case (ab, ac) of
    (BinaryOperator Implication a1 b, BinaryOperator Implication a2 c)
        -> let bc = BinaryOperator Implication b c
           in a1 == a2 && abc == BinaryOperator Implication a1 bc
    (_, _) -> False
checkAxiom2 exp = False

checkAxiom3 :: Expression -> Bool
checkAxiom3 (BinaryOperator Implication a (BinaryOperator Implication b ab))
    = case ab of
    (BinaryOperator And a1 b1)
        -> a == a1 && b == b1
    _ -> False
checkAxiom3 exp = False

checkAxiom4 :: Expression -> Bool
checkAxiom4 (BinaryOperator Implication (BinaryOperator And a b) c)
    | a == c = True
    | otherwise = False
checkAxiom4 exp = False

checkAxiom5 :: Expression -> Bool
checkAxiom5 (BinaryOperator Implication (BinaryOperator And a b) c)
    | b == c = True
    | otherwise = False
checkAxiom5 exp = False

checkAxiom6 :: Expression -> Bool
checkAxiom6 (BinaryOperator Implication a (BinaryOperator Or b c))
    | a == b = True
    | otherwise = False
checkAxiom6 exp = False

checkAxiom7 :: Expression -> Bool
checkAxiom7 (BinaryOperator Implication a (BinaryOperator Or b c))
    | a == c = True
    | otherwise = False
checkAxiom7 exp = False

checkAxiom8 :: Expression -> Bool
checkAxiom8 (BinaryOperator Implication ac (BinaryOperator Implication bc abc))
    = case (ac, bc) of
    (BinaryOperator Implication a c1, BinaryOperator Implication b c2)
        -> let ab = BinaryOperator Or a b
           in c1 == c2 && abc == BinaryOperator Implication ab c1
    (_, _) -> False
checkAxiom8 exp = False

checkAxiom9 :: Expression -> Bool
checkAxiom9 (BinaryOperator Implication ab (BinaryOperator Implication anotb nota))
    = case (ab, anotb, nota) of
    (BinaryOperator Implication a1 b1, BinaryOperator Implication a2 (Not b2), (Not a3))
        -> a1 == a2 && a2 == a3 && b1 == b2
    (_, _, _) -> False
checkAxiom9 exp = False

checkAxiom10 :: Expression -> Bool
checkAxiom10 (BinaryOperator Implication (Not (Not a1)) a2)
    = a1 == a2
checkAxiom10 exp = False

axiom :: Expression -> AxiomCheck
axiom exp
    | checkAxiom1 exp = AxiomSch 1
    | checkAxiom2 exp = AxiomSch 2
    | checkAxiom3 exp = AxiomSch 3
    | checkAxiom4 exp = AxiomSch 4
    | checkAxiom5 exp = AxiomSch 5
    | checkAxiom6 exp = AxiomSch 6
    | checkAxiom7 exp = AxiomSch 7
    | checkAxiom8 exp = AxiomSch 8
    | checkAxiom9 exp = AxiomSch 9
    | checkAxiom10 exp = AxiomSch 10
    | otherwise = NoAxiom
