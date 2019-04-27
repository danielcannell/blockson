extends Node

var pos = Vector2()

# Used for net detection
var mark = false

var kinds = {
    Globals.Wire.ELECTRIC: false,
    Globals.Wire.THREE_PHASE: false,
    Globals.Wire.NETWORK: false,
}


func add_kind(kind):
    kinds[kind] = true


func has_kind(kind):
    return kinds[kind]


func is_wire():
    return true


func size():
    return Vector2(1, 1)


# Whether a wire of a certain kind should connect from a given tile
func accepts_wire_from_tile(x, y, kind):
    if not kinds[kind]: return false
    if (x == pos.x-1 and y == pos.y) or (x == pos.x+1 and y == pos.y) or (x == pos.x and y == pos.y-1) or (x == pos.x and y == pos.y+1):
        return true


func _is_data_wire(m):
    if not kinds[Globals.Wire.NETWORK]: return -1
    return 1 if m != null and m.accepts_wire_from_tile(pos.x, pos.y, Globals.Wire.NETWORK) else 0


func _is_power_wire(m):
    if not kinds[Globals.Wire.ELECTRIC]: return -1
    return 1 if m != null and m.accepts_wire_from_tile(pos.x, pos.y, Globals.Wire.ELECTRIC) else 0


func _is_3phase_wire(m):
    if not kinds[Globals.Wire.THREE_PHASE]: return -1
    return 1 if m != null and m.accepts_wire_from_tile(pos.x, pos.y, Globals.Wire.THREE_PHASE) else 0


func _compute_tile_id(fref, n, s, e, w):
    return (fref.call_func(n) | (fref.call_func(s) << 1) | (fref.call_func(w) << 2) | (fref.call_func(e) << 3))


func tile(n, s, e, w):
    var func_is_data_wire = funcref(self, "_is_data_wire")
    var func_is_power_wire = funcref(self, "_is_power_wire")
    var func_is_3phase_wire = funcref(self, "_is_3phase_wire")
    var datawire_id = _compute_tile_id(func_is_data_wire, n, s, e, w)
    var powerwire_id = _compute_tile_id(func_is_power_wire, n, s, e, w)
    var threephasewire_id = _compute_tile_id(func_is_3phase_wire, n, s, e, w)
    var cabletray_id = int(max(datawire_id, 0)) | int(max(powerwire_id, 0)) | int(max(threephasewire_id, 0))

    return [cabletray_id, datawire_id, powerwire_id, threephasewire_id]
