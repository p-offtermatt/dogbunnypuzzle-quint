module dogbunnypuzzle {
    
    type Place = str

    type NobodyAtPlaces = Set[Place]
    type SomebodyAtPlaces = Set[Place]

    type Edge = (Place, Place)
    type EdgeCondition = (NobodyAtPlaces, SomebodyAtPlaces)

    type Entity = int

    type State = Entity -> Place


    pure val Places = Set("bone", "tree", "house", "flower", "well", "carrot", "boat")

    pure val Entities = Set(1,2,3)

    pure val EntityTypes = Map(
        1 -> "bunny",
        2 -> "bunny",
        3 -> "dog"
    )

    pure val NoCondition = (Set(), Set())

    pure val UniEdges = Map(
        ("bone", "boat") -> NoCondition,
        ("flower", "boat") -> NoCondition,
        ("carrot", "tree") -> NoCondition
    )

    pure val BiEdges = Map(
        ("house", "bone") -> (Set(), Set("carrot")),
        ("house", "boat") -> (Set(), Set("tree")),
        ("tree", "house") -> (Set(), Set("flower", "bone")),
        ("carrot", "well") -> (Set("bone"), Set()),
        ("well", "tree") -> NoCondition,
        ("well", "flower") -> NoCondition
    )

    pure def StateSatisfiesCondition(state: State, condition: EdgeCondition): bool = {
        // "somebody at" conditions
        condition._1.forall(place => not(Entities.exists(entity => state.get(entity) == place))) and
        // "nobody at" conditions
        condition._2.forall(place => Entities.exists(entity => state.get(entity) == place))
    }

    pure def FlipEdge(edge: Edge): Edge = ((edge._2, edge._1))
    
    pure def CanDoUniEdgeMove(entity: Entity, edge: Edge, state: State): bool = 
            (UniEdges.keys().contains(edge) and
            (state.get(entity) == edge._1) and
            StateSatisfiesCondition(state, UniEdges.get(edge)))

    pure def CanDoBiEdgeMove(entity: Entity, edge: Edge, state: State): bool = (
        ((BiEdges.keys().contains(edge) and StateSatisfiesCondition(state, BiEdges.get(edge))) 
                or (BiEdges.keys().contains(edge.FlipEdge()) and StateSatisfiesCondition(state, BiEdges.get(edge.FlipEdge()))))
            and (state.get(entity) == edge._1 or state.get(entity) == edge._2)
    )

    pure def CanDoMove(entity: Entity, edge: Edge, state: State): bool =
        (CanDoUniEdgeMove(entity, edge, state) or CanDoBiEdgeMove(entity, edge, state))


    pure def DoMove(entity: Entity, edge: Edge, state: State): State = (
        state.setBy(entity, oldPlace => if (oldPlace == edge._1) edge._2 else edge._1)
    )

    var curState: State

    action init: bool = {
        curState' = Map(
            1 -> "house",
            2 -> "boat",
            3 -> "tree"
        )
    }


    action TakeEdge(entity: Entity, edge: Edge): bool = all {
        CanDoMove(entity, edge, curState),
        curState' = DoMove(entity, edge, curState)
    }
    
    action step: bool = {
        nondet entity = oneOf(Entities)
        nondet edge = oneOf(UniEdges.keys().union(BiEdges.keys()))
        TakeEdge(entity, edge)
    }

    val entitiesAreAlwaysInPlaces: bool = {
        Entities.forall(entity => curState.keys().contains(entity) and curState.get(entity).in(Places))
    }

    val GameNotWonYet: bool = {
        Entities.forall(entity => 
            (EntityTypes.get(entity) == "bunny" implies curState.get(entity) == "carrot") and
            (EntityTypes.get(entity) == "dog" implies curState.get(entity) == "bone")
        )
    }

    run workingMove = {
        init
            .then(TakeEdge(1, ("house", "boat")))
            .then(TakeEdge(2, ("house", "boat")))
    }
}