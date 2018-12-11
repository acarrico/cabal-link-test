{-# LANGUAGE ForeignFunctionInterface #-}
module Main where

foreign import ccall "hello.h hello" hello :: IO()

main = do hello

