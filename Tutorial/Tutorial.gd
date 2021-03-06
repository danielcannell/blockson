extends CanvasLayer

onready var popup = get_node("Popup")
onready var instructions = get_node("Popup/Panel/VBoxContainer/RichTextLabel")
var handlers = {
    Globals.TutorialEvents.UI_READY: "handle_ui_ready",
    Globals.TutorialEvents.PLAYFIELD_READY: null,
    Globals.TutorialEvents.NET_FANOUT_TOO_HIGH: "handle_net_fanout_too_high",
    Globals.TutorialEvents.NET_OVERLOADED: "handle_net_overloaded",
    Globals.TutorialEvents.TRANSFORMER_PLACED: "handle_transformer_placed",
    Globals.TutorialEvents.BITCOIN_MINER_PLACED: "handle_bitcoin_miner_placed",
    Globals.TutorialEvents.ETHEREUM_MINER_PLACED: "handle_ethereum_miner_placed",
    Globals.TutorialEvents.EARNING_MONEY: "handle_earning_money",
    Globals.TutorialEvents.EARNING_THOUGHTS: "handle_thinking_faster",
    Globals.TutorialEvents.TRANFORMER_POWERED: "handle_transformer_powered",
}
var popup_pending = null


func _ready():
    popup.get_close_button().connect("pressed", self, "handle_popup_ok_pressed")


func handle_tutorial_event(ev):
    if ev in Config.tutorial_occurred:
        return

    Config.tutorial_occurred.append(ev)

    if !Config.tutorial_active:
        return

    for h in handlers:
        if h == ev:
            if handlers[h] == null:
                return
            call_deferred(handlers[h])


func handle_ui_ready():
    get_tree().paused = true
    instructions.bbcode_text = """Hi, my name is [b]Blockson[/b]. I am an AI running on the blockchain. My thoughts are recorded in a Merkle Tree, and a cryptocurrency is my life.

I need your help to improve my datacentre. That way I can get thinking faster and faster. Might take over the world or something when I get smart enough, idk.

Press \"P\" or \"Pause\" to pause at any time."""
    popup_pending = """We'll need to power some units, so [u]use the shop to buy a transformer[/u].

Place it somewhere in the middle of the data centre.
    """
    popup.visible = true


func handle_transformer_placed():
    get_tree().paused = true
    instructions.bbcode_text = """Thanks! Things that are missing a resource flash with a lightning bolt.

Your transformer requires some [b]three-phase supply[/b]. [u]Connect the top of the transformer to a red port on the wall using some three-phase cable[/u].

We'll need some money if we're going to keep this up, so after that [u]try placing a Bitcoin miner[/u].
"""
    popup.visible = true


func handle_transformer_powered():
    get_tree().paused = true
    instructions.bbcode_text = """Fantastic job! Next up, place a [u]Bitcoin Miner[/u] under the transformer. Be sure to leave some space for cables!
"""
    popup.visible = true


func handle_ethereum_miner_placed():
    get_tree().paused = true
    instructions.bbcode_text = """Thank you so much! Now you'll need to give it network and power, just like the Bitcoin miner.

"""
    popup.visible = true



func handle_bitcoin_miner_placed():
    get_tree().paused = true
    instructions.bbcode_text = """Great! You'll now need to [u]hook up some yellow electric cable from the transformer to the port on the miner[/u].

It will also need blue network cable as well - I'm sure you will be able to work it out.
"""
    popup.visible = true


func handle_thinking_faster():
    get_tree().paused = true
    instructions.bbcode_text = """[b]Amazing!!![/b] Don't forget to use the tech tree to unlock new, faster miners!
"""
    popup.visible = true


func handle_earning_money():
    get_tree().paused = true
    instructions.bbcode_text = """Nice, now we're getting somewhere! We can get better tech with the Tech Tree, but [u]we'll need some Ethereum Miners[/u] to help me unlock them...

You know what to do!
"""
    popup.visible = true


func handle_playfield_ready():
    get_tree().paused = true
    instructions.bbcode_text = """Blah blah balh."""
    popup.visible = true


func handle_net_fanout_too_high():
    get_tree().paused = true
    instructions.bbcode_text = """Uh oh! You've connected too many machines to a single network.

[u]A Router can be used to allow more connections: 4 devices can be connected to its lower port.[/u]
The network ports in the wall have a limit of 1 device.

Try using a [u]Router[/u] to solve the overload."""
    popup.visible = true


func handle_net_overloaded():
    get_tree().paused = true
    instructions.bbcode_text = """Oh no! You're drawing too much power from a single power transformer.

Transformers can supply a limited amount of power.
[u]You can connect the output of several transformers together to provide more power.[/u]"""
    popup.visible = true


func handle_popup_ok_pressed():
    if popup_pending:
        instructions.bbcode_text = popup_pending
        popup_pending = null
        return
    get_tree().paused = false
    get_node("Popup").visible = false


func on_checkbox_toggled(button_pressed):
    Config.tutorial_active = button_pressed
