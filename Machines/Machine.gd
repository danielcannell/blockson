extends Node


# Position of the top-left tile in this machine
var pos = Vector2()


# The size of the machine in tiles.
func size():
    print("ERROR: size() not implemented")
    return [0, 0]


func cost():
    print("ERROR: cost() not implemented")
    return 0.0


# Which ports are exposed by the machine on this edge
func ports(x, y, direction):
    print("ERROR: ports() not implmented")
    return {}


func _ready():
    pass # Replace with function body.


func _process(delta):
    pass
