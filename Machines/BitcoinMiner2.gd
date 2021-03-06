extends "res://Machines/Machine.gd"


var tilemap = {
    Vector2(0, 0): 8,
    Vector2(1, 0): 9,
    Vector2(0, 1): 12,
    Vector2(1, 1): 13,
    Vector2(0, 2): 10,
    Vector2(1, 2): 11,
}

func _init():
    ports[Vector3(0, 0, Globals.Direction.NORTH)] = Globals.Port.new(self, -50, 0, 0, 0, 0, 0)
    ports[Vector3(1, 2, Globals.Direction.EAST)] = Globals.Port.new(self, 0, -1, 0, 0, 0, 0)


func size():
    return Vector2(2, 3)


func tile(pos, n, s, e, w):
    return tilemap[Vector2(pos.x, pos.y)]


func get_name():
    return "Bitcoin Miner 2"
