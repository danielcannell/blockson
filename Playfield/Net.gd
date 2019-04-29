extends Node

var kind = -1
var ports = []
var wires = []
var supply = 0

func _init(kind):
    self.kind = kind


func is_working():
    return not is_overloaded() and not fanout_too_high()


func is_overloaded():
    return supply < demand()


func fanout_too_high():
    return ports.size() > max_fanout()


func demand():
    var d = 0
    for p in ports:
        if p.supplies[kind] < 0:
            d += p.supplies[kind]
    return -d


func max_fanout():
    var f = 9999999
    for p in ports:
        if p.fanout[kind] > 0:
            f = int(min(f, p.fanout[kind]))
    return f


func to_string():
    return "Net{kind=%d, ports=%s, supply=%d, #wires=%d}" % [kind, str(ports), supply, wires.size()]
