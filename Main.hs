




-- Main.hs

{-# LANGUAGE OverloadedStrings
           , QuasiQuotes
           , TemplateHaskell
           , ViewPatterns
           , TypeFamilies
           #-}

module Main
    ( main
    
    ) where

      import Control.Concurrent.STM
      import Data.Text
      import Yesod



      data GetIp = GetIp (TVar String)

      mkYesod "GetIp" [parseRoutes|
      / HomeR GET
      /set/#Text SetR POST
      |]

      instance Yesod GetIp where

      getHomeR :: Handler Text
      getHomeR = do
        GetIp ip <- getYesod
        i <- liftIO $ atomically $ readTVar ip
        return $ pack i

      postSetR :: Text -> Handler Text
      postSetR ip = do
        token <- lookupHeader "Token"
        if token == Just "sssta-getip2"
          then do
            GetIp i <- getYesod
            liftIO $ atomically $ writeTVar i $ unpack ip
            return "0"
          else return "1"


      main :: IO()
      main = do
        ip <- newTVarIO ""
        warp 3000 $ GetIp ip
