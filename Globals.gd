extends Node

var time = 0.0

enum Direction {
    NORTH,
    SOUTH,
    EAST,
    WEST
}

enum Wire {
    ELECTRIC,
    THREE_PHASE,
    NETWORK,
}

const WIRE_KINDS = [Wire.ELECTRIC, Wire.THREE_PHASE, Wire.NETWORK]

enum TechFlavour {
    BITCOIN,
    ETHEREUM,
    POWER,
    NETWORK,
}

const TECH_FLAVOURS = [TechFlavour.BITCOIN, TechFlavour.ETHEREUM, TechFlavour.POWER, TechFlavour.NETWORK]

const MACHINES = {
    "Bitcoin Miner": preload("res://Machines/BitcoinMiner.gd"),
    "Bitcoin Miner 2": preload("res://Machines/BitcoinMiner2.gd"),
    "Bitcoin Miner 3": preload("res://Machines/BitcoinMiner3.gd"),

    "Ethereum Miner": preload("res://Machines/EthereumMiner.gd"),
    "Ethereum Miner 2": preload("res://Machines/EthereumMiner2.gd"),
    "Ethereum Miner 3": preload("res://Machines/EthereumMiner3.gd"),

    "Router": preload("res://Machines/Router.gd"),
    "Router 2": preload("res://Machines/Router2.gd"),
    "Router 3": preload("res://Machines/Router3.gd"),

    "Transformer": preload("res://Machines/Transformer.gd"),
    "Transformer 2": preload("res://Machines/Transformer2.gd"),
    "Transformer 3": preload("res://Machines/Transformer3.gd"),
}

var TECH_SPECS = {
    "Bitcoin Miner": TechSpec.new(0, TechFlavour.BITCOIN, 0),
    "Bitcoin Miner 2": TechSpec.new(1, TechFlavour.BITCOIN, 100),
    "Bitcoin Miner 3": TechSpec.new(2, TechFlavour.BITCOIN, 1000),

    "Ethereum Miner": TechSpec.new(0, TechFlavour.ETHEREUM, 0),
    "Ethereum Miner 2": TechSpec.new(1, TechFlavour.ETHEREUM, 100),
    "Ethereum Miner 3": TechSpec.new(2, TechFlavour.ETHEREUM, 1000),

    "Router": TechSpec.new(0, TechFlavour.NETWORK, 0),
    "Router 2": TechSpec.new(1, TechFlavour.NETWORK, 100),
    "Router 3": TechSpec.new(2, TechFlavour.NETWORK, 1000),

    "Transformer": TechSpec.new(0, TechFlavour.POWER, 0),
    "Transformer 2": TechSpec.new(1, TechFlavour.POWER, 100),
    "Transformer 3": TechSpec.new(2, TechFlavour.POWER, 1000),
}

const WIRES = {
    "Electric Cable": Wire.ELECTRIC,
    "Network Cable": Wire.NETWORK,
    "Three phase": Wire.THREE_PHASE,
}

enum TutorialEvents {
    PLAYFIELD_READY,
    UI_READY,
    NET_FANOUT_TOO_HIGH,
    NET_OVERLOADED,
    TRANSFORMER_PLACED,
    BITCOIN_MINER_PLACED,
    ETHEREUM_MINER_PLACED
    EARNING_MONEY,
    TRANFORMER_POWERED,
    EARNING_THOUGHTS,
}

class Port:
    var machine = null
    var heat = 0.0

    # -1 inwards + 1 outwards, null not a fan
    var air_flow = null

    var supplies = {
        Wire.ELECTRIC: 0.0,
        Wire.NETWORK: 0.0,
        Wire.THREE_PHASE: 0.0,
    }

    var fanout = {
        Wire.ELECTRIC: 0,
        Wire.NETWORK: 0,
        Wire.THREE_PHASE: 0,
    }

    func _init(m, electric, network, three_phase, e_fanout, n_fanout, tp_fanout):
        machine = m
        supplies[Wire.ELECTRIC] = electric
        supplies[Wire.NETWORK] = network
        supplies[Wire.THREE_PHASE] = three_phase
        fanout[Wire.ELECTRIC] = e_fanout
        fanout[Wire.NETWORK] = n_fanout
        fanout[Wire.THREE_PHASE] = tp_fanout

    func duplicate():
        var p = Port.new(machine,
            supplies[Wire.ELECTRIC], supplies[Wire.NETWORK], supplies[Wire.THREE_PHASE],
            fanout[Wire.ELECTRIC], fanout[Wire.NETWORK], fanout[Wire.THREE_PHASE]
        )
        p.heat = heat
        return p

    func to_string():
        return "Port{Heat: %d, Electric: %d / %d, Network: %d / %d, 3Phase: %d / %d}" % [
            heat,
            supplies[Wire.ELECTRIC],
            fanout[Wire.ELECTRIC],
            supplies[Wire.NETWORK],
            fanout[Wire.NETWORK],
            supplies[Wire.THREE_PHASE],
            fanout[Wire.THREE_PHASE],
        ]


class TechSpec:
    var level
    var flavour
    var thoughts

    func _init(level, flavour, thoughts):
        self.level = level
        self.flavour = flavour
        self.thoughts = thoughts


class TechState:
    var progress
    var unlocked

    func _init(progress, unlocked):
        self.progress = progress
        self.unlocked = unlocked

    func is_complete():
        return unlocked and progress >= 1.0

    func is_buildable():
        return unlocked and progress <= 0.0

    func is_building():
        return unlocked and progress > 0.0 and progress < 1.0


# Pause in the debugger, or crash!
func throw(msg):
    print(msg)
    var x = 0
    var y = 1 / x
