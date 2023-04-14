# dogbunnypuzzle-quint

A specification of the dogbunnypuzzle concept in Quint.

An image of the original Puzzle can be found here:
![Dog Bunny Puzzle](https://external-preview.redd.it/hs2xR3mDycJvc-rPAZhJ3L3wihXnamvEB1PydmnU0zI.jpg?auto=webp&s=0739e5fa9744a17d9951edfe3f79459704bc1a61)

Run `quint run --invariant GameNotWonYet dogbunnypuzzle.qnt --max-samples 50000 --max-steps 220` to make Quint search for a winning run.
Or, do 
```
quint -r dogbunnypuzzle.qnt::dogbunnypuzzle
winningRun
GameNotWonYet
```

which should output false to signify the current state is a goal state:

```
>>> curState
Map(1 -> "carrot", 2 -> "carrot", 3 -> "bone")
>>> EntityTypes
Map(1 -> "bunny", 2 -> "bunny", 3 -> "dog")
```