require_relative '../design/structure'
require_relative '../design/base_14pin'
require_relative '../design/base_16pin'
require_relative '../design/base_24pin'
# require [connectors, gates, ic.basgit e, combinational, sequential, and clock]

# This module contains all classes for 7400 series
# length of pins used in programming is one more than actual number of pins
# as pin0 is not used

# 7400 series ICs in this module

## ICs with 14 pins
# 7400 = Quad 2 input NAND gate
# 7401 = Quad 2 input open-collector NAND gate
# 7402 = Quad 2 input NOR gate
# 7403 = Quad 2 input open-collector NAND gate
# 7404 = Hex inverter 
# 7405 = Hex open-collector inverter 
# 7408 = Quad 2 input AND gate 
# 7410 = Triple 3 input NAND gate 
# 7411 = Triple 3 input AND gate 
# 7412 = Triple 3 input NAND gate IC with open collector outputs
# 7413 = dual 4 input NAND gate 
# 7415 = Triple 3 input AND gate IC with open collector outputs
# 7418 = Dual 4-input NAND gates with schmitt-trigger inputs
# 7419 = Hex inverters with schmitt-trigger line receiver inputs
# 7420 = Dual 4 input NAND gate
# 7421 = Dual 4 input AND gate
# 7422 = Dual 4-input NAND gates with open-collector outputs
# 7424 = Quad 2-input NAND gates with schmitt-trigger line-receiver inputs
# 7427 = Triple 3 input NOR gate 
# 7428 = Quad 2-input NOR gates with buffered outputs
# 7430 = 8-input NAND gate
# 7432 = Quad 2-input OR gate
# 7433 = Quad 2 input open-collector NOR gate
# 7437 = Quad 2-input NAND gates with buffered outputs
# 7440 = Dual 4-input NAND buffer
# 7470 = AND gated JK positive edge triggered Flip FLop with preset and clear
# 7472 = AND gated JK Master-Slave Flip FLop with preset and clear
# 7473 = Dual JK FF with clear
# 7474 = Dual D-type positive edge triggered FFs with preset and clear
# 7486 = Quad 2-input exclusive OR gate
# 74152 = 14 pin 8:1 mux with inverted input
# 74260 = Dual 5-input NOR gate

## ICs with 16 pins
# 7431 = Hex delay element
# 7442 = BCD to decimal decoder
# 7443 = excess-3 to decimal decoder
# 7444 = excess-3 gray code to decimal decoder
# 7445 = BCD to decimal decoder
# 7447 = BCD to 7 segment decoder
# 7459 = 2-input and 3-input AND-OR inverter gate
# 7485 = 4-bit magnitude comparator
# 7475 = 4-bit bistable latches
# 7476 = Dual JK FF with preset and clear
# 7483 = 4-bit full adder with fast carry
# 74133 = 13-input NAND gate

## Ics with 24 pins
# 74181 = 4-bit arithmetic logic unit with performs 16 different functions



module Series7400
	### ICs with 14 pins ###
	class IC_7400
		# 7400 = Quad 2 input NAND gate
		#Pin Configuration:
		#    Pin Number  Description
		#        1   A Input Gate 1
		#        2   B Input Gate 1
		#        3   Y Output Gate 1
		#        4   A Input Gate 2
		#        5   B Input Gate 2
		#        6   Y Output Gate 2
		#        7   Ground
		#        8   Y Oudtput Gate 3
		#        9   B Input Gate 3
		#        10  A Input Gate 3
		#        11  Y Output Gate 4
		#        12  B Input Gate 4
		#        13  A Input Gate 4
		#        14  Positive Supply
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[3] = @pins[6] = @pins[8] = @pins[11] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[3] = LogicGates::NAND.new(@pins[1], @pins[2]).output()
        	output[6] = LogicGates::NAND.new(@pins[4], @pins[5]).output()
        	output[8] = LogicGates::NAND.new(@pins[9], @pins[10]).output()
        	output[11] = LogicGates::NAND.new(@pins[12], @pins[13]).output()

        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end

	class IC_7401
		# 7401 = Quad 2 input open-collector NAND gate
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[1] = @pins[4] = @pins[10] = @pins[13] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[1] = LogicGates::NAND.new(@pins[2], @pins[3]).output()
	        output[4] = LogicGates::NAND.new(@pins[5], @pins[6]).output()
	        output[10] = LogicGates::NAND.new(@pins[8], @pins[9]).output()
	        output[13] = LogicGates::NAND.new(@pins[11], @pins[12]).output()
        	
        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end
	
	class IC_7402
		# 7402 = Quad 2 input NOR gate
		#Pin Configuration:
		#    Pin Number  Description
		#        1   Y Output Gate 1
		#        2   A Input Gate 1
		#        3   B Input Gate 1
		#        4   Y Output Gate 2
		#        5   A Input Gate 2
		#        6   B Input Gate 2
		#        7   Ground
		#        8   A Input Gate 3
		#        9   B Input Gate 3
		#        10  Y Output Gate 3
		#        11  A Input Gate 4
		#        12  B Input Gate 4
		#        13  Y Output Gate 4
		#        14  Positive Supply

		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[1] = @pins[4] = @pins[10] = @pins[13] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[1] = LogicGates::NOR.new(@pins[2], @pins[3]).output()
	        output[4] = LogicGates::NOR.new(@pins[5], @pins[6]).output()
	        output[10] = LogicGates::NOR.new(@pins[8], @pins[9]).output()
	        output[13] = LogicGates::NOR.new(@pins[11], @pins[12]).output()
        	
        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end
	
	class IC_7403
		# 7403 = Quad 2 input open-collector NAND gate
		#Pin Configuration:
		#    Pin Number  Description
		#        1   A Input Gate 1
		#        2   B Input Gate 1
		#        3   Y Output Gate 1
		#        4   A Input Gate 2
		#        5   B Input Gate 2
		#        6   Y Output Gate 2
		#        7   Ground
		#        8   Y Output Gate 3
		#        9   B Input Gate 3
		#        10  A Input Gate 3
		#        11  Y Output Gate 4
		#        12  B Input Gate 4
		#        13  A Input Gate 4
		#        14  Positive Supply
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[3] = @pins[6] = @pins[8] = @pins[11] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[3] = LogicGates::NAND.new(@pins[1], @pins[2]).output()
        	output[6] = LogicGates::NAND.new(@pins[4], @pins[5]).output()
        	output[8] = LogicGates::NAND.new(@pins[9], @pins[10]).output()
        	output[11] = LogicGates::NAND.new(@pins[12], @pins[13]).output()
        	
        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end
	
	class IC_7404
		# 7404 = Hex inverter 
		#Pin Configuration:
		#    Pin Number  Description
		#        1   A Input Gate 1
		#        2   Y Output Gate 1
		#        3   A Input Gate 2
		#        4   Y Output Gate 2
		#        5   A Input Gate 3
		#        6   Y Output Gate 3
		#        7   Ground
		#        8   Y Output Gate 4
		#        9   A Input Gate 4
		#        10  Y Output Gate 5
		#        11  A Input Gate 5
		#        12  Y Output Gate 6
		#        13  A Input Gate 6
		#        14  Positive Supply

		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[2] = @pins[4] = @pins[6] = @pins[8] = @pins[10] = @pins[12] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[2] = LogicGates::NOT.new(@pins[1]).output()
	        output[4] = LogicGates::NOT.new(@pins[3]).output()
	        output[6] = LogicGates::NOT.new(@pins[5]).output()
	        output[8] = LogicGates::NOT.new(@pins[9]).output()
	        output[10] = LogicGates::NOT.new(@pins[11]).output()
	        output[12] = LogicGates::NOT.new(@pins[13]).output()
        	
        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end

	class IC_7405
		# 7405 = Hex open-collector inverter 
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[2] = @pins[4] = @pins[6] = @pins[8] = @pins[10] = @pins[12] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[2] = LogicGates::NOT.new(@pins[1]).output()
	        output[4] = LogicGates::NOT.new(@pins[3]).output()
	        output[6] = LogicGates::NOT.new(@pins[5]).output()
	        output[8] = LogicGates::NOT.new(@pins[9]).output()
	        output[10] = LogicGates::NOT.new(@pins[11]).output()
	        output[12] = LogicGates::NOT.new(@pins[13]).output()
        	
        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end
	
	class IC_7408
		# 7408 = Quad 2 input AND gate 
		#Pin Configuration:
		#	Pin Number  Description
	    #    1   A Input Gate 1
	    #    2   B Input Gate 1
	    #    3   Y Output Gate 1
	    #    4   A Input Gate 2
	    #    5   B Input Gate 2
	    #    6   Y Output Gate 2
	    #    7   Ground
	    #    8   Y Output Gate 3
	    #    9   B Input Gate 3
	    #    10  A Input Gate 3
	    #    11  Y Output Gate 4
	    #    12  B Input Gate 4
	    #    13  A Input Gate 4
	    #    14  Positive Supply
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[3] = @pins[6] = @pins[8] = @pins[11] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[3] = LogicGates::AND.new(@pins[1], @pins[2]).output()
	        output[6] = LogicGates::AND.new(@pins[4], @pins[5]).output()
	        output[8] = LogicGates::AND.new(@pins[9], @pins[10]).output()
	        output[11] = LogicGates::AND.new(@pins[12], @pins[13]).output()
        	
        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end

	class IC_7410
		# 7410 = Triple 3 input NAND gate 
		#Pin Configuration:
		#	Pin Number  Description
		#        1   A Input Gate 1
		#        2   B Input Gate 1
		#        3   A Input Gate 2
		#        4   B Input Gate 2
		#        5   C Input gate 2
		#        6   Y Output Gate 2
		#        7   Ground
		#        8   Y Output Gate 3
		#        9   A Input Case 3
		#        10  B Input Case 3
		#        11  C Input Case 3
		#        12  Y Output Gate 1
		#        13  C Input Gate 1
		#        14  Positive Supply
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[6] = @pins[8] = @pins[12] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
	        output[6] = LogicGates::NAND.new(@pins[3], @pins[4], @pins[5]).output()
	        output[8] = LogicGates::NAND.new(@pins[9], @pins[10], @pins[11]).output()
        	output[12] = LogicGates::NAND.new(@pins[1], @pins[2], @pins[13]).output()

        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end
	
	class IC_7411
		# 7411 = Triple 3 input AND gate 
		#Pin Configuration:
		#	Pin Number  Description
		#        1   A Input Gate 1
		#        2   B Input Gate 1
		#        3   A Input Gate 2
		#        4   B Input Gate 2
		#        5   C Input gate 2
		#        6   Y Output Gate 2
		#        7   Ground
		#        8   Y Output Gate 3
		#        9   A Input Case 3
		#        10  B Input Case 3
		#        11  C Input Case 3
		#        12  Y Output Gate 1
		#        13  C Input Gate 1
		#        14  Positive Supply
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[6] = @pins[8] = @pins[12] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
	        output[6] = LogicGates::AND.new(@pins[3], @pins[4], @pins[5]).output()
	        output[8] = LogicGates::AND.new(@pins[9], @pins[10], @pins[11]).output()
        	output[12] = LogicGates::AND.new(@pins[1], @pins[2], @pins[13]).output()

        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end
	
	class IC_7412
		# 7412 = Triple 3 input NAND gate IC with open collector outputs
		#Pin Configuration:
		#	 Pin Number  Description
		#        1   A Input Gate 1
		#        2   B Input Gate 1
		#        3   A Input Gate 2
		#        4   B Input Gate 2
		#        5   C Input gate 2
		#        6   Y Output Gate 2
		#        7   Ground
		#        8   Y Output Gate 3
		#        9   A Input Case 3
		#        10  B Input Case 3
		#        11  C Input Case 3
		#        12  Y Output Gate 1
		#        13  C Input Gate 1
		#        14  Positive Supply
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[6] = @pins[8] = @pins[12] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
	        output[6] = LogicGates::NAND.new(@pins[3], @pins[4], @pins[5]).output()
	        output[8] = LogicGates::NAND.new(@pins[9], @pins[10], @pins[11]).output()
        	output[12] = LogicGates::NAND.new(@pins[1], @pins[2], @pins[13]).output()

        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end
	
	class IC_7413
		# 7413 = dual 4 input NAND gate 
		#Pin Configuration:
		#	  Pin Number  Description
		#        1   A Input Gate 1
		#        2   B Input Gate 1
		#        3   Not Connected
		#        4   C Input Gate 1
		#        5   D Input Gate 1
		#        6   Y Output Gate 1
		#        7   Ground
		#        8   Y Output Gate 2
		#        9   A Input Gate 2
		#        10  B Input Gate 2
		#        11  Not Connected
		#        12  C Input Gate 2
		#        13  D Input Gate 2
		#        14  Positive Supply
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[6] = @pins[8] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[6] = LogicGates::NAND.new(@pins[1], @pins[2], @pins[4], @pins[5]).output()
        	output[8] = LogicGates::NAND.new(@pins[9], @pins[10], @pins[12], @pins[13]).output()

        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end
	
	class IC_7415
		# 7415 = Triple 3 input AND gate IC with open collector outputs
		#Pin Configuration:
		#	 Pin Number  Description
		#        1   A Input Gate 1
		#        2   B Input Gate 1
		#        3   A Input Gate 2
		#        4   B Input Gate 2
		#        5   C Input Gate 2
		#        6   Y Output Gate 2
		#        7   Ground
		#        8   Y Output Gate 3
		#        9   A Input Gate 3
		#        10  B Input Gate 3
		#        11  C Input Gate 3
		#        12  Y Output Gate 1
		#        13  C Input Gate 1
		#        14  Positive Supply
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[6] = @pins[8] = @pins[12] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
	        output[6] = LogicGates::AND.new(@pins[3], @pins[4], @pins[5]).output()
	        output[8] = LogicGates::AND.new(@pins[9], @pins[10], @pins[11]).output()
			output[12] = LogicGates::AND.new(@pins[1], @pins[2], @pins[13]).output()
        	
        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end
	
	class IC_7418
		# 7418 = Dual 4-input NAND gates with schmitt-trigger inputs
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[6] = @pins[8] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[6] = LogicGates::NAND.new(@pins[1], @pins[2], @pins[4], @pins[5]).output()
        	output[8] = LogicGates::NAND.new(@pins[9], @pins[10], @pins[12], @pins[13]).output()

        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end

	class IC_7419
		# 7419 = Hex inverters with schmitt-trigger line receiver inputs
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[2] = @pins[4] = @pins[6] = @pins[8] = @pins[10] = @pins[12] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[2] = LogicGates::NOT.new(@pins[1]).output()
	        output[4] = LogicGates::NOT.new(@pins[3]).output()
	        output[6] = LogicGates::NOT.new(@pins[5]).output()
	        output[8] = LogicGates::NOT.new(@pins[9]).output()
	        output[10] = LogicGates::NOT.new(@pins[11]).output()
	        output[12] = LogicGates::NOT.new(@pins[13]).output()
        	
        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end

	class IC_7420
		# 7420 = Dual 4 input NAND gate
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[6] = @pins[8] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[6] = LogicGates::NAND.new(@pins[1], @pins[2], @pins[4], @pins[5]).output()
        	output[8] = LogicGates::NAND.new(@pins[9], @pins[10], @pins[12], @pins[13]).output()

        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end
	
	class IC_7421
		# 7421 = Dual 4 input AND gate
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[6] = @pins[8] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[6] = LogicGates::AND.new(@pins[1], @pins[2], @pins[4], @pins[5]).output()
        	output[8] = LogicGates::AND.new(@pins[9], @pins[10], @pins[12], @pins[13]).output()

        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end
	
	class IC_7422
		# 7422 = Dual 4-input NAND gates with open-collector outputs
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[6] = @pins[8] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[6] = LogicGates::NAND.new(@pins[1], @pins[2], @pins[4], @pins[5]).output()
        	output[8] = LogicGates::NAND.new(@pins[9], @pins[10], @pins[12], @pins[13]).output()

        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end
	
	
	class IC_7424
		# 7424 = Quad 2-input NAND gates with schmitt-trigger line-receiver inputs
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[3] = @pins[6] = @pins[8] = @pins[11] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[3] = LogicGates::NAND.new(@pins[1], @pins[2]).output()
	        output[6] = LogicGates::NAND.new(@pins[4], @pins[5]).output()
	        output[8] = LogicGates::NAND.new(@pins[9], @pins[10]).output()
	        output[11] = LogicGates::NAND.new(@pins[12], @pins[13]).output()
        	
        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end
	
	class IC_7427
		# 7427 = Triple 3 input NOR gate 
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[6] = @pins[8] = @pins[12] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
	        output[6] = LogicGates::AND.new(@pins[3], @pins[4], @pins[5]).output()
	        output[8] = LogicGates::AND.new(@pins[9], @pins[10], @pins[11]).output()
			output[12] = LogicGates::AND.new(@pins[1], @pins[2], @pins[13]).output()
        	
        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end
	
	class IC_7428
		# 7428 = Quad 2-input NOR gates with buffered outputs
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[1] = @pins[4] = @pins[10] = @pins[13] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[1] = LogicGates::NOR.new(@pins[2], @pins[3]).output()
	        output[4] = LogicGates::NOR.new(@pins[5], @pins[6]).output()
	        output[10] = LogicGates::NOR.new(@pins[8], @pins[9]).output()
	        output[13] = LogicGates::NOR.new(@pins[11], @pins[12]).output()
        	
        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end

	class IC_7430
		# 7430 = 8-input NAND gate
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[8] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[8] = LogicGates::NAND.new(@pins[1], @pins[2], @pins[3], @pins[4], @pins[5], @pins[6], @pins[11], @pins[12]).output()
        	
        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end
	
	class IC_7432
		# 7432 = Quad 2-input OR gate
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[3] = @pins[6] = @pins[8] = @pins[11] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[3] = LogicGates::OR.new(@pins[1], @pins[2]).output()
	        output[6] = LogicGates::OR.new(@pins[4], @pins[5]).output()
	        output[8] = LogicGates::OR.new(@pins[9], @pins[10]).output()
	        output[11] = LogicGates::OR.new(@pins[12], @pins[13]).output()
        	
        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end
	
	class IC_7433
		# 7433 = Quad 2 input open-collector NOR gate
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[1] = @pins[4] = @pins[10] = @pins[13] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[1] = LogicGates::NOR.new(@pins[2], @pins[3]).output()
        	output[4] = LogicGates::NOR.new(@pins[5], @pins[6]).output()
        	output[10] = LogicGates::NOR.new(@pins[8], @pins[9]).output()
        	output[13] = LogicGates::NOR.new(@pins[11], @pins[12]).output()
        	
        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end
	
	class IC_7437
		# 7437 = Quad 2-input NAND gates with buffered outputs
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[3] = @pins[6] = @pins[8] = @pins[11] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[3] = LogicGates::NAND.new(@pins[1], @pins[2]).output()
	        output[6] = LogicGates::NAND.new(@pins[4], @pins[5]).output()
	        output[8] = LogicGates::NAND.new(@pins[9], @pins[10]).output()
	        output[11] = LogicGates::NAND.new(@pins[12], @pins[13]).output()
        	
        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end
	
	class IC_7440
		# 7440 = Dual 4-input NAND buffer
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[6] = @pins[8] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[6] = LogicGates::NAND.new(@pins[1], @pins[2], @pins[4], @pins[5]).output()
        	output[8] = LogicGates::NAND.new(@pins[9], @pins[10], @pins[12], @pins[13]).output()

        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end

	class IC_7470
		# 7470 = AND gated JK positive edge triggered Flip FLop with preset and clear
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[6] = @pins[8] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			j = Connector.new(LogicGates::AND.new(@pins[3], @pins[4], @pins[5]).output())
			k = Connector.new(LogicGates::AND.new(@pins[9], @pins[10], @pins[11]).output())

			if not @pins[12].is_a?(Clock)
            	raise Exception("Error: Invalid Clock Input")
            end

	        ff = FlipFlop::JK.new(j, k, Connector(1), @pins[12].A, @pins[13], @pins[2])
	        
	        while true
	            if @pins[12].clock_connector.state == 0
	                ff.trigger()
	                break
	            end
	        end
	        
	        while true
	            if @pins[12].clock_connector.state == 1
	                ff.trigger()
	                break
	            end
	        end

	        output[8] = ff.state()[0]
	        output[10] = ff.state()[1]

        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end

	class IC_7473
		# 7473 = Dual JK FF with clear
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[8] = @pins[9] = @pins[12] = @pins[13] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			if not (@pins[1].is_a?(Clock) and @pins[5].is_a?(Clock))
            	raise Exception("Error: Invalid Clock Input")
            end

	        ff1 = FlipFlop::JK.new(@pins[14], @pins[3], Connector.new(1), @pins[1].clock_connector, Connector.new(1), @pins[2])
	        
	        while true
	            if self.pins[1].clock_connector.state == 0
	                ff1.trigger()
	                break
	            end
	        end

	        while true
	            if self.pins[1].clock_connector.state == 1
	                ff1.trigger()
	                break
	            end
	        end

	        output[12] = ff1.state()[0]
	        output[13] = ff1.state()[1]

	        ff2 = FlipFlop::JK.new(@pins[7], @pins[10], Connector.new(1), @pins[5].clock_connector, Connector.new(1), @pins[6])
	        while true
	            if self.pins[5].clock_connector.state == 0
	                ff2.trigger()
	                break
	            end
	        end

	        while true
	            if self.pins[5].clock_connector.state == 1
	                ff2.trigger()
	                break
	            end
	        end

	        output[9] = ff2.state()[0]
	        output[8] = ff2.state()[1]

        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end

	class IC_7474
		# 7474 = Dual D-type positive edge triggered FFs with preset and clear
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[5] = @pins[6] = @pins[8] = @pins[9] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			if not (@pins[3].is_a?(Clock) and @pins[11].is_a?(Clock))
            	raise Exception("Error: Invalid Clock Input")
            end

	        ff1 = FlipFlop::D.new(@pins[2], Connector.new(1), @pins[3].clock_connector, @pins[4], @pins[1])
	        
	        while true
	            if @pins[3].clock_connector.state == 0
	                ff1.trigger()
	                break
	            end
	        end

	        while true
	            if @pins[3].clock_connector.state == 1
	                ff1.trigger()
	                break
	            end
	        end

	        output[5] = ff1.state()[0]
	        output[6] = ff1.state()[1]

	        ff2 = FlipFlop::D.new(@pins[12], Connector.new(1), @pins[11].clock_connector, @pins[10], @pins[13])
	        
	        while true
	            if @pins[11].clock_connector.state == 0
	                ff2.trigger()
	                break
	            end
	        end

	        while true
	            if @pins[11].clock_connector.state == 1
	                ff2.trigger()
	                break
	            end
	        end

	        output[9] = ff2.state()[0]
	        output[8] = ff2.state()[1]

        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end
	
	class IC_7486
		# 7486 = Quad 2-input exclusive OR gate
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[3] = @pins[6] = @pins[8] = @pins[11] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			
			output[3] = LogicGates::XOR.new(@pins[1], @pins[2]).output()
			output[6] = LogicGates::XOR.new(@pins[4], @pins[5]).output()
			output[8] = LogicGates::XOR.new(@pins[9], @pins[10]).output()
			output[11] = LogicGates::XOR.new(@pins[12], @pins[13]).output()

        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end
	
	class IC_74152
		# 74152 = 14 pin 8:1 mux with inverted input
		# Pin Configuration
		# 	Pin Number  Description
		#        1   D4
		#        2   D3
		#        3   D2
		#        4   D1
		#        5   D0
		#        6   Output W
		#        7   Ground
		#        8   select line C
		#        9   select line B
		#        10  select line A
		#        11  D7
		#        12  D6
		#        13     D5
		#        14  Positive Supply
		#        select_lines = CBA and Inputlines = D0 D1 D2 D3 D4 D5 D6 D7
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[6] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			
			mux = Combinational::MUX.new(@pins[5], @pins[4], @pins[3], @pins[2], @pins[1], @pins[13], @pins[12], @pins[11])
        	mux.select_lines(@pins[8], @pins[9], @pins[10])

        	output[6] = LogicGates::NOT.new(mux.output()).output()

        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end
	
	class IC_74260
		# 74260 = Dual 5-input NOR gate
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[5] = @pins[6] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			
			output[5] = LogicGates::NOR.new(@pins[1], @pins[2], @pins[3], @pins[12], @pins[13]).output()
	        output[6] = LogicGates::NOR.new(@pins[4], @pins[8], @pins[9], @pins[10], @pins[11]).output()


        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end

	class IC_7459
		# 7459 = 2-input and 3-input AND-OR inverter gate
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[6] = @pins[8] = nil

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			temp = Array.new
			
			temp << (LogicGates::AND.new(@pins[2], @pins[3]).output())
	        temp << (LogicGates::AND.new(@pins[4], @pins[5]).output())
	        temp << (LogicGates::AND.new(@pins[1], @pins[13], @pins[12]).output())
	        temp << (LogicGates::AND.new(@pins[11], @pins[10], @pins[9]).output())
	        
	        output[6] = LogicGates::NOR.new(temp[0], temp[1]).output()
	        output[8] = LogicGates::NOR.new(temp[2], temp[3]).output()


        	if @pins[7] == 0 and @pins[14] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end

	## ICs with 16 pins
	class IC_7431
		# 7431 = Hex delay element
		include Base_16pin

		def initialize
			@pins = Array.new(17, 0)
			@pins[0] = @pins[2] = @pins[4] = @pins[7] = @pins[9] = @pins[12] = @pins[14] = nil

			Base_16pin.set_properties
		end

		def run
			output = Hash.new
			
			output[2] = LogicGates::NOT.new(@pins[1]).output()
	        output[7] = LogicGates::NAND.new(@pins[5], @pins[6]).output()
	        output[14] = LogicGates::NOT.new(@pins[15]).output()
	        output[9] = LogicGates::NAND.new(@pins[10], @pins[11]).output()
	        output[4] = @pins[3]
	        output[12] = @pins[13]

        	if @pins[8] == 0 and @pins[16] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end	
	
	class IC_7442
		# 7442 = BCD to decimal decoder
		include Base_16pin

		def initialize
			@pins = Array.new(17, nil)
			@pins[8] = @pins[12] = @pins[13] = @pins[14] = @pins[15] = @pins[16] = 0
			@invalidlist = [[1, 0, 1, 0], [1, 0, 1, 1], [1, 1, 0, 0], [1, 1, 0, 1], [1, 1, 1, 0], [1, 1, 1, 1]]
			
			Base_16pin.set_properties
		end

		def run
			output = Hash.new
			inputlist = Array.new
	        
	        (12..15).each do |i|
	            inputlist << pins[i]
	        end

	        if @invalidlist.include?(inputlist)
	            raise "ERROR: Invalid BCD number"
	        end

	        output[1] = LogicGates::NAND.new(LogicGates::NOT.new(@pins[15]).output(), LogicGates::NOT.new(@pins[14]).output(), LogicGates::NOT.new(@pins[13]).output(), LogicGates::NOT.new(@pins[12]).output()).output()
	        output[2] = LogicGates::NAND.new(@pins[15], LogicGates::NOT.new(@pins[14]).output(), LogicGates::NOT.new(@pins[13]).output(), LogicGates::NOT.new(@pins[12]).output()).output()
	        output[3] = LogicGates::NAND.new(LogicGates::NOT.new(@pins[15]).output(), @pins[14], LogicGates::NOT.new(@pins[13]).output(), LogicGates::NOT.new(@pins[12]).output()).output()
	        output[4] = LogicGates::NAND.new(@pins[15], @pins[14], LogicGates::NOT.new(@pins[13]).output(), LogicGates::NOT.new(@pins[12]).output()).output()
	        output[5] = LogicGates::NAND.new(LogicGates::NOT.new(@pins[15]).output(), LogicGates::NOT.new(@pins[14]).output(), @pins[13], LogicGates::NOT.new(@pins[12]).output()).output()
	        output[6] = LogicGates::NAND.new(@pins[15], LogicGates::NOT.new(@pins[14]).output(), @pins[13], LogicGates::NOT.new(@pins[12]).output()).output()
	        output[7] = LogicGates::NAND.new(LogicGates::NOT.new(@pins[15]).output(), @pins[14], @pins[13], LogicGates::NOT.new(@pins[12]).output()).output()
	     	output[9] = LogicGates::NAND.new(@pins[15], @pins[14], @pins[13], LogicGates::NOT.new(@pins[12]).output()).output()
	        output[10] = LogicGates::NAND.new(LogicGates::NOT.new(@pins[15]).output(), LogicGates::NOT.new(@pins[14]).output(), LogicGates::NOT.new(@pins[13]).output(), @pins[12]).output()
	        output[11] = LogicGates::NAND.new(@pins[15], LogicGates::NOT.new(@pins[14]).output(), LogicGates::NOT.new(@pins[13]).output(), @pins[12]).output()

        	if @pins[8] == 0 and @pins[16] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end	
	
	class IC_7443
		# 7443 = excess-3 to decimal decoder
		include Base_16pin

		def initialize
			@pins = Array.new(17, nil)
			@pins[8] = @pins[12] = @pins[13] = @pins[14] = @pins[15] = @pins[16] = 0
			@invalidlist = [[0, 0, 0, 0], [0, 0, 0, 1], [0, 0, 1, 0], [1, 1, 0, 1], [1, 1, 1, 0], [1, 1, 1, 1]]
			
			Base_16pin.set_properties
		end

		def run
			output = Hash.new
			inputlist = Array.new
	        
	        (12..15).each do |i|
	            inputlist << pins[i]
	        end

	        if @invalidlist.include?(inputlist)
	            raise "ERROR: Invalid Pin Configuration number"
	        end

	        output[1] = LogicGates::NAND.new(@pins[15], @pins[14], LogicGates::NOT.new(@pins[13]).output(), LogicGates::NOT.new(@pins[12]).output()).output()
	        output[2] = LogicGates::NAND.new(LogicGates::NOT.new(@pins[15]).output(), LogicGates::NOT.new(@pins[14]).output(), @pins[13], LogicGates::NOT.new(@pins[12]).output()).output()
	        output[3] = LogicGates::NAND.new(@pins[15], LogicGates::NOT.new(@pins[14]).output(), @pins[13], LogicGates::NOT.new(@pins[12]).output()).output()
	        output[4] = LogicGates::NAND.new(LogicGates::NOT.new(@pins[15]).output(), @pins[14], @pins[13], LogicGates::NOT.new(@pins[12]).output()).output()
	        output[5] = LogicGates::NAND.new(@pins[15], @pins[14], @pins[13], LogicGates::NOT.new(@pins[12]).output()).output()
	        output[6] = LogicGates::NAND.new(LogicGates::NOT.new(@pins[15]).output(), LogicGates::NOT.new(@pins[14]).output(), LogicGates::NOT.new(@pins[13]).output(), @pins[12]).output()
	        output[7] = LogicGates::NAND.new(@pins[15], LogicGates::NOT.new(@pins[14]).output(), LogicGates::NOT.new(@pins[13]).output(), @pins[12]).output()
	        output[9] = LogicGates::NAND.new(LogicGates::NOT.new(@pins[15]).output(), @pins[14], LogicGates::NOT.new(@pins[13]).output(), @pins[12]).output()
	        output[10] = LogicGates::NAND.new(@pins[15], @pins[14], LogicGates::NOT.new(@pins[13]).output(), @pins[12]).output()
	        output[11] = LogicGates::NAND.new(LogicGates::NOT.new(@pins[15]).output(), LogicGates::NOT.new(@pins[14]).output(), @pins[13], @pins[12]).output()

        	if @pins[8] == 0 and @pins[16] == 1
        		self.set_IC(output)

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end	
	
	class IC_7444
		# 7444 = excess-3 gray code to decimal decoder
		include Base_16pin

		def initialize
			@pins = Array.new(17, nil)
			@pins[8] = @pins[12] = @pins[13] = @pins[14] = @pins[15] = @pins[16] = 0
			@invalidlist = [[0, 0, 0, 0], [0, 0, 0, 1], [0, 0, 1, 1], [1, 0, 0, 0], [1, 0, 0, 1], [1, 0, 1, 1]]
			
			Base_16pin.set_properties
		end

		def run
			output = Hash.new
			inputlist = Array.new
	        
	        (12..15).each do |i|
	            inputlist << pins[i]
	        end

	        if @invalidlist.include?(inputlist)
	            raise "ERROR: Invalid Pin Configuration number"
	        end

	        output[1] = LogicGates::NAND.new(LogicGates::NOT.new(@pins[15]).output(), @pins[14], LogicGates::NOT.new(@pins[13]).output(), LogicGates::NOT.new(@pins[12]).output()).output()
	        output[2] = LogicGates::NAND.new(LogicGates::NOT.new(@pins[15]).output(), @pins[14], @pins[13], LogicGates::NOT.new(@pins[12]).output()).output()
	        output[3] = LogicGates::NAND.new((@pins[15]), @pins[14], @pins[13], LogicGates::NOT.new(@pins[12]).output()).output()
	        output[4] = LogicGates::NAND.new(@pins[15], LogicGates::NOT.new(@pins[14]).output(), @pins[13], LogicGates::NOT.new(@pins[12]).output()).output()
	        output[5] = LogicGates::NAND.new(LogicGates::NOT.new(@pins[15]).output(), LogicGates::NOT.new(@pins[14]).output(), @pins[13], LogicGates::NOT.new(@pins[12]).output()).output()
	        output[6] = LogicGates::NAND.new(LogicGates::NOT.new(@pins[15]).output(), LogicGates::NOT.new(@pins[14]).output(), @pins[13], @pins[12]).output()
	        output[7] = LogicGates::NAND.new(@pins[15], LogicGates::NOT.new(@pins[14]).output(), @pins[13], @pins[12]).output()
	        output[9] = LogicGates::NAND.new(@pins[15], @pins[14], @pins[13], @pins[12]).output()
	        output[10] = LogicGates::NAND.new(LogicGates::NOT.new(@pins[15]).output(), @pins[14], @pins[13], @pins[12]).output()
	        output[11] = LogicGates::NAND.new(LogicGates::NOT.new(@pins[15]).output(), @pins[14], LogicGates::NOT.new(@pins[13]).output(), @pins[12]).output()

        	if @pins[8] == 0 and @pins[16] == 1
        		self.set_IC(output) 

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end	
	
	class IC_7445
		# 7445 = BCD to decimal decoder
		include Base_16pin

		def initialize
			@pins = Array.new(17, nil)
			@pins[8] = @pins[12] = @pins[13] = @pins[14] = @pins[15] = @pins[16] = 0
			@invalidlist = [[1, 0, 1, 0], [1, 0, 1, 1], [1, 1, 0, 0], [1, 1, 0, 1], [1, 1, 1, 0], [1, 1, 1, 1]]
			
			Base_16pin.set_properties
		end

		def run
			output = Hash.new
			inputlist = Array.new
	        
	        (12..15).each do |i|
	            inputlist << pins[i]
	        end

	        if @invalidlist.include?(inputlist)
	            raise "ERROR: Invalid Pin Configuration number"
	        end

	        dem = Combinational::DEMUX.new(1)
	        dem.select_lines(@pins[12], @pins[13], @pins[14], @pins[15])
	        ou = dem.output()

	        output[1] = LogicGates::NOT.new(ou[0]).output()
	        output[2] = LogicGates::NOT.new(ou[1]).output()
	        output[3] = LogicGates::NOT.new(ou[2]).output()
	        output[4] = LogicGates::NOT.new(ou[3]).output()
	        output[5] = LogicGates::NOT.new(ou[4]).output()
	        output[6] = LogicGates::NOT.new(ou[5]).output()
	        output[7] = LogicGates::NOT.new(ou[6]).output()
	        output[9] = LogicGates::NOT.new(ou[7]).output()
	        output[10] = LogicGates::NOT.new(ou[8]).output()
	        output[11] = LogicGates::NOT.new(ou[9]).output()

        	if @pins[8] == 0 and @pins[16] == 1
        		self.set_IC(output) 

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end	
	
	class IC_7447
		# 7447 = BCD to 7 segment decoder
		include Base_16pin

		def initialize
			@pins = Array.new(17, 0)
			@pins[0] = @pins[9] = @pins[10] = @pins[11] = @pins[12] = @pins[13] = @pins[14] = @pins[15] = nil
			@pins[16] = 1
			@invalidlist = [[1, 0, 1, 0], [1, 0, 1, 1], [1, 1, 0, 0], [1, 1, 0, 1], [1, 1, 1, 0], [1, 1, 1, 1]]
			
			Base_16pin.set_properties
		end

		def run
			output = Hash.new
			inputlist = Array.new
	        
	        (12..15).each do |i|
	            inputlist << pins[i]
	        end

	        if @invalidlist.include?(inputlist)
	            raise "ERROR: Invalid Pin Configuration number"
	        end

	        output[13] = LogicGates::OR.new(LogicGates::AND.new(@pins[2], LogicGates::NOT.new(@pins[7]).output()).output(), \
	        	(LogicGates::AND.new(LogicGates::NOT.new(@pins[6]).output(), LogicGates::NOT.new(@pins[2]).output(), LogicGates::NOT.new(@pins[1]).output(), @pins[7]).output())).output()
	        output[12] = LogicGates::AND.new(@pins[2], LogicGates::XOR.new(@pins[1], @pins[7]).output()).output()
	        output[11] = LogicGates::AND.new(LogicGates::NOT.new(@pins[2]).output(), @pins[1], LogicGates::NOT.new(@pins[7]).output()).output()
	        output[10] = LogicGates::OR.new(LogicGates::AND.new(@pins[2], LogicGates::NOT.new(@pins[1]).output(), \
	        	LogicGates::NOT.new(@pins[7]).output()).output(), LogicGates::AND.new(@pins[2], @pins[1], @pins[7]).output(), LogicGates::AND.new(LogicGates::NOT.new(@pins[2]).output(), LogicGates::NOT.new(@pins[1]).output(), @pins[7]).output()).output()
	        output[9] = LogicGates::OR.new(@pins[7], LogicGates::AND.new(@pins[2], LogicGates::NOT.new(@pins[1]).output()).output()).output()
	        output[14] = LogicGates::OR.new(LogicGates::AND.new(LogicGates::NOT.new(@pins[6]).output(), LogicGates::NOT.new(@pins[2]).output(), \
	        	LogicGates::NOT.new(@pins[1]).output()).output(), LogicGates::AND.new(@pins[2], @pins[1], @pins[6]).output()).output()
	        output[15] = LogicGates::OR.new(LogicGates::AND.new(@pins[1], @pins[7]).output(), LogicGates::AND.new(LogicGates::NOT.new(@pins[2]).output(), @pins[1]).output(), \
	        	LogicGates::AND.new(LogicGates::NOT.new(@pins[6]).output(), LogicGates::NOT.new(@pins[2]).output(), @pins[7]).output()).output()

        	if @pins[8] == 0 and @pins[16] == 1 and (@pins[3] == 0 and @pins[4] == 0 and @pins[5] == 0)
        		self.set_IC(output) 

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end	
	
	class IC_7485
		# 7485 = 4-bit magnitude comparator
		# Pin Configuration 
		# Comparing two 4-bit binary numbers A3A2A1A0 & B3B2B1B0
		#    Pin Number  Description
		#    1   B3(MSB)
		#    2   Cascade Input - A<B
		#    3   Cascade Input - A=B
		#    4   Cascade Input - A>B
		#    5   Output A>B
		#    6   Output A=B
		#    7   Output A<B
		#    8   Ground
		#    9   B0
		#    10  A0
		#    11  B1
		#    12  A1
		#    13  A2
		#    14  B2
		#    15  A3(MSB)
		#    16  VCC

		include Base_16pin

		def initialize
			@pins = Array.new(17, 0)
			@pins[0] = @pins[9] = @pins[10] = @pins[11] = @pins[12] = @pins[13] = @pins[14] = @pins[15] = nil
			@pins[16] = 1
			@invalidlist = [[1, 0, 1, 0], [1, 0, 1, 1], [1, 1, 0, 0], [1, 1, 0, 1], [1, 1, 1, 0], [1, 1, 1, 1]]
			
			Base_16pin.set_properties
		end

		def run
			output = Hash.new
			temp = Array.new
	        
	        temp << (XOR(self.pins[10], self.pins[9]).output())
	        temp << (XOR(self.pins[12], self.pins[11]).output())
	        temp << (XOR(self.pins[14], self.pins[13]).output())
	        temp << (XOR(self.pins[15], self.pins[1]).output())

	        output[6] = AND(temp[0], temp[1], temp[2], temp[3], self.pins[3]).output()

	        output[5] = OR(AND(temp[0], temp[1], temp[2], temp[3], self.pins[4]).output(), AND(temp[2], temp[3], self.pins[12], NOT(self.pins[11]).output()).output(), AND(temp[1], temp[2], temp[3], self.pins[10], NOT(self.pins[9]).output()).output(), AND(temp[3], self.pins[13], NOT(self.pins[14]).output()).output(), AND(self.pins[15], NOT(self.pins[1]).output()).output()).output()

	        output[7] = OR(AND(temp[0], temp[1], temp[2], temp[3], self.pins[2]).output(), AND(temp[2], temp[3], self.pins[11], NOT(self.pins[12]).output()).output(), AND(temp[1], temp[2], temp[3], self.pins[9], NOT(self.pins[10]).output()).output(), AND(temp[3], self.pins[14], NOT(self.pins[13]).output()).output(), AND(self.pins[1], NOT(self.pins[15]).output()).output()).output()

        	if @pins[8] == 0 and @pins[16] == 1
        		self.set_IC(output) 

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end
	
	class IC_7475
		# 7475 = 4-bit bistable latches
		include Base_16pin

		def initialize
			@pins = Array.new(17, nil)
			@pins[2] = @pins[3] = @pins[4] = @pins[5] = @pins[6] = @pins[7] = @pins[13] = @pins[14] = 0
			
			Base_16pin.set_properties
		end

		def run
			output = Hash.new
			
			if not (@pins[4].is_a?(Clock) and @pins[13].is_a?(Clock))
	        	raise Exception("Error: Invalid Clock Input")
	        end
	        
	        ff1 = FlipFlop::D.new(@pins[2], Connector.new(1), @pins[13].clock_connector, Connector.new(1), Connector.new(1))
	        
	        while true
	            if @pins[13].clock_connector.state == 0
	                ff1.trigger()
	                break
	            end
	        end

	        while true
	            if @pins[13].clock_connector.state == 1
	                ff1.trigger()
	                break
	            end
	        end

	        output[16] = ff1.state()[0]
	        output[1] = ff1.state()[1]

	        ff2 = FlipFlop::D.new(@pins[3], Connector.new(1), @pins[13].clock_connector, Connector.new(1), Connector.new(1))
	        
	        while true
	            if @pins[13].clock_connector.state == 0
	                ff2.trigger()
	                break
	            end
	        end

	        while true
	            if @pins[13].clock_connector.state == 1
	                ff2.trigger()
	                break
	            end
	        end

	        output[15] = ff2.state()[0]
	        output[14] = ff2.state()[1]

	        ff3 = FlipFlop::D.new(@pins[6], Connector.new(1), @pins[4].clock_connector, Connector.new(1), Connector.new(1))
	        
	        while true
	            if @pins[4].clock_connector.state == 0
	                ff3.trigger()
	                break
	            end
	        end
	        
	        while true
	            if @pins[4].clock_connector.state == 1
	                ff3.trigger()
	                break
	            end
	        end

	        output[10] = ff3.state()[0]
	        output[11] = ff3.state()[1]

	        ff4 = FlipFlop::D.new(@pins[7], Connector.new(1), @pins[4].clock_connector, Connector.new(1), Connector.new(1))
	        
	        while true
	            if self.pins[4].clock_connector.state == 0
	                ff4.trigger()
	                break
	            end
	        end

	        while true
	            if self.pins[4].clock_connector.state == 1
	                ff4.trigger()
	                break
	            end
	        end

	        output[9] = ff4.state()[0]
	        output[8] = ff4.state()[1]
	        
        	if @pins[12] == 0 and @pins[5] == 1
        		self.set_IC(output) 

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end
	
	class IC_7476
		# 7476 = Dual JK FF with preset and clear
		include Base_16pin

		def initialize
			@pins = Array.new(17, 0)
			@pins[0] = @pins[10] = @pins[11] = @pins[14] = @pins[15] = nil
			
			Base_16pin.set_properties
		end

		def run
			output = Hash.new
			
			if not (@pins[1].is_a?(Clock) and @pins[6].is_a?(Clock))
	            raise Exception("Error: Invalid Clock Input")
	        end

	        ff1 = FlipFlop::JK.new(@pins[4], @pins[16], Connector.new(1), @pins[1].clock_connector, @pins[2], @pins[3])
	        
	        while true
	            if @pins[1].clock_connector.state == 0
	                ff1.trigger()
	                break
	            end
	        end

	        while true
	            if @pins[1].clock_connector.state == 1
	                ff1.trigger()
	                break
	            end
	        end

	        output[15] = ff1.state()[0]
	        output[14] = ff1.state()[1]

	        ff2 = FlipFlop::JK.new(@pins[9], @pins[12], Connector.new(1), @pins[6].clock_connector, @pins[7], @pins[8])
	        
	        while true
	            if @pins[6].clock_connector.state == 0
	                ff2.trigger()
	                break
	            end
	        end
	        
	        while true
	            if @pins[6].clock_connector.state == 1
	                ff2.trigger()
	                break
	            end
	        end

	        output[11] = ff2.state()[0]
	        output[10] = ff2.state()[1]
	     
        	if @pins[12] == 0 and @pins[5] == 1
        		self.set_IC(output) 

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end
	
	class IC_7483
		# 7483 = 4-bit full adder with fast carry
		include Base_16pin

		def initialize
			@pins = Array.new(17, 0)
			@pins[0] = @pins[2] = @pins[6] = @pins[9] = @pins[14] = @pins[15] = nil
			
			Base_16pin.set_properties
		end

		def run
			output = Hash.new
			
			output[9] = LogicGates::XOR.new(@pins[10], @pins[11], @pins[13]).output()

	        carry = LogicGates::OR.new(LogicGates::AND.new(@pins[13], LogicGates::XOR.new(@pins[10], @pins[11]).output()).output(), LogicGates::AND.new(@pins[10], @pins[11]).output()).output()
	        output[6] = LogicGates::XOR.new(@pins[8], @pins[7], carry).output()

	        carry = LogicGates::OR.new(LogicGates::AND.new(carry, LogicGates::XOR.new(@pins[8], @pins[7]).output()).output(), LogicGates::AND.new(@pins[8], @pins[7]).output()).output()
	        output[2] = LogicGates::XOR.new(@pins[3], @pins[4], carry).output()

	        carry = LogicGates::OR.new(LogicGates::AND.new(carry, LogicGates::XOR.new(@pins[3], @pins[4]).output()).output(), LogicGates::AND.new(@pins[3], @pins[4]).output()).output()
	        output[15] = LogicGates::XOR.new(@pins[1], @pins[16], carry).output()

	        output[14] = LogicGates::OR.new(LogicGates::AND.new(carry, LogicGates::XOR.new(@pins[1], @pins[16]).output()).output(), LogicGates::AND.new(@pins[1], @pins[16]).output()).output()
	     
        	if @pins[12] == 0 and @pins[5] == 1
        		self.set_IC(output) 

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end

	class IC_74133
		# 74133 = 13-input NAND gate
		include Base_16pin

		def initialize
			@pins = Array.new(17, 0)
			@pins[0] = @pins[9] = nil
			
			Base_16pin.set_properties
		end

		def run
			output = Hash.new
			
			output[9] = LogicGates::NAND.new(@pins[1], @pins[2], @pins[3], @pins[4], @pins[5], @pins[6], @pins[7], @pins[10], @pins[11], @pins[12], @pins[13], @pins[14], @pins[15]).output()
	     
        	if @pins[8] == 0 and @pins[16] == 1
        		self.set_IC(output) 

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end

	## Ics with 24 pins
	
	class IC_74181
		# 74181 = 4-bit arithmetic logic unit with performs 16 different functions
		# Pin configuration
		#	Pin Number  Description
		#        1       Input - B0
		#        2       Input - A0
		#        3       Input - Select Line - S3
		#        4       Input - Select Line - S2
		#        5       Input - Select Line - S1
		#        6       Input - Select Line - S0
		#        7       Input - Carry
		#        8       Input - Mode Input(M)
		#        9       Output- F0
		#        10      Output- F1
		#        11      Output- F2
		#        12      Ground
		#        13      Output- F3
		#        14      Output- A=B
		#        15      Output- P
		#        16      Output- NOT(C(n+4))
		#        17      Output- G
		#        18      Input - B3
		#        19      Input - A3
		#        20      Input - B2
		#        21      Input - A2
		#        22      Input - B1
		#        23      Input - A1
		#        24      VCC
		#        Mode and Select Lines are used to select the function to be performed by the ALU on
	    #    the two 4-bit input data A3 A2 A1 A0 & B3 B2 B1 B0(Inputs A0-A3 and
	    #    B0-B3 have to be complemented and given).
		include Base_24pin

		def initialize
			@pins = Array.new(25, 0)
			@pins[0] = @pins[9] = @pins[10] = @pins[11] = @pins[13] = @pins[14] = @pins[15] = @pins[16] = @pins[17] = nil
			
			Base_24pin.set_properties
		end

		def run
			output = Hash.new
			temp = Array.new

			temp << (LogicGates::NOT.new(LogicGates::OR.new(LogicGates::AND.new(@pins[1], @pins[3], @pins[2]).output(), LogicGates::AND.new(@pins[2], @pins[4], \
				LogicGates::NOT.new(@pins[1]).output()).output()).output()).output())

        	temp << (LogicGates::NOT.new(LogicGates::OR.new(LogicGates::AND.new(LogicGates::NOT.new(@pins[1]).output(), @pins[5]).output(), \
        		LogicGates::AND.new(@pins[6], @pins[1]).output(), @pins[2]).output()).output())

	        temp << (LogicGates::NOT.new(LogicGates::OR.new(LogicGates::AND.new(@pins[22], @pins[3], @pins[23]).output(), LogicGates::AND.new(@pins[23], @pins[4], \
	        	LogicGates::NOT.new(@pins[22]).output()).output()).output()).output())

	        temp << (LogicGates::NOT.new(LogicGates::OR.new(LogicGates::AND.new(LogicGates::NOT.new(@pins[22]).output(), @pins[5]).output(), LogicGates::AND.new(@pins[6], @pins[22]).output(), @pins[23]).output()).output())

	        temp << (LogicGates::NOT.new(LogicGates::OR.new(LogicGates::AND.new(@pins[20], @pins[3], @pins[21]).output(), LogicGates::AND.new(@pins[21], @pins[4], \
	        	LogicGates::NOT.new(@pins[20]).output()).output()).output()).output())

	        temp << (LogicGates::NOT.new(LogicGates::OR.new(LogicGates::AND.new(LogicGates::NOT.new(@pins[20]).output(), @pins[5]).output(), LogicGates::AND.new(@pins[6], @pins[20]).output(), @pins[21]).output()).output())

	        temp << (LogicGates::NOT.new(LogicGates::OR.new(LogicGates::AND.new(@pins[18], @pins[3], @pins[19]).output(), LogicGates::AND.new(@pins[19], @pins[4], LogicGates::NOT.new(@pins[18]).output()).output()).output()).output())

	        temp << (LogicGates::NOT.new(LogicGates::OR.new(LogicGates::AND.new(LogicGates::NOT.new(@pins[18]).output(), @pins[5]).output(), LogicGates::AND.new(@pins[6], @pins[18]).output(), @pins[19]).output()).output())

	        output[9] = LogicGates::XOR.new(LogicGates::NAND.new(@pins[7], LogicGates::NOT.new(@pins[8]).output()).output(), LogicGates::XOR.new(temp[1], temp[0]).output()).output()

	        output[10] = LogicGates::XOR.new(LogicGates::XOR.new(temp[2], temp[3]).output(), LogicGates::NOT.new(LogicGates::OR.new(LogicGates::AND.new(@pins[7], LogicGates::NOT.new(@pins[8]).output()).output(), \
	        	LogicGates::AND.new(LogicGates::NOT.new(@pins[8]).output(), temp[1]).output()).output()).output()).output()

	        output[11] = LogicGates::XOR.new(LogicGates::XOR.new(temp[4], temp[5]).output(), LogicGates::NOT.new(LogicGates::OR.new(LogicGates::AND.new(@pins[7], temp[0], temp[2], LogicGates::NOT.new(@pins[8]).output()).output(), \
	        	LogicGates::AND.new(temp[2], temp[1], LogicGates::NOT.new(@pins[8]).output()).output(), LogicGates::AND.new(temp[3], LogicGates::NOT.new(@pins[8]).output()).output()).output()).output()).output()

	        output[13] = LogicGates::XOR.new(LogicGates::XOR.new(temp[6], temp[7]).output(), LogicGates::NOT.new(LogicGates::OR.new(LogicGates::AND.new(@pins[7], temp[0], temp[2], temp[4], LogicGates::NOT.new(@pins[8]).output()).output(), \
	        	LogicGates::AND.new(temp[2], temp[4], LogicGates::NOT.new(@pins[8]).output(), temp[1]).output(), LogicGates::AND.new(LogicGates::NOT.new(@pins[8]).output(), temp[3], temp[4]).output(), \
	        	LogicGates::AND.new(LogicGates::NOT.new(@pins[8]).output(), temp[5]).output()).output()).output()).output()

	        output[14] = LogicGates::AND.new(output[9], output[10], output[11], output[13]).output()

	        output[15] = LogicGates::NAND.new(temp[0], temp[2], temp[4], temp[6]).output()

	        output[17] = LogicGates::NOT.new(LogicGates::OR.new(temp[7], LogicGates::AND.new(temp[6], temp[5]).output(), LogicGates::AND.new(temp[6], temp[4], temp[3]).output(), LogicGates::AND.new(temp[6], temp[4], temp[2], temp[1]).output()).output()).output()

	        output[16] = LogicGates::OR.new(LogicGates::NOT.new(output[17]).output(), LogicGates::AND.new(@pins[7], temp[0], temp[2], temp[4], temp[6]).output()).output()
	     
        	if @pins[12] == 0 and @pins[24] == 1
        		self.set_IC(output) 

        		@output_connector.each_key do |pin|
					@output_connector[pin].state = output[pin]
				end

				return output
			else
				print("Ground and Vcc pins have been incorrectly configured.")
			end
		end
	end
end
