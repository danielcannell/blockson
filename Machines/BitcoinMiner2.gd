extends "res://Machines/Machine.gd"


var tilemap = {
    Vector2(0, 0): 8,
    Vector2(1, 0): 9,
    Vector2(2, 0): 9,
    Vector2(0, 1): 12,
    Vector2(1, 1): 13,
    Vector2(2, 1): 13,
    Vector2(0, 2): 10,
    Vector2(1, 2): 11,
    Vector2(2, 2): 11,
    Vector2(0, 3): 10,
    Vector2(1, 3): 11,
    Vector2(2, 3): 11,
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