extends Node

var kind = -1
var ports = []
var supply = 0

func _init(kind):
    self.kind = kind


func is_working():
    return supply >= demand() and ports.size() <= max_fanout()


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
    return "Net{kind=%d, ports=%s, supply=%d}" % [kind, str(ports), supply]
