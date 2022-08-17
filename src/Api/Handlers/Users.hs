module Api.Handlers.Users where

import           Api.Types.Users                ( User )
import           Data.Pool
import           Database.PostgreSQL.Simple     ( Connection )
import           Servant                        ( Handler )

getUsers :: Pool Connection -> Handler [User]
getUsers conns = undefined

getAdmins :: Pool Connection -> Handler [User]
getAdmins conns = undefined
