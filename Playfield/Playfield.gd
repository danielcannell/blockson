extends Node2D

signal end_placing
signal balance_changed

onready var tilemap = find_node("TileMap")
onready var background = find_node("Background")

var balance = 0

var machines = []
var tiles = {}

var placing = null


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
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT:
            if not event.is_pressed():
                finish_placing(get_tile_coord(event.position))
        elif event.button_index == BUTTON_RIGHT:
            begin_placing("BasicMiner")

    elif event is InputEventMouseMotion:
        #print("mouse motion at: ", event.position)
        update_placing(get_tile_coord(event.position))


func begin_placing(name):
    placing = Config.MACHINES[name].new()


func update_placing(coord):
    if placing:
        print(coord)


func finish_placing(coord):
    if not placing:
        return

    var size = placing.size()
    var ok = true

    for i in range(size[0]):
        for j in range(size[1]):
            var p = coord + Vector2(i, j)
            if p in tiles or p.x < 0 or p.x > Config.MAP_WIDTH or p.y < 0 or p.y > Config.MAP_HEIGHT:
                ok = false

    if ok:
        print("Placing")
        for i in range(size[0]):
            for j in range(size[1]):
                var offset = Vector2(i, j)
                var p = coord + offset
                tiles[p] = placing
                tilemap.set_cell(p.x, p.y, placing.tile(offset))
        machines.append(placing)
    else:
        print("Bad")


    placing = null
    emit_signal("end_placing")
