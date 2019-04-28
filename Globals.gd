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

const MACHINES = {
    "Bitcoin Miner": preload("res://Machines/BitcoinMiner.gd"),
    "Ethereum Miner": preload("res://Machines/EthereumMiner.gd"),
    "Basic Router": preload("res://Machines/BasicRouter.gd"),
    "Transformer": preload("res://Machines/Transformer.gd"),
}

var TECH_SPECS = {
    "Bitcoin Miner": TechSpec.new(0, TechFlavour.BITCOIN, 0),
    "Ethereum Miner": TechSpec.new(0, TechFlavour.ETHEREUM, 0),
    "Basic Router": TechSpec.new(0, TechFlavour.POWER, 0),
    "Transformer": TechSpec.new(0, TechFlavour.NETWORK, 0),
}

const WIRES = {
    "Electric Cable": Wire.ELECTRIC,
    "Network Cable": Wire.NETWORK,
    "Three phase": Wire.THREE_PHASE,
}

enum TutorialEvents {
    PLAYFIELD_READY,
    UI_READY,
}

class Port:
    var machine = null
    var heat = 0.0
    var electric_fanout = 0
    var network_fanout = 0
    var three_phase_fanout = 0

    var supplies = {
        Wire.ELECTRIC: 0.0,
        Wire.NETWORK: 0.0,
        Wire.THREE_PHASE: 0.0,
    }

    func _init(m, electric, network, three_phase):
        machine = m
        supplies[Wire.ELECTRIC] = electric
        supplies[Wire.NETWORK] = network
        supplies[Wire.THREE_PHASE] = three_phase

    func to_string():
        return "Port{Heat: %d, Electric: %d / %d, Network: %d / %d, 3Phase: %d / %d}" % [
            heat,
            supplies[Wire.ELECTRIC],
            electric_fanout,
            supplies[Wire.NETWORK],
            network_fanout,
            supplies[Wire.THREE_PHASE],
            three_phase_fanout,
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


# Pause in the debugger, or crash!
func throw(msg):
    print(msg)
    var x = 0
    var y = 1 / x
