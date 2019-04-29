extends CanvasLayer

var occured = []
onready var popup = get_node("Popup")
onready var instructions = get_node("Popup/Panel/VBoxContainer/RichTextLabel")
var handlers = {
    Globals.TutorialEvents.UI_READY: "handle_ui_ready",
    Globals.TutorialEvents.PLAYFIELD_READY: null,
    Globals.TutorialEvents.NET_FANOUT_TOO_HIGH: "handle_net_fanout_too_high",
    Globals.TutorialEvents.NET_OVERLOADED: "handle_net_overloaded",
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


func handle_net_fanout_too_high():
    get_tree().paused = true
    instructions.text = """You've connected too many machines to a single network.

Blue data networks have a maximum number of devices which can be connected to each other on a single wire.
If you connect too many devices, none of them will work.

The network ports in the wall have a limit of 1 device.
A Router can be used to allow more connections: 4 devices can be connected to its lower port.

Try placing a Router to solve the overload."""
    popup.visible = true


func handle_net_overloaded():
    get_tree().paused = true
    instructions.text = """You're drawing too much power from a single power transformer.

Transformers can supply a limited amount of power.
You can connect the output of several transformers together to provide more power."""
    popup.visible = true


func handle_popup_ok_pressed():
    get_tree().paused = false
    get_node("Popup").visible = false
