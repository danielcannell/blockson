extends Node

var pos = Vector2()

# Used for net detection
var mark = false

var kinds = {
    Globals.Wire.ELECTRIC: false,
    Globals.Wire.THREE_PHASE: false,
    Globals.Wire.NETWORK: false,
}


func add_kind(kind):
    kinds[kind] = true


func has_kind(kind):
    return kinds[kind]


func is_wire():
    return true


func size():
    return Vector2(1, 1)


func tile():
    var a = 1 if kinds[Globals.Wire.ELECTRIC] else 0
    var b = 1 if kinds[Globals.Wire.THREE_PHASE] else 0
    var c = 1 if kinds[Globals.Wire.NETWORK] else 0
    return a | (b << 1) | (c << 2)