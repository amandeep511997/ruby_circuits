=begin 
	Module contains All flip flops
=end


module FlipFlopBase
	def set_properties(a, b, clk, enable)
		@A = a
		@B = b
		@clk = clk
		@clk_old_value = 1
		# enable is assumed to be a connector
		@enable = enable 
	end

	def enable
		@enable.state = 1
	end

	def disable
		@enable.state = 0
	end

	def setFF
		@A.state = 1
		@B.state = 0
		return [@A.state, @B.state]
	end	

	def resetFF()
		@A.state = 0
		@B.state = 1
		return [@A.state, @B.state]
	end
end

module FlipFlop
	class SRLatch
		include FlipFlopBase
		def initialize(	s, 
					r, 
					enable, 
					clk, 
					preset=Connector.new(1), 
					clear=Connector.new(1), 
					a=Connector.new(0), 
					b=Connector.new(1))

			self.set_properties(a, b, clk, enable)

			@S = Connector.new(0)
			@R = Connector.new(1)

			@preset = Connector.new(1)
			@clear = Connector.new(1)

			@enabledS = Connector.new(0)
			@enabledR = Connector.new(1)

			@enable1 = LogicGates::AND.new(s, enable)
			@enable2 = LogicGates::AND.new(r, enable)

			@nor_gate1 = LogicGates::NOR.new(@enabledS, a)
			@nor_gate2 = LogicGates::NOR.new(@enabledR, b)

			self.set_inputs(s, r, enable, preset, clear)
			self.set_outputs(a, b)
		end

		def set_inputs(inputs)
			if not inputs.is_a?(Hash)
				raise "parameters not passed as expected"
			end
			inputs.each do |key, value|
				if key.downcase == "s"
					if value.is_a?(Connector)
						@S = value
					else
						@S.state = value.to_i
					end
				elsif key.downcase == "r"
					if value.is_a?(Connector)
						@R = value
					else
						@R.state = value.to_i
					end
				elsif key.downcase == "enable"
					if value.is_a?(Connector)
						@enable = value
					else
						@enable.state = value.to_i
					end
				elsif key.downcase == "clk"
					if value.is_a?(Connector)
						@clk = value
					else
						@clk.state = value.to_i
					end
				elsif key.downcase == "preset"
					if value.is_a?(Connector)
						@preset = value
					else
						@preset.state = value.to_i
					end
				elsif key.downcase == "clear"
					if value.is_a?(Connector)
						@clear = value
					else
						@clear.state = value.to_i
					end
				else 
					raise ArgumentError, "unknown parameter passed"
				end
			end

			if not (@S.state ^ @R.state)
				@S.state = 0
				@R.state = 1
				print "invalid state, resetting"
			end

			if not (@preset.state or @clear.state)
				@preset.state = 1
				@clear.state = 1
				print "invalid state, resetting"
			end

			@enable1.set_input(0, @S)
			@enable1.set_input(1, @enable)
			@enable1.set_output(@enabledS)

			@enable2.set_input(0, @R)
			@enable2.set_input(1, @enable)
			@enable2.set_output(@enabledR)

			@nor_gate1.set_input(0, @enabledS)
			@nor_gate1.set_input(1, @A)

			@nor_gate2.set_input(0, @enabledR)
			@nor_gate2.set_input(1, @B)
		end

		def set_outputs(outputs)
			if not outputs.is_a?(Hash)
				raise "parameters not passed as expected"
			end
			outputs.each do |key, value|
				if not value.is_a?(Connector)
					raise "output must be a connector instance"
				end
				if key.downcase == "a"
					@A = value
				elsif key.downcase == "b"
					@B = value
				else
					raise ArgumentError, "unknown parameter passed"
				end
					
			end

			@nor_gate1.set_output(@B)
			@nor_gate1.set_input(1, @A)

			@nor_gate2.set_output(@A)
			@nor_gate2.set_input(1, @B)
		end

		def trigger
			if @clear.state == 1 and @preset.state == 0
				return self.setFF()
			elsif @clear.state == 0 and @preset.state == 1
				return self.resetFF()
			elsif not (@preset.state or @clear.state)
				@preset.state = 1
				@clear.state = 1
				print "invalid state, resetting"
			else
				if @clk_old_value == 1 and @clk.state == 0
					if @S.state and @R.state
						@S.state = 0
						@R.state = 1
						print "invalid state, resetting"		
					end
					@enable.trigger()
				end
			end
			
			@clk_old_value = @clk.state

			return [@A.state, @B.state]
		end

		def state
			return [@A.state, @B.state]
		end

	end

	class JK
		include FlipFlopBase
		def initialize(	j, 
					k, 
					enable, 
					clk, 
					preset=Connector.new(1), 
					clear=Connector.new(1), 
					a=Connector.new(0), 
					b=Connector.new(1))

			self.set_properties(a, b, clk, enable)

			@J = Connector.new(0)
			@K = Connector.new(0)

			@preset = Connector.new(1)
			@clear = Connector.new(1)

			self.set_inputs(j, k, enable, preset, clear)
			self.set_outputs(a, b)

			@J.tap("input")
			@K.tap("input")
			@enable.tap("input")
			@clk.tap("input")

			@A.tap("output")
			@B.tap("output")
		end

		def set_inputs(inputs)
			if not inputs.is_a?(Hash)
				raise "parameters not passed as expected"
			end
			inputs.each do |key, value|
				if key.downcase == "j"
					if value.is_a?(Connector)
						@J = value
					else
						@J.state = value.to_i
					end
				elsif key.downcase == "k"
					if value.is_a?(Connector)
						@K = value
					else
						@K.state = value.to_i
					end
				elsif key.downcase == "enable"
					if value.is_a?(Connector)
						@enable = value
					else
						@enable.state = value.to_i
					end
				elsif key.downcase == "clk"
					if value.is_a?(Connector)
						@clk = value
					else
						@clk.state = value.to_i
					end
				elsif key.downcase == "preset"
					if value.is_a?(Connector)
						@preset = value
					else
						@preset.state = value.to_i
					end
				elsif key.downcase == "clear"
					if value.is_a?(Connector)
						@clear = value
					else
						@clear.state = value.to_i
					end
				else 
					raise ArgumentError, "unknown parameter passed"
				end 
			end

			if not(@preset.state or @clear.state)
				@preset.state = 1
				@clear.state = 1
				print "invalid state, resetting"
			end

			@J.tap("input")
			@K.tap("input")
			@enable.tap("input")
			@clk.tap("input")
		end

		def set_outputs(outputs)
			if not outputs.is_a?(Hash)
				raise "parameters not passed as expected"
			end
			outputs.each do |key, value|
				if not value.is_a?(Connector)
					raise "output must be a connector instance"
				end
				if key.downcase == "a"
					@A = value
				elsif key.downcase == "b"
					@B = value
				else
					raise ArgumentError, "unknown parameter passed"
				end
			end

			@A.tap("output")
			@B.tap("output")
		end

		def trigger
			if @clear.state == 1 and @preset.state == 0
				return self.setFF()
			elsif @clear.state == 0 and @preset.state == 1
				return self.resetFF()
			elsif not(@clear.state or @preset.state)
				@preset.state = 1
				@clear.state = 1
				print "invalid state, resetting"
			else
				if @clk_old_value == 1 and @clk.state == 0
					if @enable.state == 1
						if @J.state == 1 and @K.state == 1
							@A.state = if @A.state == 1 then 0 else 1 end
						elsif @J.state == 1 and @K.state == 1
							@A.state = 0
						elsif @J.state == 1 and @K.state == 1
							@A.state = 1
						end	
					end

					@B.state = if @A.state == 1 then 0 else 1 end
					@A.trigger()
					@B.trigger()
				end
			end
			@clk_old_value = @clk.state
			return [@A.state, @B.state]
		end

		def state
			return [@A.state, @B.state]
		end
	end

	class D
		include FlipFlopBase
		def initialize(	d,
					enable, 
					clk, 
					preset=Connector.new(1), 
					clear=Connector.new(1), 
					a=Connector.new(0), 
					b=Connector.new(0))

			self.set_properties(a, b, clk, enable)

			@D = Connector.new(0)
			@and_gate = LogicGates::AND.new(@D, @enable)
			@not_gate = LogicGates::NOT.new(@A)

			@preset = Connector(1)
			@clear = Connector(1)

			self.set_inputs(d, enable, preset, clear)
			self.set_outputs(a, b)
		end

		def set_inputs(inputs)
			if not inputs.is_a?(Hash)
				raise "parameters not passed as expected"
			end
			inputs.each do |key, value|
				if key.downcase == "d"
					if value.is_a?(Connector)
						@D = value
					else
						@D.state = value.to_i
					end
				elsif key.downcase == "enable"
					if value.is_a?(Connector)
						@enable = value
					else
						@enable.state = value.to_i
					end
				elsif key.downcase == "clk"
					if value.is_a?(Connector)
						@clk = value
					else
						@clk.state = value.to_i
					end
				elsif key.downcase == "preset"
					if value.is_a?(Connector)
						@preset = value
					else
						@preset.state = value.to_i
					end
				elsif key.downcase == "clear"
					if value.is_a?(Connector)
						@clear = value
					else
						@clear.state = value.to_i
					end
				else 
					raise ArgumentError, "unknown parameter passed"
				end 
			end

			if not(@preset.state or @clear.state)
				@preset.state = 1
				@clear.state = 1
				print "invalid state, resetting"
			end

			@and_gate.set_input(0, @D)
			@and_gate.set_input(1, @enable)
			@and_gate.set_output(@A)

			@not_gate.set_input(@A)
			@not_gate.set_output(@B)
		end

		def set_outputs(outputs)
			if not outputs.is_a?(Hash)
				raise "parameters not passed as expected"
			end
			outputs.each do |key, value|
				if not value.is_a?(Connector)
					raise "output must be a connector instance"
				end
				if key.downcase == "a"
					@A = value
				elsif key.downcase == "b"
					@B = value
				else
					raise ArgumentError, "unknown parameter passed"
				end
			end

			@and_gate.set_output(@A)

			@not_gate.set_input(@A)
			@not_gate.set_output(@B)
		end

		def trigger	
			if @clear.state == 1 and @preset.state == 0
				return self.setFF()
			elsif @clear.state == 0 and @preset.state == 1
				return self.resetFF()
			elsif not(@clear.state or @preset.state)
				@preset.state = 1
				@clear.state = 1
				print "invalid state, resetting"
			else
				if @clk_old_value == 1 and @clk.state == 0
					@D.trigger
				end
			end
			
			@clk_old_value = @clk.state
			return [@A.state, @B.state]
		end

		def state
			return [@A.state, @B.state]
		end
	end

	class T < JK
		def initialize(	t,
					enable, 
					clk, 
					preset=Connector.new(1), 
					clear=Connector.new(1), 
					a=Connector.new, 
					b=Connector.new)

			super(t, t, enable, clk, preset, clear, a, b)
		end

		def set_inputs(inputs)
			if not inputs.is_a?(Hash)
				raise "parameters not passed as expected"
			end
			super
		end

		def set_outputs(outputs)
			if not outputs.is_a?(Hash)
				raise "parameters not passed as expected"
			end
			super
		end

		def trigger
			super
		end 

		def state
			super
		end
	end
end
