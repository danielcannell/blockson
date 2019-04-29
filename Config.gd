extends Node

const MAX_ZOOM = 8.0
const MIN_ZOOM = 0.1
const ZOOM_SPEED = 0.1
const DRAG_DEADZONE = 10

# If active is false, then the tutorial will not run.
# If active is true, then the tutorial will run. Simples!
var tutorial_active = false

var MAP_WIDTH = 8
var MAP_HEIGHT = 8


# name -> TechState
var tech_states = {}


func load_with_map(width, height):
    MAP_WIDTH = width
    MAP_HEIGHT = height
    get_tree().change_scene("res://Main.tscn")
    get_tree().paused = false
