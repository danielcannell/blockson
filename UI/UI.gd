extends Node2D


signal request_placement


onready var shop_list = get_node("CanvasLayer/Panel/ScrollContainer/ShopList")


func _ready():
    for machine in Config.MACHINES:
        add_item(machine)
    shop_list.connect("item_request", self, "item_request")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func item_request(type):
    emit_signal("request_placement", type)


func add_item(item):
    var btn = shop_list.make_item(item)
