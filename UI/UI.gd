extends Node2D


signal request_placement
signal tutorial_event


onready var shop_list = get_node("CanvasLayer/Panel/VBoxContainer/ScrollContainer/ShopList")


func _ready():
    # Add constant 4-px spacing between vertical items
    get_node("CanvasLayer/Panel/VBoxContainer").add_constant_override("hseparation", 4)

    for machine in Globals.MACHINES:
        shop_list.make_machine_item(machine)

    for wire in Globals.WIRES:
        shop_list.make_wire_item(wire)

    emit_signal("tutorial_event", Globals.TutorialEvents.UI_READY)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func on_playfield_end_placing(placed):
    shop_list.release_button()


func on_playfield_balance_changed(balance):
    get_node("CanvasLayer/Panel/VBoxContainer/BalanceContainer/Balance").set_text(String(balance) + "BTC")


func _on_shopList_item_request(type):
    emit_signal("request_placement", type)
