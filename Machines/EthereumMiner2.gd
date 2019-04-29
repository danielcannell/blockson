extends "res://Machines/Machine.gd"


var tilemap = {
    Vector2(0, 0): 16,
    Vector2(1, 0): 17,
    Vector2(0, 1): 20,
    Vector2(1, 1): 21,
    Vector2(0, 2): 18,
    Vector2(1, 2): 19,
}

func _init():
    ports[Vector3(0, 0, Globals.Direction.NORTH)] = Globals.Port.new(self, -10, 0, 0, 0, 0, 0)
    ports[Vector3(1, 2, Globals.Direction.EAST)] = Globals.Port.new(self, 0, -1, 0, 0, 0, 0)


func size():
    return Vector2(2, 3)


func tile(pos, n, s, e, w):
    return tilemap[Vector2(pos.x, pos.y)]


func get_name():
    return "Ethereum Miner 2"
