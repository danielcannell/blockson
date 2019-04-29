extends Node


# Node which controls rendering of status effects
var status_effect = null
var checked = false


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
var bitcoin_per_sec = 0
var thoughts_per_sec = 0

var temperature = 10;
# termal energy output in J per second
var thermal_output = 100;
# j per degree
var thermal_capacity = 100


func is_wire():
    return false


# The size of the machine in tiles.
func size():
    Globals.throw("ERROR: size() not implemented")


func cost():
    Globals.throw("ERROR: cost() not implemented")


func tile(pos, n, s, e, w):
    Globals.throw("ERROR: tile() not implemented")


func get_center_pos():
    return pos + size() / 2


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
        return Globals.Port.new(self, 0, 0, 0, 0, 0, 0)
    else:
        return ports[key]


# Whether a wire of a certain kind should connect from a given tile
func accepts_wire_from_tile(x, y, kind):
    var p = get_ports_to_tile(x, y)
    return p.supplies[kind] != 0


func get_source_ports(kind):
    var ps = []
    for p in ports.values():
        if p.supplies[kind] > 0:
            ps.push_back(p)
    return ps


func get_sink_ports(kind):
    var ps = []
    for p in ports.values():
        if p.supplies[kind] < 0:
            ps.push_back(p)
    return ps


func num_sink_ports(kind):
    return get_sink_ports(kind).size()


func working(kind):
    return connected[kind] >= num_sink_ports(kind)


func is_working():
    for kind in Globals.WIRE_KINDS:
        if not working(kind):
            return false
    return true


func get_status_string():
    var s = ""
    var ok = true
    for kind in Globals.WIRE_KINDS:
        var need = num_sink_ports(kind)
        if need == 0: continue
        var has = connected[kind]
        s += "%s: %d/%d, " % [Globals.get_kind_name(kind), has, need]
    s = s.substr(0, s.length() - 2)

    if not is_working():
        s = "NOT WORKING: " + s

    return s


func to_string():
    return "Machine{ce=%d/%d, cn=%d/%d, ct=%d/%d, w=%s}" % [
        connected[Globals.Wire.ELECTRIC],
        num_sink_ports(Globals.Wire.ELECTRIC),
        connected[Globals.Wire.NETWORK],
        num_sink_ports(Globals.Wire.NETWORK),
        connected[Globals.Wire.THREE_PHASE],
        num_sink_ports(Globals.Wire.THREE_PHASE),
        is_working()
    ]
