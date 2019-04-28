extends Button

var cost = 0.0 setget set_cost
var iname = "" setget set_name


func _ready():
    disabled = true


func set_cost(c):
    cost = c
    get_node("CostLabel").set_text(String(c))
    
func set_name(n):
    iname = n
    get_node("NameLabel").set_text(n)
