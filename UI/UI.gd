extends Node2D


signal request_placement


onready var shop_list = get_node("CanvasLayer/Panel/ScrollContainer/ShopList")


func _ready():
    for machine in Globals.MACHINES:
        shop_list.make_machine_item(machine)

    for wire in Globals.WIRES:
        shop_list.make_wire_item(wire)

    shop_list.connect("item_request", self, "item_request")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func item_request(type):
    emit_signal("request_placement", type)
