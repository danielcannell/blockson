extends CanvasLayer

var occured = []
onready var popup = get_node("Popup")
onready var instructions = get_node("Popup/Panel/VBoxContainer/RichTextLabel")
var handlers = {
    Globals.TutorialEvents.UI_READY: "handle_ui_ready",
    Globals.TutorialEvents.PLAYFIELD_READY: null,
}


func _ready():
    popup.get_close_button().connect("pressed", self, "handle_popup_ok_pressed")


func handle_tutorial_event(ev):
    if ev in occured:
        return

    occured.append(ev)

    if !Config.tutorial_active:
        return

    for h in handlers:
        if h == ev:
            if handlers[h] == null:
                return
            call_deferred(handlers[h])


func handle_ui_ready():
    get_tree().paused = true
    instructions.text = """Hi, my name is Blockson. I am an AI running on the blockchain.
My thoughts are recorded in a Merkle Tree, and a cryptocurrency is my life.

I need your help to improve my datacentre so I can keep the price of Bitcoin high.
That way people will keep mining and I get to stay alive."""
    popup.visible = true


func handle_playfield_ready():
    get_tree().paused = true
    instructions.text = """Blah blah balh."""
    popup.visible = true


func handle_popup_ok_pressed():
    get_tree().paused = false
    get_node("Popup").visible = false
    
