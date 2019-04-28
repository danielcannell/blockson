extends Node2D


var pos = null
var size = null

var wire_origin = null   # this is in TILEMAP units!
var wire_end = null
var tilemap = null


var color = Color(0, 1, 0, 1)


func _draw():
    if pos != null and size != null:
        draw_rect(Rect2(pos, size), color, false)


func set_pos(pos):
    self.pos = pos
    update()


func set_size(size):
    self.size = size
    update()


func set_ok(ok):
    if ok:
        color = Color(0, 1, 0, 1)
    else:
        color = Color(1, 0, 0, 1)

    update()


func open_wire(origin, tilemap):
    wire_origin = origin
    self.tilemap = tilemap
    grow_wire(origin)


func grow_wire(wire_end):
    # Ensure that wire placement is only vertical | or horizontal --
    if abs(wire_end.y - wire_origin.y) > abs(wire_end.x - wire_origin.x):
        wire_end.x = wire_origin.x
    else:
        wire_end.y = wire_origin.y

    self.wire_end = wire_end

    var x = order_vecs(wire_origin, wire_end)
    var a = x[0]
    var b = x[1]

    set_pos(tilemap.get_position() + a * tilemap.get_cell_size())
    set_size((b - a + Vector2(1, 1)) * tilemap.get_cell_size())


func order_vecs(a, b):
    if b < a:
        return [b, a]
    return [a, b]


func wire_open():
    return wire_origin != null


func wire_coords():
    return order_vecs(wire_origin, wire_end)


func close():
    wire_origin = null
    wire_end = null
    tilemap = null
    set_pos(null)
    set_size(null)
