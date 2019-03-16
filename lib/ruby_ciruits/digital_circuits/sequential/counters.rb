=begin 
	contains all counters for digital circuits
=end


module CounterBase
	def set_properties(bits, clock_connector, data, preset, clear)
		@bits = bits
		@out = []
		@out_inverse = []
		@bits.times do 
			@out << Connector.new(data)
			@out_inverse << Connector.new(LogicGates::NOT.new(data).output())
		end

		@out_old = @out
		@out_old_inverse = @out_inverse
		@ff = [nil] * @bits
		@enable = Connector.new(1)
		@t = Connector.new(1)
		@clk = clock_connector
		@set_once = false
		@reset_once = false
		@bits_fixed = false
		@ripple_type = true
		@preset = preset
		@clear = clear
	end	

	def set_input(t, enable)
		if t.is_a?(Connector)
			@t = t
		else
			@t.state = t.to_i
		end

		if enable.is_a?(Connector)
			@enable = enable
		else
			@enable.state = enable.to_i
		end
	end

	def trigger(ffnumber=nil)
		@out_old = @out
		
		if ffnumber.nil?
			ffnumber = @bits - 1
		end

		# send negative edge to FF
		while true
			if @clk.state == 0
				#Falling edge will triger the FF
				if @ripple_type
					@ff[ffnumber].trigger()
				else
					@bits.times do |idx|
						@ff[idx].trigger()
					end
				end

				break
			end
		end

		# send positive edge to FF
		while true
			if @clk.state == 1
				if @ripple_type
					@ff[ffnumber].trigger()
				else
					@bits.times do |idx|
						@ff[idx].trigger()
					end
				end

				break
			end
		end

		if @clear.state == 1 and @preset.state == 0
			self.set_counter()
		elsif @clear.state == 0 and @preset.state == 1
			self.reset_counter()
		end
		
		return self.state()
	end

	def set_counter
		inset = @clear.state

		if @bits_fixed
			self.set_properties(@clk, 1, @preset, @clear)
		else
			self.set_properties(@bits, @clk, 1, @preset, @clear)
		end

		if not @set_once
			@clear.state = inset
		end

	end

	def reset_counter
		reset = @preset.state

		if @bits_fixed
			self.set_properties(@clk, 0, @preset, @clear)
		else
			self.set_properties(@bits, @clk, 0, @preset, @clear)
		end

		if not @reset_once
			@preset.state = reset
		end
	end

	def enable
		@enable.state = 1
	end

	def disable
		@enable.state = 0
	end

	def state
		output = []

		@bits.times do |idx|
			output << @out[idx].state 
		end

		return output
	end

end

module Counter
	class Binary
		include CounterBase

		def initialize(bits, clk, data=0, preset=Connector.new(1), clear=Connector.new(1))
			self.set_properties(bits, clk, data, preset, clear)

			@ff[@bits - 1] = FlipFlop::T.new(@t, @enable, @clk, @preset, @clear, @out[@bits - 1], @out_inverse[@bits - 1])

			# @bits number of TFF are appended in the FlipFlop(ff) array
			# output of previous stage becomes the input clock for the next flip flop
			(@bits - 2).downto(0) do |idx|
				@ff[idx] = FlipFlop::T.new(@t, @enable, @out[idx + 1], @preset, @clear, @out[idx], @out_inverse[idx])
			end
			
		end
	end	

	class NBitRipple
		include CounterBase

		def initialize(bits, clock_connector, data=0, preset=Connector.new(1), clear=Connector.new(1))
			self.set_properties(bits, clock_connector, data, preset, clear)

			@ff[@bits - 1] = FlipFlop::T.new(@t, @enable, @clk, @preset, @clear, @out[@bits - 1], @out_inverse[@bits - 1])

			(@bits - 1).times do |idx|
				@ff[idx] = FlipFlop::T.new(@t, @enable, @out[idx + 1], @preset, @clear, @out[idx], @out_inverse[idx])
			end
		end			
	end

	class NBitDown
		include CounterBase

		def initialize(bits, clock_connector, data, preset, clear)
			self.set_properties(bits, clock_connector, data, preset, clear)

			@ff[@bits - 1] = FlipFlop::T.new(@t, @enable, @clk, @preset, @clear, @out[@bits - 1], @out_inverse[@bits - 1])

			(@bits - 1).times do |idx|
				@ff[idx] = FlipFlop::T.new(@t, @enable, @out_inverse[idx + 1], @preset, @clear, @out[idx], @out_inverse[idx])
			end
		end
	end

	# 4 bit decade counter
	class Decade
		include CounterBase

		def initialize(clock_connector, data=0, preset=Connector.new(1), clear=Connector.new(1))
			self.set_properties(4, clock_connector, data, preset, clear)

			@ff = Array.new(4, nil)

			@ff[3] = FlipFlop::T.new(@t, @enable, @clk, @preset, @clear, @out[3], @out_inverse[3])

			2.downto(0) do |idx|
				@ff[idx] = FlipFlop::T.new(@t, @enable, @out[idx + 1], @preset, @clear, @out[idx], @out_inverse[idx])
			end

			@nand_gate = LogicGates::NAND.new(@out[0], @out[2])
			@nand_gate.set_output(@clear)

			@bits_fixed = true
			@reset_once = true
		end
	end

	# 4 bit octal counter
	class Octal
		include CounterBase
		def initialize(clock_connector, data=0, preset=Connector.new(1), clear=Connector.new(1))
			self.set_properties(4, clock_connector, data, preset, clear)

			@ff = Array.new(4, nil)

			@ff[3] = FlipFlop::T.new(@t, @enable, @clk, @preset, @clear, @out[3], @out_inverse[3])

			2.downto(0) do |idx|
				@ff[idx] = FlipFlop::T.new(@t, @enable, @out[idx + 1], @preset, @clear, @out[idx], @out_inverse[idx])
			end

			@not_gate = LogicGates::NOT.new(@out[0])
			@not_gate.set_output(@clear)

			@bits_fixed = true
			@reset_once = true
		end
	end

	# n bit ring counter
	class Ring
		include CounterBase

		def initialize(bits, clock_connector, preset=Connector.new(1), clear=Connector.new(1))
			self.set_properties(bits, clock_connector, nil, preset, clear)

			counter_bits = Array.new(bits, 0)
			counter_bits[0] = 1
			
			@shift_register = Register::Shift.new(counter_bits, clock_connector, circular=1)
			@out = []
		end

		def trigger
			@out = @shift_register.output()
			return @out
		end

		def state
			return @out
		end

		def reset
			self.initialize(@bits, clock_connector, clear=Connector.new(0))
		end

		def set
			self.initialize(@bits, clock_connector, preset=Connector.new(0))
		end
	end

	# n bit johnson counter
	class Johnson
		include CounterBase

		def initialize(bits, clock_connector, preset=Connector.new(1), clear=Connector.new(1))
			self.set_properties(bits, clock_connector, nil, preset, clear)

			counter_bits = Array.new(bits, 0)
			counter_bits[0] = 1

			@shift_register = Register::Shift.new(counter_bits, clock_connector, circular=1)
			@out = []
			@tail = 1
		end

		def trigger
			@out = @shift_register.output()
			@out[0] = @tail
			@tail = LogicGates::NOT.new(@out[@bits - 1]).output()
			return @out
		end

		def state
			return @out
		end

		def reset
			self.initialize(@bits, clock_connector, clear=Connector.new(0))
		end

		def set
			self.initialize(@bits, clock_connector, preset=Connector.new(0))
		end
	end
end