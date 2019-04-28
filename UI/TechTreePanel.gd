extends PopupPanel


const TechButton = preload("res://UI/TechButton.tscn")


var btn_handles = {}
var col_handles


func _ready():
    col_handles = {
        Globals.TechFlavour.BITCOIN: get_node("ScrollContainer/HBoxContainer/BitcoinTree"),
        Globals.TechFlavour.ETHEREUM: get_node("ScrollContainer/HBoxContainer/EthereumTree"),
        Globals.TechFlavour.POWER: get_node("ScrollContainer/HBoxContainer/PowerTree"),
        Globals.TechFlavour.NETWORK: get_node("ScrollContainer/HBoxContainer/NetworkTree"),
    }


func on_button_clicked():
    pass


func on_button_toggled(visible):
    self.visible = visible


func on_tech_update(tech_state):
    for tech in tech_state:
        if not tech in btn_handles:
            var spec = Globals.TECH_SPECS[tech]
            var btn = TechButton.instance()
            btn.get_node("Label").text = "%s\nUnlock: %s thoughts\nLevel: %s" % [tech, spec.thoughts, spec.level]
            btn_handles[tech] = btn
            col_handles[spec.flavour].add_child(btn)
            btn_handles[tech].get_node("Wipe").set_percent(0)

        var state = tech_state[tech]

        if state.is_building():
            btn_handles[tech].get_node("Wipe").set_percent(state.progress * 100)
        else:
            btn_handles[tech].get_node("Wipe").set_percent(0)

        btn_handles[tech].get_node("TextureButton").disabled = not state.is_buildable()

