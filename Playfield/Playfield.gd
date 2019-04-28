extends Node2D

const Wire = preload("res://Machines/Wire.gd")

const AirVent = preload("res://Machines/AirVent.gd")
const ThreePhaseSocket = preload("res://Machines/ThreePhaseSocket.gd")
const NetworkSocket = preload("res://Machines/NetworkSocket.gd")
const Net = preload("res://Playfield/Net.gd")
const StatusEffect = preload("res://Machines/StatusEffect.tscn")

signal end_placing
signal mining_result
signal tutorial_event
signal delete_completed

onready var tilemap = find_node("TileMap")
onready var cabletray_tilemap = find_node("CableTrayTileMap")
onready var wiredata_tilemap = find_node("WireDataTileMap")
onready var wirepower_tilemap = find_node("WirePowerTileMap")
onready var wire3phase_tilemap = find_node("Wire3PhaseTileMap")
onready var background = find_node("Background")

var machines = []
var wires = []
var tiles = {}

var placing_wire = false
var placing = null
var deleting = false
var deleting_wire = false

var tick_timer = Timer.new()


func _ready():
    randomize()

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

    tick_timer.wait_time = 1.0
    tick_timer.connect("timeout", self, "tick")
    tick_timer.start()

    self.add_child(tick_timer)

    generate_map_edges()
    recompute_tilemaps()


func _get_random_edge_point():
    match randi() % 4:
        0:
            return Vector2(-1, randi() % Config.MAP_HEIGHT)
        1:
            return Vector2(Config.MAP_WIDTH, randi() % Config.MAP_HEIGHT)
        2:
            return Vector2(randi() % Config.MAP_WIDTH, -1)
        3:
            return Vector2(randi() % Config.MAP_WIDTH, Config.MAP_HEIGHT)


func _get_random_unused_edge_point():
    for i in range(100):
        var p = _get_random_edge_point()
        if not tiles.has(p):
            return p
    Globals.throw("Failed to generate an unused edge point after 100 attempts")


func _generate_external_port(type):
    var p = _get_random_unused_edge_point()
    var m = type.new()
    m.pos = p
    tiles[p] = m
    machines.push_back(m)


func generate_map_edges():
    for i in range(5):
        _generate_external_port(AirVent)
    for i in range(3):
        _generate_external_port(NetworkSocket)
    for i in range (2):
        _generate_external_port(ThreePhaseSocket)


func get_tile_coord(viewport_pos):
    var trans = tilemap.get_global_transform_with_canvas()
    var local_pos = (viewport_pos - trans.get_origin()) / trans.get_scale()
    return tilemap.world_to_map(local_pos)


func _unhandled_input(event):
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT:
            if not event.is_pressed():
                if deleting:
                    finish_deleting(get_tile_coord(event.position))
                else:
                    finish_placing(get_tile_coord(event.position))

    elif event is InputEventMouseMotion:
        if deleting_wire:
            update_delete_placement(get_tile_coord(event.position))
        else:
            update_placing(get_tile_coord(event.position))


func begin_placing(name):
    deleting = false
    var placement = get_node("Placement")

    placement.close()
    placement.set_pos(null)
    placement.set_size(null)

    if name in Globals.MACHINES:
        placing = Globals.MACHINES[name].new()
        placing_wire = false
        placement.set_size(placing.size() * tilemap.get_cell_size())
    elif name in Globals.WIRES:
        placing = Globals.WIRES[name]
        placing_wire = true
    else:
        print("ERROR: What is this?")
        return


func update_placing(coord):
    if placing == null:
        return

    var placement = get_node("Placement")

    if placing_wire:
        if placement.wire_open():
            placement.grow_wire(coord)
            var x = placement.wire_coords()
            placement.set_ok(check_wire_placement(x[0], x[1]))
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
        if !placement.wire_open():
            placement.open_wire(coord, tilemap)
            return

        var x = placement.wire_coords()
        var a = x[0]
        var b = x[1]

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
            placing.pos = coord
            for i in range(size[0]):
                for j in range(size[1]):
                    var offset = Vector2(i, j)
                    var p = coord + offset
                    tiles[p] = placing

            var se = StatusEffect.instance()
            se.machine = placing
            se.position = (placing.get_center_pos() * 32) + tilemap.position
            placing.status_effect = se
            add_child(se)
            machines.append(placing)
            success = true

    complete_placing(success)
    recompute_tilemaps()


func complete_placing(success):
    var placement = get_node("Placement")
    placing = null
    placement.close()
    emit_signal("end_placing", success)


func get_machine(x, y):
    var p = Vector2(x, y)
    return tiles.get(p)


func recompute_tilemaps():
    for x in range(-1, Config.MAP_WIDTH+1):
        for y in range(-1, Config.MAP_HEIGHT+1):
            var t = get_machine(x, y)
            var tids = [-1, -1, -1, -1, -1]
            if t != null:
                var n = get_machine(x, y-1)
                var s = get_machine(x, y+1)
                var e = get_machine(x+1, y)
                var w = get_machine(x-1, y)
                if t.is_wire():
                    var wire_ids = t.tile(n, s, e, w)
                    tids[1] = wire_ids[0]
                    tids[2] = wire_ids[1]
                    tids[3] = wire_ids[2]
                    tids[4] = wire_ids[3]
                else:
                    tids[0] = t.tile(Vector2(x, y) - t.pos, n, s, e, w)

            # Map edges should have blank walls
            if (x == -1 or y == -1 or x == Config.MAP_WIDTH or y == Config.MAP_HEIGHT) and tids[0] == -1:
                tids[0] = 3

            tilemap.set_cell(x, y, tids[0])
            cabletray_tilemap.set_cell(x, y, tids[1])
            wiredata_tilemap.set_cell(x, y, tids[2])
            wirepower_tilemap.set_cell(x, y, tids[3])
            wire3phase_tilemap.set_cell(x, y, tids[4])


func on_ui_request_placement(name):
    begin_placing(name)


func tick():
    update_machines_working()

    var thoughts_per_sec = 1
    var bitcoin_per_sec = 0

    print("**********")
    for machine in machines:
        machine.checked = true

        if machine.is_working():
            thoughts_per_sec += machine.thoughts_per_sec
            bitcoin_per_sec += machine.bitcoin_per_sec

    emit_signal("mining_result", thoughts_per_sec, bitcoin_per_sec)


func get_net_from_port(ns, p, kind):
    for n in ns:
        if n.kind != kind: continue
        if n.ports.has(p):
            return n


func update_machines_working():
    var ns = []
    for kind in Globals.WIRE_KINDS:
        ns += calculate_connected_ports(kind)
    var ms = machines.duplicate()

    print("NETS:")
    for n in ns:
        print(n.to_string())

    # Set all machines as not working
    for machine in ms:
        for kind in Globals.WIRE_KINDS:
            machine.connected[kind] = 0

    # Repeat until nothing changes
    var changes = true
    while changes:
        changes = false
        for machine in ms.duplicate():
            if machine.is_working():
                ms.erase(machine)
                for kind in Globals.WIRE_KINDS:
                    for p in machine.get_source_ports(kind):
                        var net = get_net_from_port(ns, p, kind)
                        if net != null:
                            net.supply += p.supplies[kind]
                changes = true
        for net in ns.duplicate():
            if net.is_working():
                ns.erase(net)
                for p in net.ports:
                    for kind in Globals.WIRE_KINDS:
                        if p.supplies[kind] < 0:
                            p.machine.connected[kind] += 1
                changes = true


func adjacent(p):
    return [
        p + Vector2(1, 0),
        p + Vector2(0, 1),
        p + Vector2(-1, 0),
        p + Vector2(0, -1),
    ]


func calculate_connected_ports(kind):
    var ps = []
    for net in calculate_nets(kind):
        var ms = Net.new(kind)

        for w in net:
            for pos in adjacent(w):
                if not pos in tiles or tiles[pos].is_wire():
                    continue

                var machine = tiles[pos]
                if machine.accepts_wire_from_tile(w.x, w.y, kind):
                    ms.ports.push_back(machine.get_ports_to_tile(w.x, w.y))

        ps.push_back(ms)

    return ps


func calculate_nets(kind):
    var ns = []

    for w in wires:
        w.mark = false

    for w in wires:
        if not w.has_kind(kind) or w.mark:
            continue

        w.mark = true

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


func on_ui_enter_delete_mode():
    complete_placing(false)
    begin_deleting()


func begin_deleting():
    deleting = true


func finish_deleting(clicked_pos):
    # If we are already deleting a wire, then that's all we should continue with
    if deleting_wire:
        wire_delete(clicked_pos)
        return

    # If we clicked an empty space, just stop!
    if not clicked_pos in tiles:
        complete_deleting()
        return

    # We're about to start deleting a wire
    var machine = tiles[clicked_pos]
    if machine.is_wire():
        wire_delete(clicked_pos)
    else:
        remove_child(machine.status_effect)
        machines.erase(machine)
        call_deferred("free", machine.status_effect)
        call_deferred("free", machine)
        var pos = machine.pos
        var sz = machine.size()
        for x in range(sz[0]):
            for y in range(sz[1]):
                tiles.erase(Vector2(pos[0] + x, pos[1] + y))

        complete_deleting()
        recompute_tilemaps()


func complete_deleting():
    emit_signal("delete_completed")
    deleting = false
    deleting_wire = false
    get_node("Placement").close()


func wire_delete(coord):
    var placement = get_node('Placement')
    if !placement.wire_open():
        # Start new wire delete
        deleting_wire = true
        placement.open_wire(coord, tilemap)
    else:
        # Finish a wire delete
        placement.grow_wire(coord)
        var x = placement.wire_coords()

        # If there is an obstacle, don't do anything
        if !check_wire_placement(x[0], x[1]):
            complete_deleting()
            return

        # Delete all wires on route
        for i in range(x[0].x, x[1].x + 1):
            for j in range(x[0].y, x[1].y + 1):
                var p = Vector2(i, j)
                if p in tiles and tiles[p].is_wire():
                    wires.erase(tiles[p])
                    tiles.erase(p)

        placement.close()
        complete_deleting()
        recompute_tilemaps()

func update_delete_placement(coord):
    var placement = get_node("Placement")
    if placement.wire_open():
        placement.grow_wire(coord)
        var x = placement.wire_coords()
        placement.set_ok(check_wire_placement(x[0], x[1]))


func _process(delta):
    Globals.time += delta
    

func cancel_all_placements():
    complete_placing(false)
