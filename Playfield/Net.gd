extends Node

var kind = -1
var ports = []
var supply = 0

func _init(kind):
    self.kind = kind


func is_working():
    return supply >= demand() and ports.size() < max_fanout()


func demand():
    var d = 0
    for p in ports:
        if p.supplies[kind] < 0:
            d += p.supplies[kind]
    return -d


func max_fanout():
    # todo find lowest non-negative fanout of any port
    return 9999999
