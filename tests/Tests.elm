module Tests exposing (..)

import Test exposing (..)
import Expect
import String


all : Test
all =
    describe "A Test Suite"
        [ test "Hello world" <|
            \() ->
                Expect.equal 1 1
        ]
