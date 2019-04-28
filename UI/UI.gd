extends Node2D


signal request_placement
signal tutorial_event
signal spend


onready var shop_list = get_node("CanvasLayer/Panel/VBoxContainer/ScrollContainer/ShopList")
onready var balance_label = get_node("CanvasLayer/Panel/VBoxContainer/BalanceContainer/Balance")
var balance = 0.0


func _ready():
    # Add constant 4-px spacing between vertical items
    get_node("CanvasLayer/Panel/VBoxContainer").add_constant_override("hseparation", 4)

    for machine in Globals.MACHINES:
        shop_list.make_machine_item(machine)

    for wire in Globals.WIRES:
        shop_list.make_wire_item(wire)

    emit_signal("tutorial_event", Globals.TutorialEvents.UI_READY)


func on_playfield_end_placing(placed):
    if placed:
        var cost = shop_list.selected().cost
        emit_signal("spend", cost)
    shop_list.release_button()


func on_economy_balance_changed(balance):
    self.balance = balance
    var msg = "%.f" % balance + "BTC"
    balance_label.set_text(msg)
    shop_list.update_balance(balance)


func _on_shopList_item_request(type):
    emit_signal("request_placement", type)
