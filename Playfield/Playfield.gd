extends Node2D

onready var tilemap = find_node("TileMap")

func _ready():
    print("HELLO WORLD")

func get_tile_coord(viewport_pos):
    var trans = tilemap.get_global_transform_with_canvas()
    var local_pos = (viewport_pos - trans.get_origin()) / trans.get_scale()
    return tilemap.world_to_map(local_pos)

func _unhandled_input(event):
    var tilepos = get_tile_coord(event.position)

    if event is InputEventMouseButton:
        if not event.is_pressed():
            print("release")
            # Place or select building
    elif event is InputEventMouseMotion:
        #print("mouse motion at: ", event.position)
        pass
