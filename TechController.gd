extends Node


signal tech_update


# name -> TechState
var tech_states = {}


var tick_timer = Timer.new()


func _init():
    tick_timer.wait_time = 1.0
    tick_timer.connect("timeout", self, "tick")
    tick_timer.start()

    self.add_child(tick_timer)


func on_ui_tech_request(name):
    var machine = Globals.MACHINES[name]

    if machine.tech_unlocked and machine.tech_progress < 1.0:
        # Make tech progress non-zero to kick it off
        machine.tech_progress = 0.01

        # Let the UI know
        emit_signal("tech_update")


func _tick():
    pass