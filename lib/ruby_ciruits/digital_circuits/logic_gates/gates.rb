=begin
	Base class for all logic gates
=end 

class LogicGates

	def initialize(*args)
		# clean connections before updating new connections
		@history_active = 0	# ignore history for the first computation
		@output_type = 0 # if 1 then it goes to the connector class
		@result = nil # To store the result
		@output_connector = nil
		## Make a check of input parameters raise exception if invalid
		@inputs = args # set the inputs
		@history_inputs = [] # save a copy of inputs
		# Any change in the input will trigger a change in the output
		update_connections()
		update_history()
		trigger()
	end

	def update_connections
		@inputs.each do |inp|
			# Connector as the class or one of the ancestral class
			if inp.is_a?(Connector) 
				inp.tap('input')
			end
		end
	end
end

