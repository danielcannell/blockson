extends Node

const MAX_ZOOM = 8.0
const MIN_ZOOM = 0.1
const ZOOM_SPEED = 0.1
const DRAG_DEADZONE = 10

const INITIAL_BITCOIN = 90


const LEVEL_SIZES = {
    0: Vector2(8, 8),
    1: Vector2(12, 12),
    2: Vector2(40, 6),
    3: Vector2(20, 30),
    4: Vector2(50, 50)
}


const LEVEL_THRESHOLDS = {
    0: 1e3,
    1: 1e6,
    2: 2e6,
    3: 100e6,
    4: 1e9,
}


const MACHINE_COST = {
    "Bitcoin Miner": 10,
    "Bitcoin Miner 2": 1000,
    "Bitcoin Miner 3": 1000000,

    "Ethereum Miner": 100,
    "Ethereum Miner 2": 10000,
    "Ethereum Miner 3": 10000000,

    "Router": 1,
    "Router 2": 100000000,
    "Router 3": 100000000,

    "Transformer": 1,
    "Transformer 2": 100000000,
    "Transformer 3": 100000000,
}


const MACHINE_BITCOIN_PER_SEC = {
    "Bitcoin Miner": 10,
    "Bitcoin Miner 2": 1000,
    "Bitcoin Miner 3": 100000,
}


const MACHINE_THOUGHTS_PER_SEC = {
    "Ethereum Miner": 1000,
    "Ethereum Miner 2": 400000,
    "Ethereum Miner 3": 50000000,
}


# If active is false, then the tutorial will not run.
# If active is true, then the tutorial will run. Simples!
var tutorial_active = true

var MAP_WIDTH = 8
var MAP_HEIGHT = 8

var level = 0

var base_thoughts_per_second = 1


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
