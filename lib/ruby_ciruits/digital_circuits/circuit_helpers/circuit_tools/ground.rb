=begin 
	Ground from which various connectors ccan tap by connecting to it.
	taps = list of all connectors connected to this ground
	connect() = takes one or more connectors and connect them to the ground
	disconnect() = takes in one or more connectors as input and disconnects it from the ground
=end

class Ground
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
					connector.state = 0
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
					print "specified connector not tapped to this ground"
				end
			end
		end
	end
end