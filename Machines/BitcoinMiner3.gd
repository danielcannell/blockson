extends "res://Machines/Machine.gd"


var tilemap = {
    Vector2(0, 0): 24,
    Vector2(1, 0): 25,
    Vector2(2, 0): 26,
    Vector2(0, 1): 40,
    Vector2(1, 1): 41,
    Vector2(2, 1): 42,
    Vector2(0, 2): 48,
    Vector2(1, 2): 49,
    Vector2(2, 2): 50,
    Vector2(0, 3): 27,
    Vector2(1, 3): 28,
    Vector2(2, 3): 29,
}

func _init():
    ports[Vector3(0, 0, Globals.Direction.NORTH)] = Globals.Port.new(self, -10, 0, 0, 0, 0, 0)
    ports[Vector3(2, 3, Globals.Direction.EAST)] = Globals.Port.new(self, 0, -1, 0, 0, 0, 0)

    thoughts_per_sec = 0
    bitcoin_per_sec = 100


func size():
    return Vector2(3, 4)


func cost():
    return 5


func tile(pos, n, s, e, w):
    return tilemap[Vector2(pos.x, pos.y)]


func get_name():
    return "Bitcoin Miner 3"
