extends "res://Machines/Machine.gd"


var tilemap = {
    Vector2(0, 0): 32,
    Vector2(1, 0): 33,
    Vector2(2, 0): 34,
    Vector2(0, 1): 43,
    Vector2(1, 1): 44,
    Vector2(2, 1): 45,
    Vector2(0, 2): 51,
    Vector2(1, 2): 52,
    Vector2(2, 2): 53,
    Vector2(0, 3): 35,
    Vector2(1, 3): 36,
    Vector2(2, 3): 37,
}

func _init():
    ports[Vector3(0, 0, Globals.Direction.NORTH)] = Globals.Port.new(self, -10, 0, 0, 0, 0, 0)
    ports[Vector3(2, 3, Globals.Direction.EAST)] = Globals.Port.new(self, 0, -1, 0, 0, 0, 0)


func size():
    return Vector2(3, 4)


func tile(pos, n, s, e, w):
    return tilemap[Vector2(pos.x, pos.y)]


func get_name():
    return "Ethereum Miner 3"
