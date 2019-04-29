extends Node


signal tech_update
signal tech_shop_updated


var thoughts_per_sec = 0
var bitcoin_per_sec = 0


func _init():
    # Initialise the tech states
    for name in Globals.MACHINES:
        if not name in Config.tech_states:
            if Globals.TECH_SPECS[name].thoughts == 0:
                Config.tech_states[name] = Globals.TechState.new(1.0, true)
            else:
                Config.tech_states[name] = Globals.TechState.new(0.0, false)

    complete_tech()


func _ready():
    emit_signal("tech_update", Config.tech_states)
    emit_signal("tech_shop_updated", Config.tech_states)


func _process(delta):
    var update = []
    var tech_states = Config.tech_states

    for name in tech_states:
        var ts = tech_states[name]
        if ts.is_building():
            update.append(name)

    if len(update) == 0:
        return

    var thoughts_per_tech = thoughts_per_sec * delta / len(update)

    var any_completed = false

    for tech in update:
        var spec = Globals.TECH_SPECS[tech]
        var state = tech_states[tech]

        state.progress += thoughts_per_tech / spec.thoughts

        if state.is_complete():
            any_completed = true

    if any_completed:
        complete_tech()
        emit_signal("tech_shop_updated", tech_states)

    emit_signal("tech_update", tech_states)


func complete_tech():
    var levels = {}
    var tech_states = Config.tech_states

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


func on_ui_tech_request(name):
    var state = Config.tech_states[name]

    if state.is_buildable():
        # Kick it off
        state.progress = 0.01


func on_playfield_mining_result(thoughts_per_sec, bitcoin_per_sec):
    self.thoughts_per_sec = thoughts_per_sec
    self.bitcoin_per_sec = bitcoin_per_sec
