extends Node2D


signal request_placement


onready var shop_list = get_node("CanvasLayer/Panel/VBoxContainer/ScrollContainer/ShopList")


func _ready():
    # Add constant 4-px spacing between vertical items
    get_node("CanvasLayer/Panel/VBoxContainer").add_constant_override("hseparation", 4)
    for machine in Config.MACHINES:
        add_item(machine)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass



func add_item(item):
    var btn = shop_list.make_item(item)


func on_playfield_end_placing(placed):
    shop_list.release_button()


func on_playfield_balance_changed(balance):
    get_node("CanvasLayer/Panel/VBoxContainer/BalanceContainer/Balance").set_text(String(balance) + "BTC")


func _on_shopList_item_request(type):
    emit_signal("request_placement", type)
