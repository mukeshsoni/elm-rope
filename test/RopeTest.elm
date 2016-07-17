module RopeTest exposing (..)

import ElmTest exposing (..)
import Rope exposing (..)

tests : Test
tests =
    suite "A Test Suite"
        [ test "Addition"
            <| assertEqual (add2 3 7) 11
        , test "This test should fail"
            <| assert True
        ]
