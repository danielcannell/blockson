extends Camera2D

var dragging = false
var drag_pos = Vector2()


func update_zoom(ratio):
    var new_scale = self.zoom.x * ratio
    new_scale = min(new_scale, Config.MAX_ZOOM)
    new_scale = max(new_scale, Config.MIN_ZOOM)
    self.zoom.x = new_scale
    self.zoom.y = new_scale


func update_pan(pos):
    var delta = pos - drag_pos
    drag_pos = pos

    self.offset -= delta * self.zoom


func _input(event):
    if event is InputEventMouseButton:
        if event.is_pressed():
            # zoom in
            if event.button_index == BUTTON_WHEEL_UP:
                update_zoom(1 - Config.ZOOM_SPEED)

            # zoom out
            if event.button_index == BUTTON_WHEEL_DOWN:
                update_zoom(1 + Config.ZOOM_SPEED)

            if event.button_index == BUTTON_LEFT:
                dragging = true
                drag_pos = event.global_position
        else:
            if event.button_index == BUTTON_LEFT:
                dragging = false

    if event is InputEventMouseMotion:
        if dragging:
            update_pan(event.global_position)
