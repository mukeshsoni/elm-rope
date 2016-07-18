#elm-rope

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

#### split
`split : Int -> Rope -> (Rope, Rope)`

Splits the rope at the given index into two ropes. Split forms the basis of insertion operation.

#### insert
`insert : Int -> String -> Rope -> Rope`

inserts a string in the rope at the given index

#### delete
`delete : Int -> Int -> Rope -> Rope`

deletes a substring from the rope given a startIndex and the length of substring to be deleted. E.g. assume r is a Rope which has the string `I blamah you`, then `Rope.delete 3 3 r` will delete "lam" from the rope and return another rope which contains `i bah you`

### Development

1. Install elm dependencies - `elm package install`
2. Go to tests folder and install node dependencies - `npm i`
3. In tests folder, install elm test dependencies - `elm package install`
4. Run tests - `npm test`
