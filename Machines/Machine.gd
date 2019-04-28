extends Node


# Set based on whether all supplies are satisfied
var working = {
    Globals.Wire.ELECTRIC: false,
    Globals.Wire.NETWORK: false,
    Globals.Wire.THREE_PHASE: false,
}


var connected = {
    Globals.Wire.ELECTRIC: 0,
    Globals.Wire.NETWORK: 0,
    Globals.Wire.THREE_PHASE: 0,
}


# Position of the top-left tile in this machine
var pos = Vector2()


# Map from Vector3(x, y, dir) -> Port
var ports = {}


# Earning rates
var bitcoint_per_sec = 0
var thoughts_per_sec = 0


func is_wire():
    return false


# The size of the machine in tiles.
func size():
    Globals.throw("ERROR: size() not implemented")


func cost():
    Globals.throw("ERROR: cost() not implemented")


func tile(pos, n, s, e, w):
    Globals.throw("ERROR: tile() not implemented")


func all_working():
    for w in working.values():
        if not w:
            return false
    return true


func get_ports_to_tile(x, y):
    var s = size()
    var leftedge = pos.x - 1
    var topedge = pos.y - 1
    var bottomedge = pos.y + s.y
    var rightedge = pos.x + s.x
    var xdiff = x - pos.x
    var ydiff = y - pos.y

    var key = null

    if x == leftedge:
        key = Vector3(0, ydiff, Globals.Direction.WEST)
    elif x == rightedge:
        key = Vector3(s.x-1, ydiff, Globals.Direction.EAST)
    elif y == topedge:
        key = Vector3(xdiff, 0, Globals.Direction.NORTH)
    elif y == bottomedge:
        key = Vector3(xdiff, s.y-1, Globals.Direction.SOUTH)

    if key == null or not key in ports:
        return Globals.Port.new(self, 0, 0, 0)
    else:
        return ports[key]


# Whether a wire of a certain kind should connect from a given tile
func accepts_wire_from_tile(x, y, kind):
    var p = get_ports_to_tile(x, y)
    return p.supplies[kind] != 0


func num_downstream_ports(kind):
    var n = 0
    for p in ports.values():
        if p.supplies[kind] < 0:
            n += 1
    return n


func _ready():
    pass # Replace with function body.


func _process(delta):
    pass
