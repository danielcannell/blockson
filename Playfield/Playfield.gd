extends Node2D

signal end_placing
signal balance_changed

onready var tilemap = find_node("TileMap")
onready var background = find_node("Background")

var balance = 0

var machines = []
var tiles = {}


func _ready():
    var tx = tilemap.get_cell_size().x
    var ty = tilemap.get_cell_size().y
    var mapsize = Vector2(Config.MAP_WIDTH * tx, Config.MAP_HEIGHT * ty)
    background.set_size(mapsize)
    background.set_position(-mapsize / 2)
    tilemap.set_position(-mapsize / 2)


func get_tile_coord(viewport_pos):
    var trans = tilemap.get_global_transform_with_canvas()
    var local_pos = (viewport_pos - trans.get_origin()) / trans.get_scale()
    return tilemap.world_to_map(local_pos)


func _unhandled_input(event):
    var tilepos = get_tile_coord(event.position)

    if event is InputEventMouseButton:
        if not event.is_pressed():
            if tilepos.x >= 0 and tilepos.y >= 0 and tilepos.x < Config.MAP_WIDTH and tilepos.y < Config.MAP_HEIGHT:
                # Place or select building
                tilemap.set_cell(tilepos.x, tilepos.y, 2)
    elif event is InputEventMouseMotion:
        # Render rect on screen?
        #print("mouse motion at: ", tilepos)
        pass


func begin_placing(name):
    pass
