extends Node2D

const RELAXATION_TIME = 5
const TOTAL_VECS = 9

const VECS = {
    0: Vector2(0, 0),
    1: Vector2(1, 0),
    2: Vector2(0, -1),
    3: Vector2(-1, 0),
    4: Vector2(0, 1),
    5: Vector2(1, -1),
    6: Vector2(-1, -1),
    7: Vector2(-1, 1),
    8: Vector2(1, 1),
}

const DIRECTIONS = {
    Vector2(0, 0): 0,
    Vector2(1, 0): 1,
    Vector2(0, -1): 2,
    Vector2(-1, 0): 3,
    Vector2(0, 1): 4,
    Vector2(1, -1): 5,
    Vector2(-1, -1): 6,
    Vector2(-1, 1): 7,
    Vector2(1, 1): 8,
}

const WORLD_DIRECTIONS = {
    Globals.Direction.NORTH: Vector2(0, -1),
    Globals.Direction.SOUTH: Vector2(0, 1),
    Globals.Direction.EAST: Vector2(1, 0),
    Globals.Direction.WEST: Vector2(-1, 0),
}

const WORLD_DIRECTIONS_I = {
    Globals.Direction.NORTH: 2,
    Globals.Direction.SOUTH: 4,
    Globals.Direction.EAST: 1,
    Globals.Direction.WEST: 3,
}

const WEIGHTS = {
    0: 4 / 9.0,
    1: 1 / 9.0,
    2: 1 / 9.0,
    3: 1 / 9.0,
    4: 1 / 9.0,
    5: 1 / 36.0,
    6: 1 / 36.0,
    7: 1 / 36.0,
    8: 1 / 36.0,
}

const INVERSE = {
    0: 0,
    1: 3,
    2: 4,
    3: 1,
    4: 2,
    5: 7,
    6: 8,
    7: 5,
    8: 6,
}

const THERMAL_CAPACITY = 20;


class FlowNode:
    var f
    var t

    func _init():
        self.f = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        self.t = 0.0

    func get_density():
        var density = 0.0;
        for e in f:
            density += e
        return density

    # sets an eqilibium density
    func set_eq_density(n):
        for i in range(TOTAL_VECS):
            f[i] = n * WEIGHTS[i]

    func set_density(n):
        var change = n / self.get_density()
        for i in range(TOTAL_VECS):
            self.f[i] = self.f[i] * change

    func get_momentum():
        return Vector2(f[1] - f[3] + f[5] - f[7] + f[8] - f[6], f[4] - f[2] + f[8] - f[5] + f[7] - f[6])

    func get_vel():
        return self.get_momentum() / self.get_density()

    # get the terminal momentum in a direction
    func thermal_momentum(i):
        return self.t * (self.f[i] / self.get_density())


class DirectionalBoundary:
    var blocked_dirs = []

    func _init(blocked):
        self.blocked_dirs = blocked

    func propagate_momentum(node, neighbour, i):
        if blocked_dirs.has(i):
            return neighbour.f[INVERSE[i]]
        return node.f[i]

class FlowBoundary:
    var vec
    var strength

    func _init(vec, strength):
        self.vec = vec
        self.strength = strength

    func update_node(node):
        var density = node.get_density()
        node.set_eq_density(0)
        var i = DIRECTIONS[vec]
        node.f[i] = strength * WEIGHTS[i] * density
        node.f[0] = (1 - strength) * WEIGHTS[0] * density

    func propagate_momentum(node, to_node, i):
        var flow_dir = DIRECTIONS[vec]
        if i != flow_dir:
            return to_node.f[INVERSE[i]]
        return node.f[i]


class FlowObject:
    var vec
    var strength
    var temp
    var machine

    func _init(machine):
        self.machine = machine

    func step(nodes):
        for node in nodes:
            var dt = node.t - machine.temperature
            var flow = (-1 * dt) * 0.1 # 0.1 second update time
            node.t += flow / THERMAL_CAPACITY
            machine.temperature -= flow / machine.thermal_capacity

    func propagate_momentum_away(node, to_node, i):
        return to_node.f[INVERSE[i]]
        if i != WORLD_DIRECTIONS[Globals.Direction.WEST]:
            return to_node.f[INVERSE[i]]
        return node.f[i]

class StaticBoundary:
    var _null

var STATIC_BOUNDARY = StaticBoundary.new()



class PressureBoundary:
    var target_density

    func _init(target_density):
        self.target_density = target_density

    func update_node(node):
        node.set_density(self.target_density)


class NodeInfo:
    var blocked_dirs

    func _init():
        blocked_dirs = {0: false, 1: false, 2: false, 3: false, 4: false, 5: false, 6: false, 7: false, 8: false}

    func is_blocked(i):
        if i == 5:
            return blocked_dirs[2] or blocked_dirs[1]
        elif i == 8:
            return blocked_dirs[1] or blocked_dirs[4]
        elif i == 7:
            return blocked_dirs[3] or blocked_dirs[4]
        elif i == 6:
            return blocked_dirs[3] or blocked_dirs[2]
        return blocked_dirs[i]

class Lattice:
    var dims
    var nodes
    var next_nodes
    var boundaries
    var flow_objects
    var walls



    func _init(dims: Vector2):
        self.dims = dims
        self.nodes = create_nodes(dims, 1, 1)
        self.next_nodes = create_nodes(dims, 1, 1)
        self.walls = create_walls()
        self.boundaries = {}

    func create_nodes(dims: Vector2, init_n: float, init_t: float):
        var nodes = []
        for x in range(dims.x):
            var col = []
            for y in range(dims.y):
                var node = FlowNode.new()
                node.set_eq_density(init_n)
                node.t = init_t
                col.append(node)
            nodes.append(col)
        return nodes

    func create_walls():
        var nodes = []
        for x in range(dims.x):
            var col = []
            for y in range(dims.y):
                col.append(NodeInfo.new())
            nodes.append(col)
        return nodes

    func total_mom():
        var total = Vector2(0, 0)
        for x in range(self.dims.x):
            for y in range(self.dims.y):
                total += self.nodes[x][y].get_momentum()
        return total

    func avg_numeric_density():
        var total = 0
        for x in range(self.dims.x):
            for y in range(self.dims.y):
                total += self.nodes[x][y].get_density()
        return total / (self.dims.x * self.dims.y)

    func avg_temp():
        var total = 0.0
        for x in range(self.dims.x):
            for y in range(self.dims.y):
                total += self.nodes[x][y].t
        return total / (self.dims.x * self.dims.y)


    func get_flownode(pos: Vector2):
        return self.nodes[pos.x][pos.y]

    func sum(f):
        var sum = 0;
        for e in f:
            sum += e
        return sum

    func momentum(f):
        return Vector2(f[1] - f[3] + f[5] - f[7] + f[8] - f[6], f[4] - f[2] + f[8] - f[5] + f[7] - f[6])

    func set_boundaries(boundaries):
        self.boundaries = boundaries


    func is_static_boundary(pos: Vector2, i):
        if pos.x < 0 or pos.x >= dims.x or pos.y < 0 or pos.y >= dims.y:
            return true
        if self.walls[pos.x][pos.y].is_blocked(i):
            return true
        return false


    func propagate_momentum(to, from_pos, i):
        if is_static_boundary(from_pos, i):
            return to.f[INVERSE[i]]
        else:
            var neighbour = nodes[from_pos.x][from_pos.y]
            return neighbour.f[i]

    func propagate_heat(to, from_pos, i):
        if is_static_boundary(from_pos, i):
            return to.t
        else:
            var neighbour = nodes[from_pos.x][from_pos.y]
            return neighbour.t

    func set_wall(pos, i, state):
        if pos.x < dims.x and pos.y < dims.y:
            self.walls[pos.x][pos.y].blocked_dirs[i] = state
            var next_pos = pos + VECS[i]
            if next_pos.x < dims.x and next_pos.y < dims.y:
                self.walls[next_pos.x][next_pos.y].blocked_dirs[INVERSE[i]] = state

    func step():
        for x in range(self.dims.x):
            for y in range(self.dims.y):
                var node = nodes[x][y]
                var next_node = next_nodes[x][y]
                var pos = Vector2(x, y)

                next_node.t = 0
                var ts = [0, 0, 0, 0, 0, 0, 0, 0, 0]
                var weighted_sum = 0
                # propagate
                for i in range(TOTAL_VECS):
                    var neighhour_pos = pos + VECS[INVERSE[i]]
                    next_node.f[i] = propagate_momentum(node, neighhour_pos, i)
                    weighted_sum += next_node.f[i] * WEIGHTS[i]
                    next_node.t += propagate_heat(node, neighhour_pos, i) * (next_node.f[i] * WEIGHTS[i])
                next_node.t /= weighted_sum


                # number density
                var n = sum(next_node.f)
                # momentum vector
                var mom = momentum(next_node.f)
                # velocity vector
                var u = mom / n
                var ndotu = u.dot(u)

                for i in range(TOTAL_VECS):
                    var uv = u.dot(VECS[i])
                    var f_eq = n*WEIGHTS[i]*(1+3*uv + (9/2)*(uv*uv) - (3/2)*ndotu)
                    next_node.f[i] -= (next_node.f[i] - f_eq) / RELAXATION_TIME

                # update boundaries
                if self.boundaries.has(pos):
                    var boundary = self.boundaries[pos]
                    boundary.update_node(next_node)

        # swap the node lists
        var tmp = self.nodes
        self.nodes = self.next_nodes
        self.next_nodes = tmp

var lattice = Lattice.new(Vector2(Config.MAP_WIDTH+1, Config.MAP_HEIGHT+1))
onready var playfield = get_node("..")


func _draw():
    for x in range(lattice.dims.x):
        for y in range(lattice.dims.y):
            var pos = Vector2(x * 32 + 16, y * 32 + 16)
            var node = lattice.nodes[x][y]
            var vel = node.get_vel()
            var to = pos + vel * 32 * 50
            draw_line(pos, to, Color.blue)

            var temp_alpha = 1 * (node.t / 20)

            draw_rect(Rect2(x * 32,  y* 32, 32, 32), Color(150, 0, 0, temp_alpha))

            # for i in range(TOTAL_VECS):
            #     if lattice.walls[x][y].is_blocked(i):
            #         draw_line(pos, pos + VECS[i] * 16, Color(0, 150, 0))


func tick():
    for machine in playfield.machines:
        for x in range(machine.size().x):
            for y in range(machine.size().y):
                var pos = Vector2(machine.pos.x + x, machine.pos.y + y)
                if x == 0:
                    lattice.set_wall(pos, WORLD_DIRECTIONS_I[Globals.Direction.WEST], true)
                if x == machine.size().x - 1:
                    lattice.set_wall(pos, WORLD_DIRECTIONS_I[Globals.Direction.EAST], true)
                if y == 0:
                    lattice.set_wall(pos, WORLD_DIRECTIONS_I[Globals.Direction.NORTH], true)
                if y == machine.size().y - 1:
                    lattice.set_wall(pos, WORLD_DIRECTIONS_I[Globals.Direction.SOUTH], true)



    lattice.step()

    for machine in playfield.machines:
        var nodes = []

        for x in range(machine.size().x):
            for y in range(machine.size().y):
                var node = lattice.nodes[machine.pos.x + x][machine.pos.y + y]
                nodes.append(node)

        var avg_node_temp = 0
        for node in nodes:
            avg_node_temp += node.t

        avg_node_temp /= len(nodes)

        var dt = avg_node_temp - machine.temperature
        var flow = (-1 * dt) * 0.1 # 0.1 second update time

        for node in nodes:
            node.t += flow / THERMAL_CAPACITY

        machine.temperature += machine.thermal_output * 0.1 / machine.thermal_capacity
        var machine_area = machine.size().x * machine.size().y
        machine.temperature -= flow * machine_area / machine.thermal_capacity

        for port_pos in machine.ports:
            var port = machine.ports[port_pos]
            if port.air_flow != null:
                var global_pos = machine.pos + Vector2(port_pos.x, port_pos.y)
                var direction = WORLD_DIRECTIONS_I[int(port_pos.z)]
                lattice.set_wall(global_pos, direction, false)

                var strength = port.air_flow
                if port.air_flow < 0:
                    direction = INVERSE[direction]
                    strength = -strength

                var node = lattice.get_flownode(global_pos)
                #var density = node.get_density()
                #node.set_eq_density(0.8)
                # node.f[direction] += port.air_flow
                # node.f[0] = (1 - port.air_flow) * WEIGHTS[0]

    update()

    print("temp:" + str(lattice.avg_temp()))

func _process(delta):
    pass

func _input(ev):
    if Input.is_key_pressed(KEY_K):
        pass
    elif Input.is_key_pressed(KEY_L):
        for y in range(5, 10):
            lattice.nodes[0][y].set_density(0.8)
            lattice.nodes[0][y].t = 0

            lattice.nodes[lattice.dims.x-1][y].set_density(1.2)
            lattice.nodes[lattice.dims.x-1][y].t = 0

    elif Input.is_key_pressed(KEY_J):
        for x in range(2):
            for y in range(2):
                lattice.nodes[12+x][2+y].t += 0.4





var timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
    timer.connect("timeout", self, "tick")
    # timer.start(0.1)
    add_child(timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
