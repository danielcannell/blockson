extends "res://Machines/Machine.gd"


func size():
    return Vector2(2, 5)


func cost():
    return 5


func tile(pos):
    return pos.x + pos.y


func ports(x, y, dir):
    var p = Globals.Port.new()

    match [x, y, dir]:
        [0, 0, Globals.Direction.NORTH]:
            p.power = -10

    return p
