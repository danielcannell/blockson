extends "res://Machines/Machine.gd"


func size():
    return [3, 3]


func cost():
    return 5


func tile(pos):
    return pos.x + pos.y
