require_relative "ruby_ciruits"

s = Connector.new(1)
r = Connector.new(0)

p = Connector.new(0)
q = Connector.new(1)

clock = Clock.new
clk_conn = clock.clock_connector
enable = Connector.new(1)
srff = FlipFlop::SRLatch.new(s, r, enable, clk_conn)
to_outputs = {"A" => p, "B" => q}
srff.set_outputs(to_outputs)

print "SET STATE - S = 1 and R = 0"
s.state = 1
r.state = 0

clock.start

while true
	sleep 3
	if clk_conn.state == 0
		srff.trigger()
		break
	end
end

print srff.state

while true
	sleep 3
	if clk_conn.state == 1
		srff.trigger()
		break
	end
end

print srff.state



