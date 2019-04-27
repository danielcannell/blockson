extends Node

const MAX_ZOOM = 8.0
const MIN_ZOOM = 0.1
const ZOOM_SPEED = 0.1
const DRAG_DEADZONE = 10
const MAP_WIDTH = 32
const MAP_HEIGHT = 32

const MACHINES = {
    "BasicMiner": preload("res://Machines/BasicMiner.gd"),
    "BasicRouter": preload("res://Machines/BasicRouter.gd"),
}
