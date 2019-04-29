extends "res://Machines/Machine.gd"


var tilemap = {
    Vector2(0, 0): 15,
}

func _init():
    ports[Vector3(0, 0, Globals.Direction.NORTH)] = Globals.Port.new(self, 0, 0, -50, 0, 0, 0)
    ports[Vector3(0, 0, Globals.Direction.SOUTH)] = Globals.Port.new(self, 50, 0, 0, 0, 0, 0)


func size():
    return Vector2(1, 1)


func tile(pos, n, s, e, w):
    return tilemap[Vector2(pos.x, pos.y)]


func get_name():
    return "Transformer"
