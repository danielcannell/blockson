extends Camera2D

var dragging = false
var drag_pos = Vector2()


func update_zoom(ratio, pos):
    var new_scale = clamp(self.zoom.x * ratio, Config.MIN_ZOOM, Config.MAX_ZOOM)

    var old_pos = get_global_mouse_position()
    self.zoom = Vector2(new_scale, new_scale)
    var new_pos = get_global_mouse_position()
    self.offset += old_pos - new_pos


func update_pan(pos):
    var delta = pos - drag_pos
    drag_pos = pos

    self.offset -= delta * self.zoom


func _unhandled_input(event):
    if event is InputEventMouseButton:
        if event.is_pressed():
            # zoom in
            if event.button_index == BUTTON_WHEEL_UP:
                update_zoom(1 - Config.ZOOM_SPEED, event.position)

            # zoom out
            if event.button_index == BUTTON_WHEEL_DOWN:
                update_zoom(1 + Config.ZOOM_SPEED, event.position)

            if event.button_index == BUTTON_LEFT:
                dragging = true
                drag_pos = event.global_position
        else:
            if event.button_index == BUTTON_LEFT:
                dragging = false


func _input(event):
    if event is InputEventMouseMotion:
        if dragging:
            update_pan(event.global_position)
            get_tree().set_input_as_handled()
