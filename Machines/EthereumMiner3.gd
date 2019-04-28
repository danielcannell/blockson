extends "res://Machines/Machine.gd"


var tilemap = {
    Vector2(0, 0): 16,
    Vector2(1, 0): 17,
    Vector2(2, 0): 17,
    Vector2(0, 1): 20,
    Vector2(1, 1): 21,
    Vector2(2, 1): 21,
    Vector2(0, 2): 18,
    Vector2(1, 2): 19,
    Vector2(2, 2): 19,
    Vector2(0, 3): 18,
    Vector2(1, 3): 19,
    Vector2(2, 3): 19,
}

func _init():
    ports[Vector3(0, 0, Globals.Direction.NORTH)] = Globals.Port.new(self, -10, 0, 0, 0, 0, 0)
    ports[Vector3(2, 3, Globals.Direction.EAST)] = Globals.Port.new(self, 0, -1, 0, 0, 0, 0)

    thoughts_per_sec = 100000
    bitcoin_per_sec = 0


func size():
    return Vector2(3, 4)


func cost():
    return 5


func tile(pos, n, s, e, w):
    return tilemap[Vector2(pos.x, pos.y)]