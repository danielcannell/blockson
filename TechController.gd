extends Node


signal tech_update


# name -> TechState
var tech_states = {}

var thoughts_per_sec = 0
var bitcoin_per_sec = 0


func _init():
    # Initialise the tech states
    for name in Globals.MACHINES:
        if Globals.TECH_SPECS[name].thoughts == 0:
            tech_states[name] = Globals.TechState.new(1.0, true)
        else:
            tech_states[name] = Globals.TechState.new(0.0, false)
            

func _ready():
    emit_signal("tech_update", tech_states)


func _process(delta):
    var update = []

    for name in tech_states:
        var ts = tech_states[name]
        if ts.is_building():
            update.append(name)

    if len(update) == 0:
        return

    var thoughts_per_tech = thoughts_per_sec * delta / len(update)

    for tech in update:
        var spec = Globals.TECH_SPECS[tech]
        var state = tech_states[tech]

        state.progress += thoughts_per_tech / spec.thoughts

        if state.is_complete():
            complete_tech()


func complete_tech():
    var levels = {}

    for flavour in Globals.TECH_FLAVOURS:
        levels[flavour] = 0

    for tech in Globals.TECH_SPECS:
        var spec = Globals.TECH_SPECS[tech]
        var state = tech_states[tech]

        if state.is_complete():
            levels[spec.flavour] = max(spec.level + 1, levels[spec.flavour])

    for tech in Globals.TECH_SPECS:
        var spec = Globals.TECH_SPECS[tech]
        var state = tech_states[tech]

        if spec.level <= levels[spec.flavour]:
            state.unlocked = true

    emit_signal("tech_update", tech_states)


func on_ui_tech_request(name):
    var state = tech_states[name]

    if state.is_buildable:
        # Kick it off
        state.progress = 0.01

        # Let the UI know
        emit_signal("tech_update", tech_states)


func on_playfield_mining_result(thoughts_per_sec, bitcoin_per_sec):
    self.thoughts_per_sec = thoughts_per_sec
    self.bitcoin_per_sec = bitcoin_per_sec
