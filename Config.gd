extends Node

const MAX_ZOOM = 8.0
const MIN_ZOOM = 0.1
const ZOOM_SPEED = 0.1
const DRAG_DEADZONE = 10


const LEVEL_SIZES = {
    0: Vector2(8, 8),
    1: Vector2(12, 12),
    2: Vector2(16, 6),
    3: Vector2(20, 30),
    4: Vector2(32, 32)
}


const LEVEL_THRESHOLDS = {
    0: 1e3,
    1: 1e6,
    2: 20e6,
    3: 100e6,
    4: 1e7
}


# If active is false, then the tutorial will not run.
# If active is true, then the tutorial will run. Simples!
var tutorial_active = false

var MAP_WIDTH = 8
var MAP_HEIGHT = 8

var level = 0


# name -> TechState
var tech_states = {}

var tutorial_occurred = []


func load_with_map(width: int, height: int):
    MAP_WIDTH = width
    MAP_HEIGHT = height
    get_tree().change_scene("res://Main.tscn")
    get_tree().paused = false
    

func next_level():
    level = level + 1
    var dim = LEVEL_SIZES[level]
    load_with_map(dim[0], dim[1])
