extends "res://Machines/Machine.gd"


func size():
    return Vector2(1, 1)


func cost():
    return 5


func tile(pos):
    return pos.x + pos.y