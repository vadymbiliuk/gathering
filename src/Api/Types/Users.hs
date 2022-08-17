-- {-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric  #-}
{-# LANGUAGE DataKinds #-}

module Api.Types.Users where

import           Data.Aeson                     ( (.=)
                                                , FromJSON
                                                , ToJSON(toJSON)
                                                , object
                                                )
import qualified Data.Text                     as T
import           Data.Time
import           Database.PostgreSQL.Simple     ( FromRow
                                                , ToRow
                                                )
import           Database.PostgreSQL.Simple.ToField
                                                ( ToField )
import           GHC.Generics                   ( Generic )

-- data Role = Admin | Moderator | Ordinary deriving (Eq, Ord, Show, Enum, Generic, ToJSON, ToField)

type UserId = T.Text

data User = User
    { username :: UserId
    , password :: T.Text
    }
    deriving (Generic, ToRow, FromRow, ToJSON, FromJSON)
