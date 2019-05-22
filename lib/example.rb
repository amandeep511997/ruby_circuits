require_relative "ruby_ciruits"


clock = Clock.new
clock.start()

puts("clock is set\n")

o = Oscilloscope.new([clock.clock_connector, 'CLK'])
o.set_scale(0.015)  # Set scale by trial and error.
o.set_width(150)
o.start()
#o.unhold()

puts("oscilloscope is set\n")

20.times do 
	o.display()
	sleep 1
	puts clock.state
end
	
# Kill the clock and the oscilloscope threads after use
o.kill()
clock.kill()
