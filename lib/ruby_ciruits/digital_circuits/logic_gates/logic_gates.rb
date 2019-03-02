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

	class AND < Gates

		def initialize(*args)
			# takes inputs and returns 	
		end

		def trigger()
			
		end

		def to_s
			'AND'
		end

	end

	class OR < Gates

		def initialize(*args)
			# takes inputs and returns 	
		end

		def trigger()

		end

		def to_s
			'OR'
		end

	end

	class NOT < Gates

		def initialize(*args)
			# takes inputs and returns 	
		end

		def trigger()

		end

		def to_s
			'NOT'
		end

	end

	class XOR < Gates

		def initialize(*args)
			# takes inputs and returns 	
		end

		def trigger()

		end

		def to_s
			'XOR'
		end

	end


	class NAND < Gates

		def initialize(*args)
			# takes inputs and returns 	
		end

		def trigger()

		end

		def to_s
			'NAND'
		end

	end


	class NOR < Gates

		def initialize(*args)
			# takes inputs and returns 	
		end

		def trigger()

		end

		def to_s
			'NOR'
		end

	end

	class XNOR < Gates

		def initialize(*args)
			# takes inputs and returns 	
		end

		def trigger()

		end

		def to_s
			'XNOR'
		end

	end
end