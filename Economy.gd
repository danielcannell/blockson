extends Node


signal balance_updated


var income_per_sec = 0.0
var thoughts_per_sec = 0.0

var btc_balance = 100000.0


func _process(delta):
    btc_balance += delta * income_per_sec
    emit_signal("balance_updated", btc_balance)


func on_playfield_mining_result(_thoughts_per_sec, _income_per_sec):
    thoughts_per_sec = _thoughts_per_sec
    income_per_sec = _income_per_sec


func on_ui_spend(amount):
    btc_balance -= amount
