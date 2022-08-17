{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Database.Connection where

import           Configuration.Dotenv
import           Control.Exception              ( bracket )
import           Data.ByteString                ( ByteString )
import           Data.Pool
import           Data.Time                      ( NominalDiffTime )
import           Database.PostgreSQL.Simple
import           System.Environment             ( getEnv )

type DBConnectionString = ByteString

initDB :: DBConnectionString -> IO ()
initDB connstr = bracket (connectPostgreSQL connstr) close $ \conn -> do
    execute_ conn "CREATE TABLE IF NOT EXISTS users ()"
    return ()

initConnectionPool :: DBConnectionString -> IO (Pool Connection)
initConnectionPool connStr = do
    loadFile defaultConfig
    stripes :: Int                   <- read <$> getEnv "DB_CONNECTION_STRIPES"
    unusedConnectionLimit :: Integer <- read
        <$> getEnv "DB_UNUSED_CONNECTIONS_TIME_LIMIT"
    maxNumberOfConnections :: Int <- read
        <$> getEnv "DB_MAX_NUMBER_OF_CONNECTIONS"
    createPool (connectPostgreSQL connStr)
               close
               stripes
               (fromInteger unusedConnectionLimit)
               maxNumberOfConnections
