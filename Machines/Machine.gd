extends Node


# Position of the top-left tile in this machine
var pos = Vector2()


func is_wire():
    return false


# The size of the machine in tiles.
func size():
    print("ERROR: size() not implemented")
    return Vector2(0, 0)


func cost():
    print("ERROR: cost() not implemented")
    return 0.0


func tile(pos):
    print("ERROR: tile() not implemented")
    return 0


# Which ports are exposed by the machine on this edge
func ports(x, y, direction):
    print("ERROR: ports() not implmented")
    return Globals.Ports.new()


func _ready():
    pass # Replace with function body.


func _process(delta):
    pass
