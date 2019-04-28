extends Node2D


signal cancel_placement_request
signal request_placement
signal tutorial_event
signal spend
signal enter_delete_mode
signal ui_tech_request


onready var shop_list = get_node("CanvasLayer/Panel/VBoxContainer/ScrollContainer/ShopList")
onready var tech_tree = get_node("CanvasLayer/TechTreePanel")
onready var balance_label = get_node("CanvasLayer/Panel/VBoxContainer/BalanceContainer/Balance")
onready var think_rate_label = get_node("CanvasLayer/Panel/VBoxContainer/ThinkRateContainer/ThinkRate")
var balance = 0.0
var buttongroup = ButtonGroup.new()


func _ready():
    # Add constant 4-px spacing between vertical items
    get_node("CanvasLayer/Panel/VBoxContainer").add_constant_override("hseparation", 4)

    for machine in Globals.MACHINES:
        shop_list.make_machine_item(machine, buttongroup)

    for wire in Globals.WIRES:
        shop_list.make_wire_item(wire, buttongroup)

    get_node("CanvasLayer/Panel/VBoxContainer/TrashContainer/Button").set_button_group(buttongroup)

    # Testing
    #on_tech_update({
    #    "Bitcoin Miner": Globals.TechState.new(1, true),
    #    "Ethereum Miner": Globals.TechState.new(1, true),
    #    "Basic Router": Globals.TechState.new(1, true),
    #    "Transformer": Globals.TechState.new(1, true),
    #})

    emit_signal("tutorial_event", Globals.TutorialEvents.UI_READY)


func on_playfield_end_placing(placed):
    if placed:
        var cost = shop_list.selected().cost
        emit_signal("spend", cost)
    shop_list.release_button()


func format_thoughts(thoughts_per_sec):
    if thoughts_per_sec > 1e12:
        return "%.1f" % (thoughts_per_sec / 1e12) + "PHz"
    if thoughts_per_sec > 1e9:
        return "%.1f" % (thoughts_per_sec / 1e9) + "GHz"
    if thoughts_per_sec > 1e6:
        return "%.1f" % (thoughts_per_sec / 1e6) + "MHz"
    if thoughts_per_sec > 1e3:
        return "%.1f" % (thoughts_per_sec / 1e3) + "kHz"
    return "%.f" % thoughts_per_sec + "Hz"


func on_economy_balance_changed(bitcoin_balance, thoughts_per_sec):
    self.balance = bitcoin_balance
    var msg = "%.f" % balance + "BTC"
    balance_label.set_text(msg)
    think_rate_label.set_text(format_thoughts(thoughts_per_sec))
    shop_list.update_balance(balance)


func _on_shopList_item_request(type):
    emit_signal("request_placement", type)


func on_delete_button_pressed():
   emit_signal("enter_delete_mode")


func on_playfield_delete_completed():
    get_node("CanvasLayer/Panel/VBoxContainer/TrashContainer/Button").pressed = false


func on_tech_update(tech_state):
    update_shop_list(tech_state)
    tech_tree.on_tech_update(tech_state)


func _on_ShopList_cancel_item_request():
    emit_signal("cancel_placement_request")


func update_shop_list(tech_state):
    shop_list.release_button()
    var cur_btns = []
    for ch in shop_list.get_children():
        if not ch.iname in Globals.WIRES:
            shop_list.remove_child(ch)
            call_deferred("free", ch)
    for tech in tech_state:
        if tech_state[tech].unlocked:
            shop_list.make_machine_item(tech, buttongroup)


func on_test_button_pressed():
    emit_signal("ui_tech_request", "Bitcoin Miner 2")
