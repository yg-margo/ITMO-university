module Hypothesis where

import Expression
import Data.List

data HypothesisCheck = NoHypothesis
                     | Hypothesis Int

instance Show HypothesisCheck where
    show NoHypothesis = ""
    show (Hypothesis n) = "[Hyp. " ++ show (n+1) ++ "]"

hypothesis :: Assertion -> HypothesisCheck
hypothesis (Assert (Ctx ctx) exp) =
    case elemIndex exp ctx of
        Just i -> Hypothesis i
        Nothing -> NoHypothesis
