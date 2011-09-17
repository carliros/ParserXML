module Main where

import System.Environment
import ParserGenericXML
import NTree
import FormatTree

main :: IO()
main = do args <- getArgs
          let fn = getInput args
          input <- readFile fn
          let ast = parser fn input
          formatTree ast
   where getInput []      = ""
         getInput (inp:_) = inp
