import qualified Data.ByteString.Lazy as BL
import Data.Binary.Get
import Data.Word
import Data.Int
import Debug.Trace

traceThis :: (Show a) => a -> a
traceThis x = trace (show x) x


data SongInfo = SongInfo
    { name :: BL.ByteString
    , version :: BL.ByteString
    , artist ::  BL.ByteString
    , album :: BL.ByteString
    , author :: BL.ByteString
    , copyright :: BL.ByteString
    , tabAuthor :: BL.ByteString
    , comments :: BL.ByteString
    } deriving (Show)

data Lyrics = Lyrics 
    {lyricTrack :: Int
    , lyricFrom :: Int
    , lyrics ::  BL.ByteString
    }
    deriving (Show)

readGP5 = do
    songInfo <- readSongInfo
    lyrics <- readLyrics
    return (songInfo, lyrics)

readLyrics = do
   lyricTrack <- readInt 
   lyricFrom <- readInt
   lyrics <- readStringInteger
   a <- readInt
   b <- readStringInteger
   a <- readInt
   b <- readStringInteger
   a <- readInt
   b <- readStringInteger
   a <- readInt
   b <- readStringInteger
   return $ Lyrics (fromIntegral lyricTrack) (fromIntegral lyricFrom) lyrics

readStringInteger :: Get BL.ByteString
readStringInteger = do
    size <- readInt
    readString (fromIntegral size) (fromIntegral size)
 
readSongInfo :: Get SongInfo
readSongInfo = do
  fileVersion <- readStringByte 30
  name <- readStringByteSizeOfInteger
  version <- readStringByteSizeOfInteger
  artist <- readStringByteSizeOfInteger 
  album <- readStringByteSizeOfInteger 
  author <- readStringByteSizeOfInteger 
  skip2 <- readStringByteSizeOfInteger 
  copyright <- readStringByteSizeOfInteger 
  tabAuthor <- readStringByteSizeOfInteger 
  skip3 <- readStringByteSizeOfInteger 
  comments <- readComments
  return (SongInfo name version artist album author copyright tabAuthor comments)

readComments :: Get BL.ByteString
readComments = do
    nbrComments <- readInt
    readComments1 $ fromIntegral nbrComments

readComments1 :: Int -> Get BL.ByteString
readComments1 0 = return BL.empty
readComments1 k = do
    comment <- readStringByteSizeOfInteger
    tail    <- readComments1 $ k - 1
    return $ (BL.append comment tail)

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
    size <- readInt
    readStringByte $ (fromIntegral size)- 1 


readInt = getWord32le

 
main :: IO ()
main = do
  input <- BL.readFile "hey_joe.gp5"
  print $ runGet readGP5 input


