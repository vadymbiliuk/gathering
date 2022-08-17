{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds #-}

module Api.Application where

import           Api.Controller
import qualified Api.Handlers.Users            as HUsers
import           Configuration.Dotenv
import           Control.Concurrent
import           Control.Exception              ( bracket )
import           Control.Monad.IO.Class
import           Data.ByteString.Char8          ( pack )
import           Data.Pool
import           Database.Connection            ( initConnectionPool
                                                , initDB
                                                )
import           Database.PostgreSQL.Simple
import           Network.Wai
import           Network.Wai.Handler.Warp
import           Servant
import           Servant.Client
import           System.Environment             ( getEnv )

api :: Proxy API
api = Proxy

server :: Pool Connection -> Server API
server conns = usersServer

runApp :: Pool Connection -> IO ()
runApp conns = run 8080 (serve api $ server conns)

app :: IO ()
app = do
    loadFile defaultConfig
    connstr <- pack <$> getEnv "POSTGRES_CONNECTION_URL"
    pool    <- initConnectionPool connstr

    initDB connstr

    -- | Run application.
    runApp pool
