module Rope exposing (Rope, build, buildWithMaxLeafCapacity, concat, getSize, toString, atIndex, getCharAt, split, insert, delete, substr)
{-|
This module implements the rope data structure which is used to store and manipulate large strings.
It's more performant and memory efficient for operations like inserting a substring into a string,
concatenating two strings etc.

# Definition
@docs Rope

# Common Helpers
@docs build, buildWithMaxLeafCapacity, concat, getSize, toString, atIndex, getCharAt, split, insert, delete, substr
-}
import String
import Array

{-|
Rope type is used to store strings of arbitrary length. It's implemented as a
binary tree. The strings themselves are stored in the leaves of the tree.
The intermediary nodes store weight, which help navigating the tree when trying to
split the tree or perform other operations like insert another string in between or pull out a substring
from the string
-}
type Rope
    = LeafRopeNode {weight: Int, text: String}
    | EmptyRopeNode
    | RopeNode {weight: Int} Rope Rope

-- will use it later to break string into multiple leaf nodes in build function
maxLeafNodeCapacity : number
maxLeafNodeCapacity = 10

{-|
Build a rope, give a string. Takes `maxLeafNodeCapacity` as 10 (max length of a string stored in leaf node).
-}
build : String -> Rope
build str = buildWithMaxLeafCapacity maxLeafNodeCapacity str

{-|
Like `build`, but user can specify the max capacity of leaf node.
-}
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

{-|Concatenate two ropes into a single rope.-}
concat : Rope -> Rope -> Rope
concat r1 r2
    = RopeNode {weight = getSize r1} r1 r2

{-|Returns the length of the string contained in the rope.-}
getSize : Rope -> Int
getSize r = getSize' r 0

getSize' : Rope -> Int -> Int
getSize' r acc =
    case r of
        EmptyRopeNode -> acc
        LeafRopeNode {weight} -> weight + acc
        RopeNode _ r1 r2 -> (getSize r1) + (getSize r2)

{-|
Returns the string which the rope has encoded.
-}
toString : Rope -> String
toString r =
    case r of
        EmptyRopeNode -> ""
        LeafRopeNode {text} -> text
        RopeNode _ r1 r2 -> toString r1 ++ toString r2

{-|
Returns the character at a given index in the string encoded in the rope. Returns `Nothing`, if the index is unreachable.
-}
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

{-|Get character at ith position in the string. If ith position doesnt' exist, return Nothing-}
getCharAt : String -> Int -> Maybe Char
getCharAt s i =
    Array.get i (Array.fromList (String.toList s))

{-|
Splits the rope at the given index into two ropes. Split forms the basis of insertion operation.
-}
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

{-|
inserts a string in the rope at the given index
-}
insert : Int -> String -> Rope -> Rope
insert i str r =
    let
        (r1, r2) = split i r
    in
        concat (concat r1 (LeafRopeNode {weight = String.length str, text = str})) r2

{-|
deletes a substring from the rope given a startIndex and the length of substring to be deleted.
E.g. assume r is a Rope which has the string `I blamah you`, then `Rope.delete 3 3 r` will delete
"lam" from the rope and return another rope which contains `i bah you`
-}
delete : Int -> Int -> Rope -> Rope
delete i j r =
    if i < 0 then
        r
    else if (i + j) > getSize r then
        LeafRopeNode {weight=0, text=""}
    else
        let
            (r1, r2') = split i r
            (r2, r3) = split j r2'
        in
            concat r1 r3

{-|
finds substring from index i for length j
-}
substr : Int -> Int -> Rope -> String
substr i j r =
    if i < 0 then
        ""
    else if (i + j) > getSize r then
        toString r
    else
        let
            (r1, r2') = split i r
            (r2, r3) = split j r2'
        in
            toString r2

-- balance : Rope -> Rope
