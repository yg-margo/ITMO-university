module Main where

import Grammar
import Tokens
import Proving

process :: String -> String
process input = output ++ "\n"
    where
        result = (solve . parseExpression . alexScanTokens) input
        output = case result of
            Left x -> show x
            Right x -> show x


main :: IO ()
main = interact process
