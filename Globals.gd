extends Node

enum Direction {
    NORTH,
    SOUTH,
    EAST,
    WEST
}

enum TutorialEvents {
    PLAYFIELD_READY,
    UI_READY,
}

class Port:
    var heat = 0.0
    var power = 0.0
    var data = 0.0
