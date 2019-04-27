extends Node

enum Direction {
    NORTH,
    SOUTH,
    EAST,
    WEST
}

enum Wire {
    ELECTRIC,
    THREE_PHASE,
    NETWORK,
}

const MACHINES = {
    "Basic Miner": preload("res://Machines/BasicMiner.gd"),
    "Basic Router": preload("res://Machines/BasicRouter.gd"),
}

const WIRES = {
    "Electric Cable": Wire.ELECTRIC,
    "Network Cable": Wire.NETWORK,
}

enum TutorialEvents {
    PLAYFIELD_READY,
    UI_READY,
}

class Port:
    var heat = 0.0
    var power = 0.0
    var data = 0.0
