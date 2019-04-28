extends "res://Machines/Machine.gd"


var tilemap = {
    Vector2(0, 0): 4,
    Vector2(0, 1): 5,
}

func _init():
    ports[Vector3(0, 0, Globals.Direction.NORTH)] = Globals.Port.new(self, -10, -1, 0, 0, 0, 0)

    thoughts_per_sec = 0
    bitcoin_per_sec = 100


func size():
    return Vector2(1, 2)


func cost():
    return 5


func tile(pos, n, s, e, w):
    return tilemap[Vector2(pos.x, pos.y)]
