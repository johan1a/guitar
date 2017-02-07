import qualified Data.ByteString.Lazy as BL
import Data.Binary.Get
import Data.Word
import Data.Int
 
deserialiseHeader :: Get (BL.ByteString,Word8, Word8)
deserialiseHeader = do
  version <- readBytes 30
  len2 <- getWord8
  what <- getWord8
  return (version,what, len2)

readBytes max = do
    len <- getWord8
    str <- readBytesLen max $ fromIntegral len
    return str

readBytesLen :: Int -> Int -> Get (BL.ByteString)
readBytesLen max len = do
    str <- getLazyByteString $ fromIntegral len
    ignore <- skip $ max - len
    return str

read2 :: Int64 -> Int64 -> Get BL.ByteString
read2 max len = getLazyByteString len 


word8ToInt64 :: Word8 -> Int64
word8ToInt64  = fromIntegral 

 
main :: IO ()
main = do
  input <- BL.readFile "hey_joe.gp5"
  print $ runGet deserialiseHeader input


