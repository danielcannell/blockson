extends Node2D

const Wire = preload("res://Machines/Wire.gd")

signal end_placing
signal balance_changed
signal tutorial_event

onready var tilemap = find_node("TileMap")
onready var wiretilemap = find_node("WireTileMap")
onready var background = find_node("Background")

var balance = 0

var machines = []
var wires = []
var tiles = {}

var placing_wire = false
var placing = null
var placing_start = null
var placing_end = null


func _ready():
    var tx = tilemap.get_cell_size().x
    var ty = tilemap.get_cell_size().y
    var mapsize = Vector2(Config.MAP_WIDTH * tx, Config.MAP_HEIGHT * ty)
    background.set_size(mapsize)
    background.set_position(-mapsize / 2)
    tilemap.set_position(-mapsize / 2)
    wiretilemap.set_position(-mapsize / 2)
    emit_signal("tutorial_event", Globals.TutorialEvents.PLAYFIELD_READY)


func get_tile_coord(viewport_pos):
    var trans = tilemap.get_global_transform_with_canvas()
    var local_pos = (viewport_pos - trans.get_origin()) / trans.get_scale()
    return tilemap.world_to_map(local_pos)


func _unhandled_input(event):
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT:
            if not event.is_pressed():
                finish_placing(get_tile_coord(event.position))

    elif event is InputEventMouseMotion:
        update_placing(get_tile_coord(event.position))


func begin_placing(name):
    var placement = get_node("Placement")

    placement.set_pos(null)
    placement.set_size(null)

    if name in Globals.MACHINES:
        placing = Globals.MACHINES[name].new()
        placing_wire = false
        placement.set_size(placing.size() * tilemap.get_cell_size())
    elif name in Globals.WIRES:
        placing = Globals.WIRES[name]
        placing_wire = true
        placing_start = null
    else:
        print("ERROR: What is this?")
        return


func update_placing(coord):
    if placing == null:
        return

    var placement = get_node("Placement")

    if placing_wire:
        if placing_start != null:
            placing_end = coord

            if abs(placing_end.y - placing_start.y) > abs(placing_end.x - placing_start.x):
                placing_end.x = placing_start.x
            else:
                placing_end.y = placing_start.y

            var a = placing_start
            var b = placing_end

            if b < a:
                var tmp = a
                a = b
                b = tmp

            placement.set_pos(tilemap.get_position() + a * tilemap.get_cell_size())
            placement.set_size((b - a + Vector2(1, 1)) * tilemap.get_cell_size())
    else:
        placement.set_pos(tilemap.get_position() + coord * tilemap.get_cell_size())
        placement.set_ok(check_placement(coord))


func check_placement(coord):
    var size = placing.size()
    var ok = true

    for i in range(size.x):
        for j in range(size.y):
            var p = coord + Vector2(i, j)
            var occupied = p in tiles and not tiles[p].is_wire()
            if occupied or p.x < 0 or p.x >= Config.MAP_WIDTH or p.y < 0 or p.y >= Config.MAP_HEIGHT:
                ok = false

    return ok


func finish_placing(coord):
    var success = false
    if placing == null:
        return

    var placement = get_node("Placement")

    if placing_wire:
        if placing_start == null:
            placing_start = coord
            placement.set_pos(coord)
            placement.set_size(tilemap.get_cell_size())
            return
        else:
            for i in range(placing_start.x, placing_end.x + 1):
                for j in range(placing_start.y, placing_end.y + 1):
                    var offset = Vector2(i, j)
                    var p = coord + offset

                    var wire = Wire.new(placing)
                    tiles[p] = wire
                    wires.append(wire)
            success = true
    else:
        var size = placing.size()

        if check_placement(coord):
            print("Placing")
            for i in range(size[0]):
                for j in range(size[1]):
                    var offset = Vector2(i, j)
                    var p = coord + offset
                    tiles[p] = placing
                    tilemap.set_cell(p.x, p.y, placing.tile(offset))

            machines.append(placing)
            success = true
        else:
            print("Bad")


    placing = null
    placement.set_pos(null)
    placement.set_size(null)
    emit_signal("end_placing", success)
    emit_signal("balance_changed", 500)


func on_ui_request_placement(name):
    begin_placing(name)
