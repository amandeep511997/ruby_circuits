=begin
	This class provides a medium for data transfer, a digital connection which can be connected betweeen any 
	digital component to connect them together.
=end
=begin
	Example
	-------
	conn = Connector.new(1)
	conn.get_logic() => returns 1
	gate = OR([0, 1])
	conn.tap(gate, 'output')

	Methods
	-------
	1. set_logic : To set the logic state of the connector.
	2. get_logic : To get the logic state of the connector
	3. is_input_of : To check if the connector is the input of given element
	4. is_output_of : To check if the connector is the output of given element
	5. tap : Tap this connector as input/output of another element
	6. untap : Untap this connector from another element

	Properties
	----------
	1. index : The index of the connecctor instance registered with Indexer
	2. name : Get the name of the connector
	3. state : To get the logic state of the connector[read/write supported]

	4. enabled : true if connector is enabled.
	5. disabled : true if connecto is disabled.
=end	

class Connector

	attr_reader :index, :state, :name

	def initialize(state=nil, name=nil)
		# to store all the taps onto this connection
		@enable = true

		@connections = {"input" => [], output => []}
		self.set_logic(state)
		
		@old_state = nil
		
		@index = CircuitIndexer.index(self)

		@name = if name.nil? then "connector#{@index}" else name end
	end

	def tap(element, mode)
		# there can only be one output for a device
		if mode == "output"
			@connections["output"] = []
		end

		# add an element to the connections list
		unless connections[mode].include?(element)
			@connections[mode] << element
		end
	end

	def untap(element, mode)
		if connections[mode].include?(element)
			@connections[mode].delete(element)
		else 
			raise ArgumentError, "Invalid Argument: Connector is not the #{mode} of the passed element"
		end
	end

	def is_input?(element)
		return @connections["input"].include?(element)
	end

	def is_output?(element)
		return @connections["output"].include?(element)
	end

	# this function is called when the value of the connection changes
	def trigger()
		@connections["input"].each do |connection|
			connection.trigger()
		end
	end

# setter and getter methods
	def set_logic(value)
		unless @enable
			return
		end

		if [Fixnum, TrueClass, FalseClass, NilClass].include?(value.class)
			@state = if value.nil? then nil else value end
			self.trigger()
		elsif value.is_a?(Connector) 
			@state = value.get_logic()
		else
			raise ArgumentError, "Invalid Argument: Invalid input type. Only integer, boolean and nil accepted."			
		end
		self.trigger()
	end	

	def get_logic()
		return @state
	end

	def set_name(name)
		if name.present?
			@name = name
		else
			raise "connector name cannot be nil"
		end
	end

	def enable
		@enable = true
	end

	def disable
		@enable = false
	end

	def enabled 
		return @enable
	end

	def disabled
		return !@enable
	end

# overriden standard methods

	def inspect
		return @state.to_s
	end

	def to_i
		if @state == 1
			return 1 
		end 
		return 0
	end

	def to_s
		# handle case when variable can be nil
		return "Connector; name : #{@name}, index : #{@index}, state : #{@state}"
	end

# try to add destructor in the end

end