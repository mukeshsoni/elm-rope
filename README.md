#elm-make

** WIP

Rope data structure implemented in elm. Implemented as per the specs in this wikipedia article [https://en.wikipedia.org/wiki/Rope_(data_structure](https://en.wikipedia.org/wiki/Rope_(data_structure))

Motivation for rope data structure, from the wikipedia article -

>  a rope, or cord, is a data structure composed of smaller strings that is used for efficiently storing and manipulating a very long string. For example, a text editing program may use a rope to represent the text being edited, so that operations such as insertion, deletion, and random access can be done efficiently

### API
---
#### build
`build : String -> Rope`

Build a rope, give a string. Takes `maxLeafNodeCapacity` as 10 (max length of a string stored in leaf node).

#### buildWithMaxLeafCapacity
`buildWithMaxLeafCapacity : Int -> String -> Rope`

Like `build`, but user can specify the max capacity of leaf node.

#### concat
`concat : Rope -> Rope -> Rope`

Concatenate two ropes into a single rope.

#### getSize
`getSize : Rope -> Int`

Returns the length of the string contained in the rope.

#### toString
`toString : Rope -> String`

Returns the string which the rope has encoded.

#### atIndex
`atIndex : Rope -> Int -> Maybe Char`

Returns the character at a given index in the string encoded in the rope. Returns `Nothing`, if the index is unreachable.
