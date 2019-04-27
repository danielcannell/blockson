extends Camera2D

func update_zoom(ratio):
    var new_scale = self.zoom.x * ratio
    new_scale = min(new_scale, Config.MAX_ZOOM)
    new_scale = max(new_scale, Config.MIN_ZOOM)
    self.zoom.x = new_scale
    self.zoom.y = new_scale


func _input(event):
    if event is InputEventMouseButton:
        if event.is_pressed():
            # zoom in
            if event.button_index == BUTTON_WHEEL_UP:
                update_zoom(0.9)

            # zoom out
            if event.button_index == BUTTON_WHEEL_DOWN:
                update_zoom(1.1)
