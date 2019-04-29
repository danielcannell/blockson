extends "res://Machines/Machine.gd"


func _init():
    var p = Globals.Port.new(self, 0, 999999, 0, 0, 2, 0)
    ports[Vector3(0, 0, Globals.Direction.NORTH)] = p.duplicate()
    ports[Vector3(0, 0, Globals.Direction.SOUTH)] = p.duplicate()
    ports[Vector3(0, 0, Globals.Direction.EAST)] = p.duplicate()
    ports[Vector3(0, 0, Globals.Direction.WEST)] = p.duplicate()


func size():
    return Vector2(1, 1)


func tile(pos, n, s, e, w):
    return 2


func get_name():
    return "Network Socket"
