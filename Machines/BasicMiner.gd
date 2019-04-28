extends "res://Machines/Machine.gd"


func size():
    return Vector2(2, 5)


func cost():
    return 5


func tile(pos, n, s, e, w):
    return pos.x + pos.y


func ports(x, y, dir):
    var p = Globals.Port.new(self)

    if x == 0 and y == 0 and dir == Globals.Direction.NORTH:
        p.electric = -10

    if x == 1 and y == 2 and dir == Globals.Direction.EAST:
        p.network = -1

    return p
