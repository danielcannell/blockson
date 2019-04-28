extends PopupPanel


const TechButton = preload("res://UI/TechButton.tscn")


var btn_handles = {};


func on_button_clicked():
    pass


func on_button_toggled(visible):
    self.visible = visible


func on_tech_update(tech_state):
    for tech in tech_state:
        if not tech in btn_handles:
            var btn = TechButton.instance()
            btn.get_node("Label").text = "TEST\nTEST\nTEST"
            btn_handles[tech] = btn
            add_child(btn)
