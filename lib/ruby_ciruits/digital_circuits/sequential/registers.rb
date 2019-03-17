require_relative "../circuit_helpers/connectors/connector"
require_relative "flip_flops"


=begin 
	contains all registers for digital circuits
=end

module RegisterBase
	def set_properties(inputs, clock, clear)
		if not clock.is_a?(Clock)
			raise "clock must be a Clock instance"
		end

		@inputs = inputs
		@clock = clock 
		@clear = clear 
		@result = nil
		@output_type = {}
		@output_connector = {}
		self.update_connections(@inputs)

	end

	def update_connections(inputs)
		inputs.each do |inp|
			if inp.is_a?(Connector)
				inp.tap("input")
			end
		end
	end

	def set_inputs(inputs)
		if inputs.length < @inputs.length
			raise "invalid argument length"
		else
			@inputs = inputs
			self.update_connections(@inputs)
		end
	end

	def set_input(index, value)
		if index >= @inputs.length
			@inputs << value
		else
			@inputs[index] = value
		end

		if value.is_a?(Connector)
			value.tap("input")
		end
	end

	def set_clock(clk)
		if not clk.is_a?(Clock)
			raise "invalid clk object"
		end
		@clock = clk
	end

	def set_clear(clr)
		@clear = clr
	end

	def get_input_states
		input_states = []
		@inputs.each do |inp|
			if inp.is_a?(Connector)
				input_states << inp.state
			else
				input_states << inp
			end
		end
		return input_states
	end

	def update_result(value) 
		@result = value
		@output_type.each_with_index do |out, idx|
			if out == 1
				@output_connector[idx].state = @result[idx]
				@output_connector[idx].trigger()
			end
		end
	end

	def set_output(index, value)
		if not value.is_a?(Connector)
			raise "expecting a Connector class object"
		end
		@output_type[index] = 1
		@output_connector[index] = value
		value.tap("output")
		self.update_result(@result)
	end

	def output
		self.trigger()
		return @result;
	end
end

module Register
	class FourBit
		include RegisterBase
		
		def initialize(a0, a1, a2, a3, clock, clear)
			self.set_properties([a0, a1, a2, a3], clock, clear)
		end

		def trigger
			out = []
			4.times do |i|
				d_flip_flop = FlipFlop::D.new(@inputs[i], Connector.new(1), @clock.A, @clear)

				while true
					if @clock.A.state == 1
						d_flip_flop.trigger()
						break
					end
				end

				while true
					if @clock.A.state == 0
						d_flip_flop.trigger()
						break
					end
				end

				out << (d_flip_flop.state()[0])
			end
			self.update_result(out)
		end
	end

	class Shift
		include RegisterBase
		
		def initialize(inputs, clock, clear=Connector.new(1), circular=0)
			@circular = circular
			self.set_properties(inputs, clock, clear)
		end

		def trigger
			last_bit = @inputs[0]
			@inputs.each_with_index do |inp, idx|
				d_flip_flop = FlipFlop::D.new(inp, Connector.new(1), @clock.A, @clear)

				if @circular == 1 and idx == 0
					@inputs[idx] = @inputs[@inputs.length - 1]
				else 
					@inputs[idx] = last_bit
				end

				while true
					if @clock.A.state == 1
						d_flip_flop.trigger()
						break
					end
				end

				while true
					if @clock.A.state == 0
						d_flip_flop.trigger()
						break
					end
				end

				last_bit = d_flip_flop.state()[0]
			end
			out = @inputs
			self.update_result(out)
		end
	end
end