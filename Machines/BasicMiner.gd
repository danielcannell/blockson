extends "res://Machines/Machine.gd"


func size():
    return Vector2(2, 5)


func cost():
    return 5


func tile(pos):
    return pos.x + pos.y
