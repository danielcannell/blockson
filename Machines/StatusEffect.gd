extends Node2D

onready var sprite = get_node("Sprite")
var machine = null

func blink(rate: float):
    var t = Globals.time
    var rem = t - floor(t / rate) * rate
    return rem < rate / 2


func _process(delta):
    if machine != null:
        sprite.visible = blink(1) and machine.checked

        # Get status effects and compute sprite region
        var needselectric = 0 if machine.working(Globals.Wire.ELECTRIC) else 1
        var needsnetwork = 0 if machine.working(Globals.Wire.NETWORK) else 1
        var needs3phase = 0 if machine.working(Globals.Wire.THREE_PHASE) else 1
        var x = needselectric | (needsnetwork << 1) | (needs3phase << 2)
        sprite.region_rect.position = Vector2(x*32, 0)
