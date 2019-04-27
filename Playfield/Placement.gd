extends Node2D


var pos = null
var size = null


var color = Color(0, 1, 0, 1)


func _draw():
    if pos and size:
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
