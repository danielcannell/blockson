extends VBoxContainer


const ShopButton = preload("res://UI/ShopButton.tscn");


signal item_request


func make_machine_item(name, buttongroup):
    var m = Globals.MACHINES[name]
    var btn = ShopButton.instance()
    var cost = Config.MACHINE_COST[name]
    btn.iname = name
    btn.cost = cost
    btn.connect("pressed", self, "item_request", [name])
    add_child(btn)
    btn.set_button_group(buttongroup)
    return btn


func make_wire_item(name, buttongroup):
    var btn = ShopButton.instance()
    btn.iname = name
    btn.cost = 0
    btn.connect("pressed", self, "item_request", [name])
    add_child(btn)
    btn.set_button_group(buttongroup)
    return btn


func update_balance(bal):
    for ch in get_children():
        if ch.cost < bal:
            ch.disabled = false
        else:
            ch.disabled = true


func selected():
    for ch in get_children():
        if ch.pressed:
            return ch
    return null


func item_request(name):
    emit_signal("item_request", name)


func release_button():
    release_button_except(null)


func release_button_except(ex):
    for ch in get_children():
        if ch.iname != ex:
            ch.pressed = false
