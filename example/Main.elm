module Main where

import Json.Decode exposing ((:=))
import Json.Encode as Encode
import LocalStorage exposing (..)

type Foo = Bar Int | Baz String

type alias Elvis =
    { foo : Foo
    , zip : String }

encode : Elvis -> String
encode elvis =
    let
        foo foo' =
            (case foo' of
                Bar int    -> ("Bar", Encode.int int)
                Baz string -> ("Baz", Encode.string string))
            |> flip (::) []
            |> Encode.object
    in
        Encode.object
            [ ("foo", foo elvis.foo )
            , ("zip", Encode.string elvis.zip) ]
        |> Encode.encode 0

decode : String -> Result String Elvis
decode string =
    let
        bar = Json.Decode.object1 Bar
            ("Bar" := Json.Decode.int)
        baz = Json.Decode.object1 Baz
            ("Baz" := Json.Decode.string)
    in
        Json.Decode.object2 Elvis
            ("foo" := Json.Decode.oneOf [bar, baz])
            ("zip" := Json.Decode.string)
        |> flip Json.Decode.decodeString string


crypt : LocalStorage Elvis
crypt =
    LocalStorage
        "alive"
        decode
        encode
