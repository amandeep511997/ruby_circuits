require_relative "../circuit_helpers/connectors/connector"
require_relative "../logic_gates/gates"

module Combinational
	class HalfAdder

		attr_reader :sum, :carry

		def initialize(*inputs)
			if inputs.length != 2
				raise "half adder must have only 2 arguments"
			end
			@inputs = inputs
			@sum = LogicGates::XOR.new(@inputs[0], @inputs[1])
			@carry = LogicGates::AND.new(@inputs[0], @inputs[1])
		end

		def set_input(index, value)
			if index > 1 or index < 0
				raise "index value out of bounds"
			end

			@inputs[index] = value

			@sum.set_input(index, value)
			@carry.set_input(index, value)	
		end

		def set_inputs(*inputs)
			if inputs.length != 2
				raise "half adder must have only 2 arguments"
			end
			@inputs = inputs
			@sum.set_inputs(@inputs[0], @inputs[1])
			@carry.set_inputs(@inputs[0], @inputs[1])
		end

		def set_output(index, value)
			if index > 1 or index < 0
				raise "index value out of bounds"
			end
			
			unless value.is_a?(Connector)
				raise "expecting a Connector class object"
			end
			
			if index == 0
				@carry.set_output(value)
			end

			if index == 1
				@sum.set_output(value)
			end
		end

		def output
			return @carry.output(), @sum.output()
		end
	end

	class FullAdder

		def initialize(*inputs)
			if inputs.length != 3
				raise "full adder must have only 3 arguments"
			end
			
			@inputs = inputs
			
			@connector1 = Connector.new
			@first_half_adder = HalfAdder.new(@inputs[0], @inputs[1])
			@first_half_adder.set_output(1, @connector1)

			@second_half_adder = HalfAdder.new(@connector1, @inputs[2])
			@connector2 = Connector.new
			@connector3 = Connector.new
			@first_half_adder.set_output(0, @connector2)
			@second_half_adder.set_output(0, @connector3)
			
			@or_gate = LogicGates::OR.new(@connector2, @connector3) 
		end

		def set_input(index, value)
			if index > 2 or index < 0
				raise "index value out of bounds"
			end

			@inputs[index] = value

			if index == 2
				@second_half_adder.set_input(1, value)
			else
				@first_half_adder.set_input(index, value)
			end
		end

		def set_inputs(*inputs)
			if inputs.length != 3
				raise "half adder must have only 3 arguments"
			end

			@inputs = inputs
			@first_half_adder.set_inputs(@inputs[0], @inputs[1])
			@second_half_adder.set_input(1, @inputs[2])
		end

		def set_output(index, value)
			if index > 1 or index < 0
				raise "index value out of bounds"
			end
			
			unless value.is_a?(Connector)
				raise "expecting a Connector class object"
			end
			
			if index == 0
				@or_gate.set_output(value)
			end

			if index == 1
				@second_half_adder.set_output(1, value)
			end
		end

		def output
			return @or_gate.output(), @second_half_adder.output()[1]
		end
	end

	class HalfSubtractor

		attr_reader :difference, :borrow

		def initialize(*inputs)
			if inputs.length != 2
				raise "half subtractor must have only 2 arguments"
			end
			
			@inputs = inputs
			
			@difference = LogicGates::XOR.new(@inputs[0], @inputs[1])
			@not_gate = LogicGates::NOT.new(@inputs[0])
			@connector = Connector.new
			@not_gate.set_output(@connector)
			@borrow = LogicGates::AND.new(@connector, @inputs[1])
		end

		def set_input(index, value)
			if index > 1 or index < 0
				raise "index value out of bounds"
			end

			@inputs[index] = value

			@difference.set_input(index, value)
			if index == 0
				@not_gate.set_input(value)
			elsif index == 1
				@borrow.set_input(index, value)	
			end
		end

		def set_inputs(*inputs)
			if inputs.length != 2
				raise "half adder must have only 2 arguments"
			end
			@inputs = inputs
			
			@difference.set_inputs(@inputs[0], @inputs[1])
			@not_gate.set_input(@inputs[0])
			@borrow.set_inputs(@connector, @inputs[1])
		end

		def set_output(index, value)
			if index > 1 or index < 0
				raise "index value out of bounds"
			end
			
			unless value.is_a?(Connector)
				raise "expecting a Connector class object"
			end
			
			if index == 0
				@borrow.set_output(value)
			end

			if index == 1
				@difference.set_output(value)
			end
		end

		def output
			return @borrow.output(), @difference.output()
		end
	end


	class FullSubtractor

		def initialize(*inputs)
			if inputs.length != 3
				raise "full adder must have only 3 arguments"
			end
			
			@inputs = inputs
			
			@connector1 = Connector.new
			@first_half_subtractor = HalfSubtractor.new(@inputs[0], @inputs[1])
			@first_half_subtractor.set_output(1, @connector1)

			@second_half_subtractor = HalfSubtractor.new(@connector1, @inputs[2])
			@connector2 = Connector.new
			@connector3 = Connector.new
			# check here position of subtractor for connection 3
			@first_half_subtractor.set_output(0, @connector1)
			@second_half_subtractor.set_output(0, @connector2)
			
			@or_gate = LogicGates::OR.new(@connector1, @connector2) 
		end

		def set_input(index, value)
			if index > 2 or index < 0
				raise "index value out of bounds"
			end

			@inputs[index] = value

			if index == 2
				@second_half_subtractor.set_input(1, value)
			else
				@first_half_subtractor.set_input(index, value)
			end
		end

		def set_inputs(*inputs)
			if inputs.length != 3
				raise "half adder must have only 3 arguments"
			end

			@inputs = inputs
			@first_half_subtractor.set_inputs(@inputs[0], @inputs[1])
			@second_half_subtractor.set_input(1, @inputs[2])
		end

		def set_output(index, value)
			if index > 1 or index < 0
				raise "index value out of bounds"
			end
			
			unless value.is_a?(Connector)
				raise "expecting a Connector class object"
			end
			
			if index == 0
				@or_gate.set_output(value)
			end
		
			if index == 1
				@second_half_subtractor.set_output(1, value)
			end
		end

		def output
			return @or_gate.output(), @second_half_subtractor.output()[1]
		end
	end

	class MUX
		# Input nth index has nth input value, input should be power of 2
		# ouput is 1 or 0 based on one of the input lines
		# select lines will be in binary form
		include Gates
		attr_reader :mux_select_lines

		def initialize(*inputs)
			if inputs.length < 2 or (inputs.length & (inputs.length - 1)) != 0
				raise "number of inputs must be a power of 2"
			end
			
			@mux_select_lines = Array.new

			self.set_properties(inputs)
		end

		def select_lines(*args)
			if (2**(args.length)) != @inputs.length
				raise "number of select lines must be consistent with number of inputs"
			end

			@mux_select_lines = args
			self.update_select_connections()
			self.trigger()
		end

		def select_line(index, value)
			if index >= @mux_select_lines.length
				@mux_select_lines << value
			else
				@mux_select_lines[index] = value
			end

			if value.is_a?(Connector)
				value.tap(self, "input")
				self.trigger()
			end
		end

		def set_input(index, value)
			if index >= @inputs.length
				@inputs << value
			else 
				@inputs[index] = value
			end

			if value.is_a?(Connector)
				value.tap(self, "input")
				self.trigger()
			end
		end

		def trigger()
			if @mux_select_lines.length == 0
				return
			end
			if @inputs.length < 2 or (@inputs.length & (@inputs.length - 1)) != 0
				raise "number of inputs must be a power of 2"
			end

			select_input = ""
			@mux_select_lines.each do |sel|
				if sel.is_a?(Connector)
					select_input = select_input + sel.state.to_s
				else
					select_input = select_input + sel.to_s
				end
			end

			idx = select_input.to_i(2)
			begin 
				if @inputs[idx].is_a?(Connector)
					self.update_result(@inputs[idx].state)
				else
					self.update_result(@inputs[idx])
				end
			rescue IndexError
				raise "select lines are inconsistent with the input lines"
			end

			if @output_type == 1
				@output_connector.trigger()
			end
		end

		def update_select_connections()
			@mux_select_lines.each do |sel|
				if sel.is_a?(Connector)
					sel.tap(self, "input")
				end
			end
		end

		def to_s()
			"MUX"
		end

	end

	class DEMUX
		include Gates

		attr_reader :demux_select_lines

		def initialize(input)			
			@demux_select_lines = Array.new

			@inputs = [input]
			@output_type = Array.new
			@output_connector = Array.new

			self.set_properties(input)
		end

		def select_lines(*args)
			if args.length == 0
				raise "number od select lines must be greater than zero"
			end
			@demux_select_lines = args
			@output_type.concat([0] * (2**(@demux_select_lines.length)))
			@output_connector.concat([nil] * (2**(@demux_select_lines.length)))

			self.update_connections()
			self.trigger()
		end

		def select_line(index, value)
			if index >= @demux_select_lines.length
				@demux_select_lines << value
				output_increase = (2**(@demux_select_lines.length)) - @output_type.length
				@output_type.concat([0] * output_increase)
				@output_connector.concat([nil] * output_increase)				
			else
				@demux_select_lines[index] = value
			end

			if value.is_a?(Connector)
				value.tap(self, "input")
				self.trigger()
			end
		end

		def set_input(index, value)
			if index != 0
				raise "only single input allowed"
			end

			@inputs[index] = value

			if value.is_a?(Connector)
				value.tap(self, "input")
				self.trigger()
			end
		end

		def trigger()
			if @demux_select_lines.length == 0
				return
			end
			output = Array.new(2**(@demux_select_lines.length), 0)
			select_output = ""

			@demux_select_lines.each do |sel|
				if sel.is_a?(Connector)
					select_output = select_output + sel.state.to_s
				else
					select_output = select_output + sel.to_s
				end
			end
			
			idx = select_output.to_i(2)

			begin 
				if @inputs[0].is_a?(Connector)
					output[idx] = @inputs[0].state
					self.update_result(output)
				else
					output[idx] = @inputs[0]
					self.update_result(output)
				end
			rescue IndexError
				raise "select lines are inconsistent with the input lines"
			end
			
		end

		def set_inputs(input)
			@inputs = [input]
			self.update_connections()
			self.trigger()
		end

		def set_output(index, value)
			if index < 0 or index >= @output_type.length
				raise "index out of bounds"
			end

			if not value.is_a?(Connector)
				raise "expecting a Connector class object"
			end

			value.tap(self, "output")
			@output_type[index] = 1
			@output_connector[index] = value
			self.trigger()
		end

		def update_result(value)
			@result = value
			@output_type.each_with_index do |out_type, idx|
				if out_type == 1
					@output_connector[idx].state = value[idx]
				end
			end
		end

		def update_select_connections
			@demux_select_lines.each do |sel|
				if sel.is_a?(Connector)
					sel.tap(self, "input")
				end
			end
		end

		def to_s
			"DEMUX"
		end
	end

	class Encoder
		include Gates
		include Math

		def initialize(*inputs)			
			if inputs.length < 1 or (inputs.length & (inputs.length - 1) != 0)
				raise "number of inputs must be a power of 2"
			end

			connector_inputs = inputs.select { |inp| inp.is_a?(Connector) and inp.state == 1 }
			if inputs.count(1) != 1 and connector_inputs.length != 1
				raise "invald inputs"
			end
			
			output_size = Math.log2(inputs.length).to_i
			@output_type = Array.new(output_size, 0)
			@output_connector = Array.new(output_size, nil)

			self.set_properties(inputs)
		end

		def trigger()
			if @inputs.length < 1 or ((@inputs.length & (@inputs.length - 1)) != 0)
				raise "number of inputs must be a power of 2"
			end

			temp = @inputs
			temp.each_with_index do |inp, idx|
				if inp.is_a?(Connector)
					temp[idx] = inp.state;
				end
			end
			select_string = temp.find_index(1).to_s(2).chars.map(&:to_i)
			increase = Math.log2(@inputs.length).to_i - select_string.length
			select_string = Array.new(increase, 0).concat(select_string)
			
			self.update_result(select_string)
		end

		def set_inputs(*inputs)
			if inputs.length < 1 or (inputs.length & (inputs.length - 1)) != 0
				raise "number of inputs must be a power of 2"
			end
			connector_inputs = inputs.select { |inp| inp.is_a?(Connector) and inp.state == 1 }
			if inputs.count(1) != 1 and connector_inputs.length != 1
				raise "invald inputs"
			end
			@inputs = inputs
			
			output_increase = Math.log2(@inputs.length).to_i - @output_type.length
			@output_type.concat([0] * output_increase)
			@output_connector.concat([nil] * output_increase)				
			
			self.update_connections()
			self.trigger();
		end

		def set_input(index, value)
			temp = @inputs
			if index >= @inputs.length
				temp << value
				connector_inputs = inputs.select { |inp| inp.is_a?(Connector) and inp.state == 1 }
				if inputs.count(1) != 1 and connector_inputs.length != 1
					raise "invald inputs"
				end
				
				@inputs << value

				output_increase = Math.log2(@inputs.length).to_i - @output_type.length
				@output_type.concat([0] * output_increase)
				@output_connector.concat([nil] * output_increase)					
			else 
				temp[index] = value
				connector_inputs = inputs.select { |inp| inp.is_a?(Connector) and inp.state == 1 }
				if inputs.count(1) != 1 and connector_inputs.length != 1
					raise "invald inputs"
				end
				@inputs[index] = value
			end

			if value.is_a?(Connector)
				value.tap(self, 'input')
				self.trigger()
			end
		end

		def set_output(index, value)
			if not value.is_a?(Connector)
				raise "expecting a Connector class object"
			end
			value.tap(self, 'output')
			@output_type[index] = 1
			@output_connector[index] = value
			self.trigger()
		end

		def update_result(value)
			@result = value
			value.each_with_index do |val, idx|
				if @output_type[idx] == 1
					@output_connector[idx].state = val
				end
			end
		end

		def to_s
			"Encoder"
		end
	end

	class Decoder
		include Gates

		def initialize(*inputs)			
			if inputs.length == 0
				raise "inputs cannot be 0"
			end

			output_size = (2**inputs.length).to_i
			@output_type = Array.new(output_size, 0)
			@output_connector = Array.new(output_size, 0)

			self.set_properties(inputs)
		end

		def trigger()
			output = Array.new(2**@inputs.length, 0)
			select_string = ""
			@inputs.each do |inp|
				if inp.is_a?(Connector)
					select_string = select_string + inp.state.to_s
				else 
					select_string = select_string + inp.to_s
				end
			end
			idx = select_string.to_i(2)
			output[idx] = 1
			self.update_result(output)
		end

		def set_inputs(*inputs)
			if inputs.length == 0
				raise "input length must be greater than zero"
			end
			@inputs = inputs
			output_increase = (2**@inputs.length) - @output_type.length
			@output_type.concat([0] * output_increase)
			@output_connector.concat([nil] * output_increase)
			self.update_connections()
			self.trigger()
		end

		def set_input(index, value)
			if index >= @inputs.length
				@inputs << value
				output_increase = (2**@inputs.length) - @output_type.length
				@output_type.concat([0] * output_increase)
				@output_connector.concat([nil] * output_increase)
			else 
				@inputs[index] = value
			end

			if value.is_a?(Connector)
				value.tap(self, "input")
				self.trigger()
			end
		end

		def set_output(index, value)
			if not is_a?(Connector)
				raise "expecting a connector class object"
			end
			value.tap(self, "output")
			@output_type[index] = 1
			@output_connector[index] = value
			self.trigger()
		end

		def update_result(value)
			@result = value
			@output_type.each_with_index do |out, idx|
				if out == 1
					output_connector[idx].state = value[idx]
				end
			end
		end

		def to_s
			"Decoder"
		end
	end
end