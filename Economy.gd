extends Node


signal balance_updated
signal level_completed
signal player_win
signal tutorial_event


var income_per_sec = 0.0
var thoughts_per_sec = 1.0

var btc_balance = 0


func _init():
    btc_balance = Config.INITIAL_BITCOIN


func _process(delta):
    btc_balance += delta * income_per_sec
    emit_signal("balance_updated", btc_balance, thoughts_per_sec)

    if income_per_sec > 0:
        emit_signal("tutorial_event", Globals.TutorialEvents.EARNING_MONEY)

    if thoughts_per_sec > 1.0:
        emit_signal("tutorial_event", Globals.TutorialEvents.EARNING_THOUGHTS)

    if thoughts_per_sec > Config.LEVEL_THRESHOLDS[Config.level]:
        if Config.level == len(Config.LEVEL_THRESHOLDS) - 1:
            emit_signal("player_win")
            return
        Config.base_thoughts_per_second = thoughts_per_sec
        emit_signal("level_completed")



func on_playfield_mining_result(_thoughts_per_sec, _income_per_sec):
    thoughts_per_sec = _thoughts_per_sec
    income_per_sec = _income_per_sec


func on_ui_spend(amount):
    btc_balance -= amount
