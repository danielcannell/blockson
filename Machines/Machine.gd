extends Node


# Position of the top-left tile in this machine
var pos = Vector2()


func is_wire():
    return false


# The size of the machine in tiles.
func size():
    print("ERROR: size() not implemented")
    return Vector2(0, 0)


func cost():
    print("ERROR: cost() not implemented")
    return 0.0


func tile(pos, n, s, e, w):
    print("ERROR: tile() not implemented")
    return 0


# Which ports are exposed by the machine on this edge
func ports(x, y, direction):
    print("ERROR: ports() not implmented")
    return Globals.Ports.new(self)


func get_ports_to_tile(x, y):
    var s = size()
    var leftedge = pos.x - 1
    var topedge = pos.y - 1
    var bottomedge = pos.y + s.y
    var rightedge = pos.x + s.x
    var xdiff = x - pos.x
    var ydiff = y - pos.y
    print(x, " ", leftedge, " ", rightedge)
    print(y, " ", topedge, " ", bottomedge)
    if x == leftedge:
        return ports(0, ydiff, Globals.Direction.WEST)
    elif x == rightedge:
        return ports(s.x-1, ydiff, Globals.Direction.EAST)
    elif y == topedge:
        return ports(xdiff, 0, Globals.Direction.NORTH)
    elif y == bottomedge:
        return ports(xdiff, s.y-1, Globals.Direction.SOUTH)
    return Globals.Port.new(self)


# Whether a wire of a certain kind should connect from a given tile
func accepts_wire_from_tile(x, y, kind):
    var p = get_ports_to_tile(x, y)
    match kind:
        Globals.Wire.ELECTRIC:
            return p.electric != 0
        Globals.Wire.NETWORK:
            return p.network != 0
        Globals.Wire.THREE_PHASE:
            return p.three_phase != 0
    return false


func _ready():
    pass # Replace with function body.


func _process(delta):
    pass
