require_relative "../circuit_helpers/connectors/connector"
=begin
	Base class for all logic gates
=end 

=begin
	To be done
	----------
	1. using this method we can only get outputs if number of inputs 
	are more than 2 in some gates 
	2. what is the default output in gates
	3. meaning of history
	4. to understand history and connectors in set_input method look at set_input method in half subtractor
=end

module Gates
	def set_properties(inputs)
		# clean connections before updating new connections
		@history_active = 0	# ignore history for the first computation
		@output_type = 0 # if 1 then it goes to the connector class
		@result = nil # To store the result
		@output_connector = nil # valid only if output_type is 1
		## Make a check of input parameters raise exception if invalid
		@inputs = inputs # set the inputs
		@history_inputs = [] # save a copy of inputs
		# Any change in the input will trigger a change in the output
		self.update_connections()
		self.update_history()
		self.trigger()
	end

	def update_connections
		@inputs.each do |inp|
			# Connector as the class or one of the ancestral class
			if inp.is_a?(Connector) 
				inp.tap("input")
			end
		end
	end

	def set_inputs(*args)
		# this sets multiple inputs of the gates at a time 
		# we can also use set_input() multiple times with different index
		# to add multiple inputs to the gate.

		# filter and clean input args
		if args.length < 2
			raise ArgumentError, "gate with the given number of inputs not possible"
		else 
			@history_active = 1 # use history before adding the input
			@inputs = args
			self.update_connections()
		end
		self.trigger() # any change in input triggers change in output
	end

	def set_input(index, value)

		# Used to add input to the gate 
		# it requires an index and a value/connector object to add an input to the gate

		if index >= @inputs.length
			@inputs << value
			@history_active = 0 # dont use history after a new input added
			# because history is set to 0 trigger will be called 
			# irrespective of the history
			self.update_history() 
		else
			@history_active = 1
			if @inputs[index].is_a?(Connector)
				@history_inputs[index] = @inputs[index].state
			else 
				@history_inputs[index] = @inputs[index]
			end
			@inputs[index] = value
		end	

		if value.is_a?(Connector)
			value.tap("input")
		end

		self.trigger()
	end

	def get_input_states
		# This returns the input states of the gate

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
		if value.nil?
			@result = nil
		else
			@result = value
		end

		if @output_type == 1
			@output_connector.state = @result
		end
	end

	def update_history
		@inputs.each_with_index do |inp, idx|
			if inp.is_a?(Connector)
				value = inp.state
			else
				value = inp
			end

			if @history_inputs.length < idx
				@history_inputs << value
			else 
				@history_inputs[idx] = value
			end
		end
	end

	def set_output(connector)
		# Sets the output of the gate.
		# It connects the passed connector to its output
		if connector.is_a?(Connector)
			connector.tap("output")
			@output_type = 1
			@output_connector = connector
			@history_active = 0
			self.trigger()
		else
			raise ArgumentError, "argument must be an instance of the connector class object"
		end
	end

	def reset_output
		# This resets the output of the gate
		# output of the gate is nott connected to any connector object
		@output_connector.untap("output")
		@output_type = 0
		@output_connector = nil
	end

	def output()
		# This method returns the output of the gate
		self.trigger()
		return @result
	end

	def inspect
		return self.output().to_s
	end

	def build_str(gate_name)
		# returns the string reepresentation of a gate
		if ["AND", "OR", "NOT", "XOR", "NAND", "NOR", "XNOR"].include?(gate_name)
			return gate_name + " Gate; Output: " + self.output().to_s + "; Inputs: " + self.get_input_states().to_s
		end
		raise "invalid gate_name: #{gate_name}"
	end

	def compare_history
		if @history_active == 1 # only check if history is active
			@inputs.each_with_index do |inp, idx|
				if inp.is_a?(Connector)
					value = inp.state
				else 
					value = inp
				end

				if idx > @history_inputs.length or @history_inputs[idx] != value
					return true
				end
			end
			return false
		end
		return true
	end

	def add_input(value)
		# Adding input to an existing gate
		@history_active = 0 # don't use history after adding an input
		@inputs << value
		self.update_connections
		self.update_history
	end

	def remove_input(index)
		# removes an input whose index is passed
		if @inputs.length == 2 
			raise "cannot remove an input; too few inputs left after removal"
		end

		# indexing of inputs is 0-based indexing
		if index >= @inputs.length
			raise "index for removal out of bounds"
		end

		@history_active = 0
		@inputs.delete_at(index)
		self.update_connections
		self.update_history
	end

end

