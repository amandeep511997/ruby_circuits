require "celluloid"

=begin 
	Create a multivibrator with a certain time period

	Following are the parameters of the class
	frequency: It decides the time interval of the multivibrator, Hz
	time_period: It decides time interval of the Multivibrator, second
	
	If time_period and frequency both have been provided, then time_period will override
	frequency. If nothing is provided, then it will set time_period as 1sec

	Mode of operations - 
	1. Monostable
	2. Astable
	3. Bistable
=end

class Multivibrator
	include Celluloid

	attr_reader :time_period

	def initialize(inital_state=1, mode=1, frequency=nil, time_period=nil, on_time=nil, off_time=nil)
		unless frequency.nil?
			@time_period = 1.to_f / frequency.to_f
		end
		unless time_period.nil?
			@time_period = time_period
		end
		if time_period.nil? and frequency.nil?
			@time_period = 1
		end

		@mode = mode

		if on_time.nil? or off_time.nil?
			@on_time = @time_period / 2
			@off_time = @time_period / 2
		else
			@on_time = on_time
			@off_time = off_time
		end

		@inital_state = inital_state
		@current_state = inital_state
		@exit = false
		@multivibrator_connector = Connector.new(@inital_state)
		@update = false
		@started = false
		# we dont start it here
	end

	def start
		if not @started
			self.run()
			@started = true
		end
	end

	def run
		while true
			if @update == true
				if @mode == 1
					@multivibrator_connector.state = 1
					@multivibrator_connector.trigger()
					every @time_period do
						toogle_state()
					end
					@update = false
				elsif @mode == 2
					on_off_time = if @multivibrator_connector.state == 1 then on_time else off_time end
					every on_off_time do
						toogle_state()
						on_off_time = if @multivibrator_connector.state == 1 then on_time else off_time end
					end
				else @mode == 3
					
					toogle_state()
					@update = false
				end
			end
		end
	end

	def set_mode(mode)
		@mode = mode
		@update = false
	end

	def get_state
		return @multivibrator_connector.state
	end

	def set_state(value)
		@multivibrator_connector.state = value
	end

	def trigger
		@update = true
	end

	def set_output(connector)
		if not connector.is_a?(Connector)
			raise "the output can only be a object of Connector class"
		end
		@multivibrator_connector = connector
	end

	def stop
		@update = false
	end

	def kill
		self.terminate
	end

private

	def toogle_state
		self.set_state(1 - @multivibrator_connector.state)
		@multivibrator_connector.trigger()	
	end
end