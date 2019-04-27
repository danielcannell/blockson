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
    "Three phase": Wire.THREE_PHASE,
}

enum TutorialEvents {
    PLAYFIELD_READY,
    UI_READY,
}

class Port:
    var machine = null
    var heat = 0.0
    var electric = 0.0
    var network = 0.0
    var three_phase = 0.0

    func _init(m):
        machine = m
