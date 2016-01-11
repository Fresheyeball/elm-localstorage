module LocalStorage
    ( LocalStorage
    , get
    , set ) where

{-|
# Local Storage
@docs LocalStorage, get, set
-}

import Native.LocalStorage
import Task exposing (..)

{-|
A record with the necissary ingredients to
save and restore from `localstorage`. Since there
is not generic way to go from an Elm type to
something storable in `localstorage`, we always
store a string. Included here are functions
to parse to and from that string. Usually Json.
-}
type alias LocalStorage a =
    { key : String
    , decode : String -> Result String a
    , encode : a -> String
    }


getRaw : String -> Task String String
getRaw =
    Native.LocalStorage.get


{-|
Read a value out of `localstorage`, which can fail if
the value found cannot be parsed to its Elm type.
-}
get : LocalStorage a -> Task String a
get { key, decode } =
    getRaw key
        `andThen` (decode >> fromResult)


setRaw : String -> String -> Task x ()
setRaw =
    Native.LocalStorage.set

{-|
Set a value in `localstorage`.
This will overwrite or create a value at the given key.
-}
set : LocalStorage a -> a -> Task x ()
set { key, encode } =
    encode >> setRaw key
