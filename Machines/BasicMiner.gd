extends "res://Machines/Machine.gd"


func size():
    return Vector2(3, 3)


func tile(pos):
    return pos.x + pos.y
