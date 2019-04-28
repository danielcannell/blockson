extends "res://Machines/Machine.gd"


func size():
    return Vector2(1, 1)


func cost():
    return -1


func tile(pos, n, s, e, w):
    return 0


func ports(x, y, dir):
    var p = Globals.Port.new(self)
    p.heat = -100
    return p
