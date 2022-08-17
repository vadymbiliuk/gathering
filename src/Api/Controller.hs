{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE OverloadedStrings #-}


module Api.Controller where

import           Api.Types.Users
import           Data.Text                      ( Text )
import           GHC.Base                       ( Symbol )
import           Servant.API
import           Servant.Server

type GatheringAPI (name :: Symbol) a i = name :>
  (                             Get '[JSON] [a]
  :<|> Capture "id" i        :> Get '[JSON] a
  :<|> ReqBody '[JSON] a     :> Post '[JSON] NoContent
  )

gatheringServer
    :: Handler [a]
    -> (i -> Handler a)
    -> (a -> Handler NoContent)
    -> Server (GatheringAPI name a i)
gatheringServer listAs getA postA = listAs :<|> getA :<|> postA

usersServer :: Server (GatheringAPI "users" User UserId)
usersServer = gatheringServer
    (return [])
    (\userId -> return $ User "username" "password")
    (\_user -> return NoContent)

type API = GatheringAPI "users" User UserId
