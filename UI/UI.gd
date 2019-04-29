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


var machine_buttons = {}


func _ready():
    # Add constant 4-px spacing between vertical items
    get_node("CanvasLayer/Panel/VBoxContainer").add_constant_override("hseparation", 4)
    get_node("CanvasLayer/Panel/VBoxContainer/TrashContainer/Button").set_button_group(buttongroup)

    for wire in Globals.WIRES:
        shop_list.make_wire_item(wire, buttongroup)

    for tech in Globals.MACHINES:
        machine_buttons[tech] = shop_list.make_machine_item(tech, buttongroup)
        machine_buttons[tech].visible = false

    emit_signal("tutorial_event", Globals.TutorialEvents.UI_READY)


func on_playfield_end_placing(placed):
    if placed:
        var cost = shop_list.selected().cost
        emit_signal("spend", cost)
    shop_list.release_button()


func format_thoughts(thoughts_per_sec):
    if thoughts_per_sec > 1e16:
        return "%.1f" % (thoughts_per_sec / 1e16) + "PHz"
    if thoughts_per_sec > 1e12:
        return "%.1f" % (thoughts_per_sec / 1e12) + "THz"
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
    tech_tree.on_tech_update(tech_state)


func on_tech_shop_updated(tech_state):
    update_shop_list(tech_state)


func _on_ShopList_cancel_item_request():
    emit_signal("cancel_placement_request")


func update_shop_list(tech_state):
    shop_list.release_button()

    for tech in tech_state:
        machine_buttons[tech].visible = tech_state[tech].is_complete()

    shop_list.update_balance(balance)


func on_test_button_pressed():
    emit_signal("ui_tech_request", "Bitcoin Miner 2")


func on_techtreepanel_button_clicked(name):
    emit_signal("ui_tech_request", name)


func on_economy_level_completed():
    get_node("CanvasLayer/LevelCompleteDialog").visible = true
    get_tree().paused = true


func on_next_level_requested():
    Config.next_level()


func on_economy_player_win():
    get_node("CanvasLayer/GameCompleteDialog").visible = true
    get_tree().paused = true


func on_restart_requested():
    Config.level = -1
    Config.next_level()
