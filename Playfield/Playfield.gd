extends Node2D

const Wire = preload("res://Machines/Wire.gd")

signal end_placing
signal balance_changed
signal tutorial_event

onready var tilemap = find_node("TileMap")
onready var cabletray_tilemap = find_node("CableTrayTileMap")
onready var wiredata_tilemap = find_node("WireDataTileMap")
onready var wirepower_tilemap = find_node("WirePowerTileMap")
onready var wire3phase_tilemap = find_node("Wire3PhaseTileMap")
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
    var cpos = -mapsize / 2
    background.set_position(cpos)
    tilemap.set_position(cpos)
    cabletray_tilemap.set_position(cpos)
    wiredata_tilemap.set_position(cpos)
    wirepower_tilemap.set_position(cpos)
    wire3phase_tilemap.set_position(cpos)
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
            placement.set_ok(check_wire_placement(a, b))
    else:
        placement.set_pos(tilemap.get_position() + coord * tilemap.get_cell_size())
        placement.set_ok(check_placement(coord))


func check_wire_placement(start, end):
    for i in range(start.x, end.x + 1):
        for j in range(start.y, end.y + 1):
            var p = Vector2(i, j)
            if p in tiles and not tiles[p].is_wire():
                return false
            if p.x < 0 or p.x >= Config.MAP_WIDTH or p.y < 0 or p.y >= Config.MAP_HEIGHT:
                return false

    return true


func check_placement(coord):
    var size = placing.size()

    for i in range(size.x):
        for j in range(size.y):
            var p = coord + Vector2(i, j)
            if p in tiles:
                return false
            if p.x < 0 or p.x >= Config.MAP_WIDTH or p.y < 0 or p.y >= Config.MAP_HEIGHT:
                return false

    return true


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
            var a = placing_start
            var b = placing_end

            if b < a:
                var tmp = a
                a = b
                b = tmp

            if check_wire_placement(a, b):
                for i in range(a.x, b.x + 1):
                    for j in range(a.y, b.y + 1):
                        var p = Vector2(i, j)

                        if not (p in tiles):
                            var wire = Wire.new()
                            wire.pos = p
                            tiles[p] = wire
                            wires.append(wire)

                        tiles[p].add_kind(placing)

                success = true
    else:
        var size = placing.size()

        if check_placement(coord):
            print("Placing")
            placing.pos = coord
            for i in range(size[0]):
                for j in range(size[1]):
                    var offset = Vector2(i, j)
                    var p = coord + offset
                    tiles[p] = placing

            machines.append(placing)
            success = true


    placing = null
    placement.set_pos(null)
    placement.set_size(null)
    emit_signal("end_placing", success)
    emit_signal("balance_changed", 500)


func on_ui_request_placement(name):
    begin_placing(name)


func adjacent(p):
    return [
        p + Vector2(1, 0),
        p + Vector2(0, 1),
        p + Vector2(-1, 0),
        p + Vector2(0, -1),
    ]


func ports(kind):
    var ps = []
    for net in nets(kind):
        var ms = []

        for w in net:
            for pos in adjacent(w):
                if not pos in tiles or tiles[pos].is_wire():
                    continue

                var machine = tiles[pos]
                ms.push_back(machine)

        ps.push_back(ms)

    return ps


func nets(kind):
    var ns = []

    for w in wires:
        w.mark = false

    for w in wires:
        if not w.has_kind(kind) or w.mark:
            continue

        var net = []
        var todo = [w.pos]

        while todo:
            var current = todo.pop_back()
            net.push_back(current)

            for a in adjacent(current):
                if not a in tiles or not tiles[a].is_wire():
                    continue

                var adjacent = tiles[a]

                if adjacent.mark:
                    continue

                adjacent.mark = true

                if not adjacent.has_kind(kind):
                    continue

                todo.push_back(adjacent.pos)

        ns.push_back(net)

    return ns
