require 'celluloid'
=begin 
	This class uses Threading technique to create a clock with a ceratin time period

	frequency = decides time interval of the clock, in Hertz
	time_period = decides time interval of the clock, in sec
	inital_state = initial state of the clock, by default it is 1
	name = name of the clock(optional)

	It both time_period and frequency provided then time_period is used
	If nothing provided out of the two then by default time_period = 1s

	Remember - once clock used do call .stop() function to stop the clock
	to prevent overloading of the CPU
=end

# seperate clock stop and kill functions - TODO

class Clock
	include Celluloid
	attr_reader :state, :frequency, :time_period, :name

	def initialize(inital_state=1, frequency=nil, time_period=nil, name=nil)
		if not frequency.nil?
			@time_period = 1.to_f / frequency.to_f
		end
		if not time_period.nil?
			@time_period = time_period
		end
		if time_period.nil? and frequency.nil?
			@time_period = 1
		end

		@name = name
		@state = inital_state

		@clock_connector = Connector.new(inital_state)

		@started = false
	end

	def start
		if not @started
			every @time_period do 
				self.toogle_state()
			end	
		end
	end

	def get_state
		return @state
	end

	def set_state(value)
		if @state == value
			return 
		end
		@state = value
		@clock_connector.state = @state 
	end

	def frequency
		return (1.to_f / @time_period.to_f)
	end

	def stop
		self.terminate
	end
	
private
	
	def toogle_state
		if @state == 1
			@state = 0
			@clock_connector.state = @state	
		else
			@state = 1
			@clock_connector.state = @state	
		end
	end

end
