extends "res://Machines/Machine.gd"


var tilemap = {
    Vector2(0, 0): 38,
    Vector2(1, 0): 39,
    Vector2(0, 1): 46,
    Vector2(1, 1): 47,
}

func _init():
    ports[Vector3(0, 0, Globals.Direction.WEST)] = Globals.Port.new(self, 0, 0, -1000, 0, 0, 0)
    ports[Vector3(0, 1, Globals.Direction.WEST)] = Globals.Port.new(self, 0, 0, -1000, 0, 0, 0)
    ports[Vector3(1, 0, Globals.Direction.EAST)] = Globals.Port.new(self, 1000, 0, 0, 0, 0, 0)
    ports[Vector3(1, 1, Globals.Direction.EAST)] = Globals.Port.new(self, 1000, 0, 0, 0, 0, 0)


func size():
    return Vector2(2, 2)


func tile(pos, n, s, e, w):
    return tilemap[Vector2(pos.x, pos.y)]


func get_name():
    return "Transformer 3"
