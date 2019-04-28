extends "res://Machines/Machine.gd"


func _init():
    ports[Vector3(0, 0, Globals.Direction.NORTH)] = Globals.Port.new(self, -10, 0, 0)
    ports[Vector3(1, 2, Globals.Direction.EAST)] = Globals.Port.new(self, 0, -1, 0)


func size():
    return Vector2(2, 5)


func cost():
    return 5


func tile(pos, n, s, e, w):
    return pos.x + pos.y
