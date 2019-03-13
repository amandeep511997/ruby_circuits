require_relative 'gates'

=begin
	AND logic gate 
	a = AND([0, 1])
	a.output() => 0

	a.set_input([1, 1, 1, 1])
	a.output() => 1

	conn = Connector()
	a.set_output(conn)
	a1 = AND(conn, 1)
	a1.output() => 1
=end 

module LogicGates

	class AND
		include Gates

		def initialize(*args)
			# takes inputs and returns 	
			self.set_properties(args)
		end

		def trigger()
			if self.compare_history()
				@history_active = 1
				self.update_result(true)
				# update the input after a computation
				self.update_history() 
				value = true
				@inputs.each do |inp|
					if inp.is_a?(Connector)
						value = value & inp.state
					elsif inp.is_a?(AND)
						value = value & inp.output()
					else
						value = value & inp
					end
				end
				self.update_result(value)
				if @output_type == 1
					@output_connector.trigger()
				end
			end
		end

		def to_s
			'AND'
		end

	end

	class OR
		include Gates
		
		def initialize(*args)
			# takes inputs and returns 	
			self.set_properties(args)
		end

		def trigger()
			if self.compare_history()
				@history_active = 1
				self.update_result(false)
				# update the input after a computation
				self.update_history() 
				value = false
				@inputs.each do |inp|
					if inp.is_a?(Connector)
						value = value | inp.state
					elsif inp.is_a?(AND)
						value = value | inp.output()
					else
						value = value | inp
					end
				end
				self.update_result(value)
				if @output_type == 1
					@output_connector.trigger()
				end
			end
		end

		def to_s
			'OR'
		end

	end

	class NOT
		include Gates
		
		def initialize(*args)
			# takes inputs and returns 	
			if args.length != 1
				raise "only one input expected given #{args.length}"
			end
			self.set_properties(args)
		end

		def set_inputs(*args)
			# this sets multiple inputs of the gates at a time 
			# we can also use set_input() multiple times with different index
			# to add multiple inputs to the gate.

			# filter and clean input args
			if args.length != 1
				raise ArgumentError, "only one input expected given #{args.length}"
			else 
				@history_active = 1 # use history before adding the input
				@inputs = args
				self.update_connections()
			end
			self.trigger() # any change in input triggers change in output
		end

		def set_input(value)
			self.set_inputs(value)
		end

		def trigger()
			if self.compare_history()
				@history_active = 1
				self.update_history() 
				inp = @inputs[0]
				if inp.is_a?(Connector)
					value = inp.state
				elsif inp.is_a?(AND)
					value = inp.output()
				else
					value = inp
				end
				value = (not value)
				self.update_result(value)
				if @output_type == 1
					@output_connector.trigger()
				end
			end
		end

		def to_s
			'NOT'
		end

	end

	class XOR
		include Gates
		
		def initialize(*args)
			# takes inputs and returns 	
			self.set_properties(args)
		end

		def trigger()
			if self.compare_history()
				@history_active = 1
				self.update_result(false)
				# update the input after a computation
				self.update_history() 
				value = false
				@inputs.each do |inp|
					if inp.is_a?(Connector)
						value = value ^ inp.state
					elsif inp.is_a?(AND)
						value = value ^ inp.output()
					else
						value = value ^ inp
					end
				end
				self.update_result(value)
				if @output_type == 1
					@output_connector.trigger()
				end
			end
		end

		def to_s
			'XOR'
		end

	end

	class NAND
		include Gates
		
		def initialize(*args)
			# takes inputs and returns 	
			self.set_properties(args)
		end

		def trigger()
			if self.compare_history()
				@history_active = 1
				self.update_result(false)
				# update the input after a computation
				self.update_history() 
				value = true
				@inputs.each do |inp|
					if inp.is_a?(Connector)
						value = value & inp.state
					elsif inp.is_a?(AND)
						value = value & inp.output()
					else
						value = value & inp
					end
				end
				value = (not value)
				self.update_result(value)
				if @output_type == 1
					@output_connector.trigger()
				end
			end
		end

		def to_s
			'XOR'
		end

	end

	class NOR
		include Gates
		
		def initialize(*args)
			# takes inputs and returns 	
			self.set_properties(args)
		end

		def trigger()
			if self.compare_history()
				@history_active = 1
				self.update_result(true)
				# update the input after a computation
				self.update_history() 
				value = false
				@inputs.each do |inp|
					if inp.is_a?(Connector)
						value = value | inp.state
					elsif inp.is_a?(AND)
						value = value | inp.output()
					else
						value = value | inp
					end
				end
				value = (not value)
				self.update_result(value)
				if @output_type == 1
					@output_connector.trigger()
				end
			end
		end

		def to_s
			'XOR'
		end

	end

	class XNOR
		include Gates
		
		def initialize(*args)
			# takes inputs and returns 	
			self.set_properties(args)
		end

		def trigger()
			if self.compare_history()
				@history_active = 1
				self.update_result(true)
				# update the input after a computation
				self.update_history() 
				value = true
				@inputs.each do |inp|
					if inp.is_a?(Connector)
						value = value ^ inp.state
					elsif inp.is_a?(AND)
						value = value ^ inp.output()
					else
						value = value ^ inp
					end
				end
				value = (not value)
				self.update_result(value)
				if @output_type == 1
					@output_connector.trigger()
				end
			end
		end

		def to_s
			'XOR'
		end

	end

end