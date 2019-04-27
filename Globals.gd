extends Node

enum Direction {
    NORTH,
    SOUTH,
    EAST,
    WEST
}

enum Wire {
    ELECTRIC,
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
