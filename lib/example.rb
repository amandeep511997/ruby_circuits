require_relative "ruby_ciruits"

g = LogicGates::AND.new(0, 1)
g = LogicGates::AND.new(1, 1, 1, 1)
print g.output()
g.get_input_states()

#Gates with connector
c = Connector.new
g = LogicGates::AND.new(1, 1)
g.set_output(c)
g1 = LogicGates::AND.new(c, 1)
c.is_output?(g)
c.is_output?(g1)
print c.is_input?(g1)
