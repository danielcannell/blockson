extends WindowDialog


func _ready():
    get_node("VBoxContainer/Button").connect("pressed", self, "toggle_paused")
    get_node("VBoxContainer/Button2").connect("pressed", self, "next_level")
    get_close_button().connect("pressed", self, "set_paused", [false])


func _input(event):
    if event.is_action_pressed("ui_pause"):
        toggle_paused()


func set_paused(state):
    if get_tree().is_paused() and !visible:
        # We are paused for another reason (e.g. tutorial).
        # Ignore for now.
        return
    get_tree().paused = state
    visible = state


func toggle_paused():
    set_paused(!visible)


func next_level():
    Config.load_with_map(32, 32)
