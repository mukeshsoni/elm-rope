module RopeTests exposing (..)

import ElmTest exposing (..)

import Rope

main : Program Never
main
    = runSuite tests

-- a sample rope
sampleRope : Rope.Rope
sampleRope = Rope.RopeNode {weight = 10} (Rope.LeafRopeNode {weight = 10, text = "Iamallgood"}) (Rope.LeafRopeNode {weight = 10, text = "ormaybenot"})

sampleRope2 : Rope.Rope
sampleRope2 =
    Rope.RopeNode
        {weight = 10}
        (Rope.LeafRopeNode {weight = 5, text = "What is your name, "})
        (Rope.LeafRopeNode {weight = 8, text = "punk?"})

tests : Test
tests =
    suite "elm-rope tests"
        [ test "rope getSize"
            <| assertEqual (Rope.getSize sampleRope) 20
        , test "rope getSize using build"
            <| assertEqual (Rope.getSize (Rope.build "Iamallgoodormaybenot")) 20
        , test "rope concatenation"
            <| assertEqual
                (Rope.getSize (Rope.concat sampleRope sampleRope2))
                (Rope.getSize sampleRope + Rope.getSize sampleRope2)
        , test "toString"
            <| assertEqual (Rope.toString sampleRope) "Iamallgoodormaybenot"
        , test "toString"
            <| assertEqual (Rope.toString sampleRope2) "What is your name, punk?"
        , test "rope building"
            <| assertEqual (Rope.toString (Rope.build "hey there")) "hey there"
        , test "get char at index"
            <| assertEqual (Rope.atIndex sampleRope 3) (Just 'a')
        , test "get char at index"
            <| assertEqual (Rope.atIndex sampleRope 14) (Just 'y')
        ]
