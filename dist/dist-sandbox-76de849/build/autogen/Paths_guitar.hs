module Paths_guitar (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/johan/dev/guitar/.cabal-sandbox/bin"
libdir     = "/home/johan/dev/guitar/.cabal-sandbox/lib/x86_64-linux-ghc-7.10.3/guitar-0.1.0.0-69t7Fv2kmuoJPx8aWUhSGW"
datadir    = "/home/johan/dev/guitar/.cabal-sandbox/share/x86_64-linux-ghc-7.10.3/guitar-0.1.0.0"
libexecdir = "/home/johan/dev/guitar/.cabal-sandbox/libexec"
sysconfdir = "/home/johan/dev/guitar/.cabal-sandbox/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "guitar_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "guitar_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "guitar_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "guitar_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "guitar_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
