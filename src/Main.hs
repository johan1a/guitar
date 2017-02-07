import qualified Data.ByteString.Lazy as BL
import Data.Binary.Get
import Data.Word
import Data.Int
 
deserialiseHeader :: Get (BL.ByteString,BL.ByteString, Word32)
deserialiseHeader = do
  len <- getWord8
  version <- getLazyByteString $ word8ToInt64 len 
  plen <- getLazyByteStringNul
  chksum <- getWord32be
  return (version,plen, chksum)


word8ToInt64 :: Word8 -> Int64
word8ToInt64  w = fromIntegral w

 
main :: IO ()
main = do
  input <- BL.readFile "hey_joe.gp5"
  print $ runGet deserialiseHeader input


