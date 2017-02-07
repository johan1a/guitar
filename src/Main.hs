import qualified Data.ByteString.Lazy as BL
import Data.Binary.Get
import Data.Word
import Data.Int
import Debug.Trace

traceThis :: (Show a) => a -> a
traceThis x = trace (show x) x



 
deserialiseHeader :: Get (BL.ByteString,BL.ByteString, BL.ByteString)
deserialiseHeader = do
  version <- readStringByte 30
  name <- readStringByteSizeOfInteger
  return (version, name, name)

readStringByte max = do
    len <- getWord8
    str <- readString max $ fromIntegral len
    return str

readString :: Int -> Int -> Get (BL.ByteString)
readString max len = do
    str <- getLazyByteString $ fromIntegral len
    ignore <- skip $ max - len
    return str

readStringByteSizeOfInteger :: Get (BL.ByteString)
readStringByteSizeOfInteger = do
    size <- getWord32le
    readStringByte $ (fromIntegral size)- 1 


 
main :: IO ()
main = do
  input <- BL.readFile "hey_joe.gp5"
  print $ runGet deserialiseHeader input


