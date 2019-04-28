extends WindowDialog


func _ready():
    get_node("VBoxContainer/Button").connect("pressed", self, "toggle_paused")


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
