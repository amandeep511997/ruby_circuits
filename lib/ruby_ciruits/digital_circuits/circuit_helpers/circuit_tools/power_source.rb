require_relative "../connectors/connector"

=begin 
	Power Source from which various connectors can tap by connecting to it
	taps = The list of all connectors connected to this power source
	connect() = takes in one or more connectors as input and connects them to the power source
	disconnect() = takes in one or more connectors and disconnects them from the power source
=end

class PowerSource
	def initialize
		@taps = Array.new
	end	

	def connect(*connectors)
		connectors.each do |connector|
			if not connector.is_a?(Connector)
				raise "all objects must be of Connector type"
			else
				if connector.connections["output"].length != 0
					raise "given connector is already an output of some other object"
				else
					@taps << connector
					connector.state = 1
					connector.tap(self, "output") 
					connector.trigger()
				end
			end
		end
	end

	def disconnect(*connectors)
		connectors.each do |connector|
			if not connector.is_a?(Connector)
				raise "all objects must be of Connector type"
			else
				begin
					connector.untap(self, "output")
					@taps.delete(connector)
					connector.state = nil 
					connector.trigger()
				rescue 
					print "specified connector not tapped to this power source"
				end
			end
		end
	end
end