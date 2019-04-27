extends VBoxContainer


const ShopButton = preload("res://UI/ShopButton.tscn");


signal item_request


func make_item(name):
    var m = Config.MACHINES[name]
    var btn = ShopButton.instance()
    btn.get_node("CostLabel").set_text(String(m.new().cost()))
    btn.get_node("NameLabel").set_text(name)
    btn.connect("pressed", self, "item_request", [name])
    add_child(btn)
    return btn


func item_request(name):
    emit_signal("item_request", name)
