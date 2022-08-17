{-# LANGUAGE OverloadedRecordDot #-}

module Service.Authorisation where

import           Crypto.BCrypt
import           Data.Text.Encoding as TSE
import           Api.Types.Users                      ( User(..) )


authoriseUser :: User -> Maybe User
authoriseUser x = do
    let isValidPassword = validatePassword $ TSE.encodeUtf8 x.password
    return x
