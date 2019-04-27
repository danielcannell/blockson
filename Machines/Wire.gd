extends Node


var kind


func _init(kind):
    self.kind = kind


func is_wire():
    return true


func size():
    return Vector2(1, 1)


func tile(coord):
    return 0
