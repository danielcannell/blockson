extends VBoxContainer


const ShopButton = preload("res://UI/ShopButton.tscn");


signal item_request


func make_machine_item(name):
    var m = Globals.MACHINES[name]
    var btn = ShopButton.instance()
    btn.name = name
    btn.get_node("CostLabel").set_text(String(m.new().cost()))
    btn.get_node("NameLabel").set_text(name)
    btn.connect("pressed", self, "item_request", [name])
    add_child(btn)
    return btn


func make_wire_item(name):
    var btn = ShopButton.instance()
    btn.name = name
    btn.get_node("CostLabel").set_text("0")
    btn.get_node("NameLabel").set_text(name)
    btn.connect("pressed", self, "item_request", [name])
    add_child(btn)
    return btn


func item_request(name):
    release_button_except(name)        
    emit_signal("item_request", name)


func release_button():
    release_button_except(null)


func release_button_except(ex):
    for ch in get_children():
        if ch.name != ex:
            ch.pressed = false