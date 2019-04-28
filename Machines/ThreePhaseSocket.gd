extends "res://Machines/Machine.gd"


func _init():
    var p = Globals.Port.new(self, 0, 0, 1000000, 0, 0, 0)
    ports[Vector3(0, 0, Globals.Direction.NORTH)] = p.duplicate()
    ports[Vector3(0, 0, Globals.Direction.SOUTH)] = p.duplicate()
    ports[Vector3(0, 0, Globals.Direction.EAST)] = p.duplicate()
    ports[Vector3(0, 0, Globals.Direction.WEST)] = p.duplicate()


func size():
    return Vector2(1, 1)


func cost():
    return -1


func tile(pos, n, s, e, w):
    return 1
