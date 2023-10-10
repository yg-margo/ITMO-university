module Main where

import Grammar
import Tokens
import Expression
import Proof
import Data.List

alists :: [Assertion] -> [[Assertion]]
alists assertions =
    map (\i -> take i assertions) [1..length assertions]

process :: String -> String
process input =
    let assertions = map (parseAssertion . alexScanTokens) (lines input) in
    let proofs = getProofs assertions in
    unlines proofs

main :: IO ()
main = interact process
