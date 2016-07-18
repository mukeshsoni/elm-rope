module Rope exposing (..)
import String
import Char
import Array

type Rope
    = LeafRopeNode {weight: Int, text: String}
    | EmptyRopeNode
    | RopeNode {weight: Int} Rope Rope

-- will use it later to break string into multiple leaf nodes in build function
maxLeafNodeCapacity = 10

-- build a rope, give a string
build : String -> Rope
build str = buildWithMaxLeafCapacity maxLeafNodeCapacity str

buildWithMaxLeafCapacity : Int -> String -> Rope
buildWithMaxLeafCapacity capacity str =
    if String.length str > maxLeafNodeCapacity then -- break into left-right nodes
        let
            stringLength = String.length str
            leftRopeLength = floor  ((toFloat stringLength) / 2)
            rightRopeLength = stringLength - leftRopeLength
        in
            RopeNode {weight = leftRopeLength} (buildWithMaxLeafCapacity capacity <| String.left leftRopeLength str) (buildWithMaxLeafCapacity capacity <| String.right rightRopeLength str)
    else
        LeafRopeNode {weight = String.length str, text = str}

concat : Rope -> Rope -> Rope
concat r1 r2
    = RopeNode {weight = getSize r1} r1 r2

getSize : Rope -> Int
getSize r = getSize' r 0

getSize' : Rope -> Int -> Int
getSize' r acc =
    case r of
        EmptyRopeNode -> acc
        LeafRopeNode {weight} -> weight + acc
        RopeNode _ r1 r2 -> (getSize r1) + (getSize r2)

toString : Rope -> String
toString r =
    case r of
        EmptyRopeNode -> ""
        LeafRopeNode {text} -> text
        RopeNode _ r1 r2 -> toString r1 ++ toString r2

atIndex : Rope -> Int -> Maybe Char
atIndex r i =
    case r of
        EmptyRopeNode -> Nothing
        LeafRopeNode {weight, text} ->
            if weight >= i then
                getCharAt text i
            else
                Nothing
        RopeNode {weight} r1 r2 ->
            if weight >= i then
                atIndex r1 i
            else
                atIndex r2 (i - weight)

getCharAt : String -> Int -> Maybe Char
getCharAt s i =
    Array.get i (Array.fromList (String.toList s))

split : Int -> Rope -> (Rope, Rope)
split i r =
    case r of
        EmptyRopeNode -> (EmptyRopeNode, EmptyRopeNode)
        LeafRopeNode {weight, text} ->
            if i == 0 then -- split point is right at the start of this node
                (EmptyRopeNode, LeafRopeNode {weight=weight, text=text})
            else -- split the node itself
                (LeafRopeNode {weight = i, text = String.left i text}, LeafRopeNode {weight = weight - i, text = String.right (weight - i) text})
        RopeNode {weight} r1 r2 ->
            if weight > i then
                let
                    (r11, r12) = split i r1
                in
                    (r11, RopeNode {weight = getSize r12} r12 r2)
            else
                let
                    (r21, r22) = split (i - weight) r2
                in
                    (RopeNode {weight=getSize r1} r1 r21, r22)

-- insert : Rope -> Int -> Rope
-- insert r i
-- balance : Rope -> Rope
-- romoveAt : Rope -> Int -> Rope
-- charAt : Rope -> Int -> Char
