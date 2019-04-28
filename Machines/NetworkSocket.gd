extends "res://Machines/Machine.gd"


func _init():
    var p = Globals.Port.new(self, 0, 100, 0)
    p.network_fanout = 2
    ports[Vector3(0, 0, Globals.Direction.NORTH)] = p
    ports[Vector3(0, 0, Globals.Direction.SOUTH)] = p
    ports[Vector3(0, 0, Globals.Direction.EAST)] = p
    ports[Vector3(0, 0, Globals.Direction.WEST)] = p


func size():
    return Vector2(1, 1)


func cost():
    return -1


func tile(pos, n, s, e, w):
    return 2
