extends "res://Machines/Machine.gd"


func size():
    return Vector2(1, 1)


func cost():
    return -1


func tile(pos, n, s, e, w):
    return 1


func ports(x, y, dir):
    var p = Globals.Port.new(self)
    p.supplies[Globals.Wire.NETWORK] = 100
    p.network_fanout = 2
    return p
