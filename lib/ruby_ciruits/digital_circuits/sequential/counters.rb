=begin 
	contains all counters for digital circuits
=end


module CounterBase
	def set_properties()

	end	

	def set_input

	end

	def trigger

	end

	def set_counter

	end

	def reset_counter

	end

	def enable

	end

	def disable

	end

	def state

	end

end

module Counter
	class Binary
		include CounterBase
	end

	class NBitRipple
		include CounterBase
	end

	class NBitDown
		include CounterBase
	end

	class Decade
		include CounterBase
	end

	class Octal
		include CounterBase
	end

	class Stage14
		include CounterBase
	end

	class Ring
		include CounterBase
	end

	class Johnson
		include CounterBase
	end
end