require_relative '../design/structure'
require_relative '../design/base_14pin'
require_relative '../design/base_16pin'
# require [connectors, gates, ic.basgit e, combinational, sequential, and clock]

# This module contains all classes for 4000 series
# length of pins used in programming is one more than actual number of pins
# as pin0 is not used

# 4000 series ICs in this module

# ICs with 14 pins
# 4001 = Quad 2 input NOR gate
# 4002 = Dual 4 input NOR gate
# 4011 = Quad 2 input NAND gate
# 4012 = Dual 4 input NAND gate
# 4013 = CMOS Dual D type FF
# 4030 = Quad 2 input XOR gate
# 4068 = 8 input NAND gate
# 4069 = Hex NOT gate
# 4070 = Quad 2 input XOR gate
# 4071 = Quad 2 input OR gate
# 4072 = Dual 4 input OR gate
# 4077 = Quad 2 input XNOR gate
# 4078 = 8 input NOR gate
# 4081 = Quad 2 input AND gate
# 4082 = Dual 4 input AND gate

# ICs with 16 pins
# 4008 = 4 bit binary full adder
# 4015 = Dual 4 stage static shift register
# 4017 = CMOS Counter
# 4019 = 8 to 4 line non-inverting MUX with OR gate
# 4022 = Octal counter
# 4027 = Dual JK FF with set and reset
# 4028 = BCD to decimal decoder

module Series4000

	### ICs with 14 pins ###
	class IC_4001
		# 4001 = Quad 2 input NOR gate
		# Pin_3 = NOR(Pin_1, Pin_2)
		# Pin_4 = NOR(Pin_5, Pin_6)
		# Pin_10 = NOR(Pin_8, Pin_9)
		# Pin_11 = NOR(Pin_12, Pin_13)
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = nil

			@pins = Pin.to_pin(@pins)
			@uses_pin_class = true

			self.set_IC(
				{   1 => {'desc' => 'A1: Input 1 of NOR gate 1'},
                 	2 => {'desc' => 'B1: Input 2 of NOR gate 1'},
                 	3 => {'desc' => 'Q1: Output of NOR gate 1'},
                    4 => {'desc' => 'Q2: Output of NOR gate 2'},
                    5 => {'desc' => 'B2: Input 2 of NOR gate 2'},
                    6 => {'desc' => 'A2: Input 1 of NOR gate 2'},
                    7 => {'desc' => 'GND'},
                    8 => {'desc' => 'A3: Input 1 of NOR gate 3'},
                    9 => {'desc' => 'B3: Input 2 of NOR gate 3'},
                    10 => {'desc' => 'Q3: Output of NOR gate 3'},
                    11 => {'desc' => 'Q4: Output of NOR gate 4'},
                    12 => {'desc' => 'B4: Input 2 of NOR gate 4'},
                    13 => {'desc' => 'A4: Input 1 of NOR gate 4'},
                    14 => {'desc' => 'VCC'}
             	})

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[3] = LogicGates::NOR.new(@pins[1].value, @pins[2].value).output()
			output[4] = LogicGates::NOR.new(@pins[5].value, @pins[6].value).output()
			output[10] = LogicGates::NOR.new(@pins[8].value, @pins[9].value).output()
			output[11] = LogicGates::NOR.new(@pins[12].value, @pins[13].value).output()

			if @pins[7].value == 0 and @pins[14].value == 1
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

	class IC_4002
		# 4002 = Dual 4 input NOR gate
		# Pin_1 = NOR(Pin_2, Pin_3, Pin_4, Pin_5)
		# Pin_13 = NOR(Pin_9, Pin_10, Pin_11, Pin_12)
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[6] = @pins[8] = nil
		
			@pins = Pin.to_pin(@pins)
			@uses_pin_class = true

			self.set_IC(
				{ 	1 => {'desc' => 'Q1: Output of NOR gate 1'},
                    2 => {'desc' => 'A1: Input 1 of NOR gate 1'},
                    3 => {'desc' => 'B1: Input 2 of NOR gate 1'},
                    4 => {'desc' => 'C1: Input 3 of NOR gate 1'},
                    5 => {'desc' => 'D1: Input 4 of NOR gate 1'},
                    6 => {'desc' => 'NC'},
                    7 => {'desc' => 'GND'},
                    8 => {'desc' => 'NC'},
                    9 => {'desc' => 'D2: Input 4 of NOR gate 2'},
                    10 => {'desc' => 'C2: Input 3 of NOR gate 2'},
                    11 => {'desc' => 'B2: Input 2 of NOR gate 2'},
                    12 => {'desc' => 'A2: Input 1 of NOR gate 2'},
                    13 => {'desc' => 'Q2: Output of NOR gate 2'},
                    14 => {'desc' => 'VCC'}
                })

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[1] = LogicGates::NOR.new(@pins[2].value, @pins[3].value, @pins[4].value, @pins[5].value).output()
			output[13] = LogicGates::NOR.new(@pins[9].value, @pins[10].value, @pins[11].value, @pins[12].value).output()

			if @pins[7].value == 0 and @pins[14].value == 1
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

	class IC_4011
		# 4011 = Quad 2 input NAND gate
		# Pin_3 = NAND(Pin_1, Pin_2)
		# Pin_4 = NAND(Pin_5, Pin_6)
		# Pin_10 = NAND(Pin_8, Pin_9)
		# Pin_11 = NAND(Pin_12, Pin_13)
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = nil
			
			@pins = Pin.to_pin(@pins)
			@uses_pin_class = true

			self.set_IC(
				{   1 => {'desc' => 'A1: Input 1 of NAND gate 1'},
                    2 => {'desc' => 'B1: Input 2 of NAND gate 1'},
                    3 => {'desc' => 'Q1: Output of NAND gate 1'},
                    4 => {'desc' => 'Q2: Output of NAND gate 2'},
                    5 => {'desc' => 'B2: Input 2 of NAND gate 2'},
                    6 => {'desc' => 'A2: Input 1 of NAND gate 2'},
                    7 => {'desc' => 'GND'},
                    8 => {'desc' => 'A3: Input 1 of NAND gate 3'},
                    9 => {'desc' => 'B3: Input 2 of NAND gate 3'},
                    10 => {'desc' => 'Q3: Output of NAND gate 3'},
                    11 => {'desc' => 'Q4: Output of NAND gate 4'},
                    12 => {'desc' => 'B4: Input 2 of NAND gate 4'},
                    13 => {'desc' => 'A4: Input 1 of NAND gate 4'},
                    14 => {'desc' => 'VCC'}
                })

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[3] = LogicGates::NAND.new(@pins[1].value, @pins[2].value).output()
			output[4] = LogicGates::NAND.new(@pins[5].value, @pins[6].value).output()
			output[10] = LogicGates::NAND.new(@pins[8].value, @pins[9].value).output()
			output[11] = LogicGates::NAND.new(@pins[12].value, @pins[13].value).output()

			if @pins[7].value == 0 and @pins[14].value == 1
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

	class IC_4012
		# 4012 = Dual 4 input NAND gate
		# Pin_1 = NOR(Pin_2, Pin_3, Pin_4, Pin_5)
		# Pin_13 = NOR(Pin_9, Pin_10, Pin_11, Pin_12)
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[6] = @pins[8] = nil
			
			@pins = Pin.to_pin(@pins)
			@uses_pin_class = true

			self.set_IC(
				{ 	1 => {'desc' => 'Q1: Output of NAND gate 1'},
                    2 => {'desc' => 'A1: Input 1 of NAND gate 1'},
                    3 => {'desc' => 'B1: Input 2 of NAND gate 1'},
                    4 => {'desc' => 'C1: Input 3 of NAND gate 1'},
                    5 => {'desc' => 'D1: Input 4 of NAND gate 1'},
                    6 => {'desc' => 'NC'},
                    7 => {'desc' => 'GND'},
                    8 => {'desc' => 'NC'},
                    9 => {'desc' => 'D2: Input 4 of NAND gate 2'},
                    10 => {'desc' => 'C2: Input 3 of NAND gate 2'},
                    11 => {'desc' => 'B2: Input 2 of NAND gate 2'},
                    12 => {'desc' => 'A2: Input 1 of NAND gate 2'},
                    13 => {'desc' => 'Q2: Output of NAND gate 2'},
                    14 => {'desc' => 'VCC'}
                })

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[1] = LogicGates::NAND.new(@pins[2].value, @pins[3].value, @pins[4].value, @pins[5].value).output()
			output[13] = LogicGates::NAND.new(@pins[9].value, @pins[10].value, @pins[11].value, @pins[12].value).output()

			if @pins[7].value == 0 and @pins[14].value == 1
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

	class IC_4013
		# 4013 = CMOS Dual D type FF
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[1] = @pins[2] = nil
			@pins[14] = 1
			
			@pins = Pin.to_pin(@pins)
			@uses_pin_class = false

			self.set_IC(
				{ 	1 => {'desc' => 'Q1'},
                    2 => {'desc' => '~Q1'},
                    3 => {'desc' => 'CLK1'},
                    4 => {'desc' => 'RST1'},
                    5 => {'desc' => 'D1'},
                    6 => {'desc' => 'SET1'},
                    7 => {'desc' => 'GND'},
                    8 => {'desc' => 'SET2'},
                    9 => {'desc' => 'D2'},
                    10 => {'desc' => 'RST2'},
                    11 => {'desc' => 'CLK2'},
                    12 => {'desc' => '~Q2'},
                    13 => {'desc' => 'Q2'},
                    14 => {'desc' => 'VCC'}
                })

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			if not (@pins[3].is_a?(Clock) and @pins[11].is_a?(Clock))
				raise "Invalid Clock Input"
			end

			ff1 = FlipFlop::D.new(@pins[5], Connector.new(1), @pins[3].clock_connector, preset=@pins[6], clear=@pins[4])

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

			output[1] = ff1.state()[0]
			output[2] = ff1.state()[1]

			ff2 = FlipFlop::D.new(@pins[9], Connector.new(1), @pins[11].clock_connector, preset=@pins[8], clear=@pins[10])

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

			output[13] = ff1.state()[0]
			output[12] = ff1.state()[1]

			if @pins[7].value == 0 and @pins[14].value == 1
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

	class IC_4030
		# 4030 = Quad 2 input XOR gate
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = nil
			
			@pins = Pin.to_pin(@pins)
			@uses_pin_class = true

			self.set_IC(
				{ 	1 => {'desc' => '1A'},
                    2 => {'desc' => '1B'},
                    3 => {'desc' => '1Y'},
                    4 => {'desc' => '2Y'},
                    5 => {'desc' => '2A'},
                    6 => {'desc' => '2B'},
                    7 => {'desc' => 'GND'},
                    8 => {'desc' => '3A'},
                    9 => {'desc' => '3B'},
                    10 => {'desc' => '3Y'},
                    11 => {'desc' => '4Y'},
                    12 => {'desc' => '4A'},
                    13 => {'desc' => '4B'},
                    14 => {'desc' => 'VCC'}
                })

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[3] = LogicGates::XOR.new(@pins[1].value, @pins[2].value).output()
			output[4] = LogicGates::XOR.new(@pins[5].value, @pins[6].value).output()
			output[10] = LogicGates::XOR.new(@pins[8].value, @pins[9].value).output()
			output[11] = LogicGates::XOR.new(@pins[12].value, @pins[13].value).output()

			if @pins[7].value == 0 and @pins[14].value == 1
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

	class IC_4068
		# 4068 = 8 input NAND gate
		# Pin_13 = NOR(Pin_2, Pin_3, Pin_4, Pin_5, Pin_9, Pin_10, Pin_11, Pin_12)
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[1] = @pins[6] = @pins[8] = nil
			
			@pins = Pin.to_pin(@pins)
			@uses_pin_class = true

			self.set_IC(
				{ 	1 => {'desc' => 'NC'},
                    2 => {'desc' => 'Input 1 of NAND gate'},
                    3 => {'desc' => 'Input 2 of NAND gate'},
                    4 => {'desc' => 'Input 3 of NAND gate'},
                    5 => {'desc' => 'Input 4 of NAND gate'},
                    6 => {'desc' => 'NC'},
                    7 => {'desc' => 'GND'},
                    8 => {'desc' => 'NC'},
                    9 => {'desc' => 'Input 5 of NAND gate'},
                    10 => {'desc' => 'Input 6 of NAND gate'},
                    11 => {'desc' => 'Input 7 of NAND gate'},
                    12 => {'desc' => 'Input 8 of NAND gate'},
                    13 => {'desc' => 'Output of NAND gate'},
                    14 => {'desc' => 'VCC'}
                })

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[13] = LogicGates::NAND.new(@pins[2].value, @pins[3].value, @pins[4].value, @pins[5].value, @pins[9].value, @pins[10].value, @pins[11].value, @pins[12].value).output()

			if @pins[7].value == 0 and @pins[14].value == 1
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

	class IC_4069
		# 4069 = 8 input NAND gate
		# Pin_2 = NOT(Pin_1)
		# Pin_4 = NOT(Pin_3)
		# Pin_6 = NOT(Pin_5)
		# Pin_8 = NOT(Pin_9)
		# Pin_10 = NOT(Pin_11)
		# Pin_12 = NOT(Pin_13)
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = nil
			
			@pins = Pin.to_pin(@pins)
			@uses_pin_class = true

			self.set_IC(
				{ 	1 => {'desc' => 'Input of NOT gate 1'},
                    2 => {'desc' => 'Output of NOT gate 1'},
                    3 => {'desc' => 'Input of NOT gate 2'},
                    4 => {'desc' => 'Output of NOT gate 2'},
                    5 => {'desc' => 'Input of NOT gate 3'},
                    6 => {'desc' => 'Output of NOT gate 3'},
                    7 => {'desc' => 'GND'},
                    8 => {'desc' => 'Output of NOT gate 4'},
                    9 => {'desc' => 'Input of NOT gate 4'},
                    10 => {'desc' => 'Output of NOT gate 5'},
                    11 => {'desc' => 'Input of NOT gate 5'},
                    12 => {'desc' => 'Output of NOT gate 6'},
                    13 => {'desc' => 'Input of NOT gate 6'},
                    14 => {'desc' => 'VCC'}
                })

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[2] = LogicGates::NOT.new(@pins[1].value).output()
			output[4] = LogicGates::NOT.new(@pins[3].value).output()
			output[6] = LogicGates::NOT.new(@pins[5].value).output()
			output[8] = LogicGates::NOT.new(@pins[9].value).output()
			output[10] = LogicGates::NOT.new(@pins[11].value).output()
			output[12] = LogicGates::NOT.new(@pins[13].value).output()

			if @pins[7].value == 0 and @pins[14].value == 1
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

	class IC_4070
		# 4070 = Quad 2 input XOR gate
		# Pin_3 = XOR(Pin_1, Pin_2)
    	# Pin_4 = XOR(Pin_5, Pin_6)
    	# Pin_10 = XOR(Pin_8, Pin_9)
    	# Pin_11 = XOR(Pin_12, Pin_13)
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = nil
			
			@pins = Pin.to_pin(@pins)
			@uses_pin_class = true

			self.set_IC(
				{ 	1 => {'desc' => 'A1: Input 1 of XOR gate 1'},
                    2 => {'desc' => 'B1: Input 2 of XOR gate 1'},
                    3 => {'desc' => 'Q1: Output of XOR gate 1'},
                    4 => {'desc' => 'Q2: Output of XOR gate 2'},
                    5 => {'desc' => 'B2: Input 2 of XOR gate 2'},
                    6 => {'desc' => 'A2: Input 1 of XOR gate 2'},
                    7 => {'desc' => 'GND'},
                    8 => {'desc' => 'A3: Input 1 of XOR gate 3'},
                    9 => {'desc' => 'B3: Input 2 of XOR gate 3'},
                    10 => {'desc' => 'Q3: Output of XOR gate 3'},
                    11 => {'desc' => 'Q4: Output of XOR gate 4'},
                    12 => {'desc' => 'B4: Input 2 of XOR gate 4'},
                    13 => {'desc' => 'A4: Input 1 of XOR gate 4'},
                    14 => {'desc' => 'VCC'}
                })

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[3] = LogicGates::XOR.new(@pins[1].value, @pins[2].value).output()
			output[4] = LogicGates::XOR.new(@pins[5].value, @pins[6].value).output()
			output[10] = LogicGates::XOR.new(@pins[8].value, @pins[9].value).output()
			output[11] = LogicGates::XOR.new(@pins[12].value, @pins[13].value).output()

			if @pins[7].value == 0 and @pins[14].value == 1
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

	class IC_4071
		# 4071 = Quad 2 input OR gate
		# Pin_3 = OR(Pin_1, Pin_2)
    	# Pin_4 = OR(Pin_5, Pin_6)
    	# Pin_10 = OR(Pin_8, Pin_9)
    	# Pin_11 = OR(Pin_12, Pin_13)
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = nil
			
			@pins = Pin.to_pin(@pins)
			@uses_pin_class = true

			self.set_IC(
				{ 	1 => {'desc' => 'A1: Input 1 of OR gate 1'},
                    2 => {'desc' => 'B1: Input 2 of OR gate 1'},
                    3 => {'desc' => 'Q1: Output of OR gate 1'},
                    4 => {'desc' => 'Q2: Output of OR gate 2'},
                    5 => {'desc' => 'B2: Input 2 of OR gate 2'},
                    6 => {'desc' => 'A2: Input 1 of OR gate 2'},
                    7 => {'desc' => 'GND'},
                    8 => {'desc' => 'A3: Input 1 of OR gate 3'},
                    9 => {'desc' => 'B3: Input 2 of OR gate 3'},
                    10 => {'desc' => 'Q3: Output of OR gate 3'},
                    11 => {'desc' => 'Q4: Output of OR gate 4'},
                    12 => {'desc' => 'B4: Input 2 of OR gate 4'},
                    13 => {'desc' => 'A4: Input 1 of OR gate 4'},
                    14 => {'desc' => 'VCC'}
                })

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[3] = LogicGates::OR.new(@pins[1].value, @pins[2].value).output()
			output[4] = LogicGates::OR.new(@pins[5].value, @pins[6].value).output()
			output[10] = LogicGates::OR.new(@pins[8].value, @pins[9].value).output()
			output[11] = LogicGates::OR.new(@pins[12].value, @pins[13].value).output()

			if @pins[7].value == 0 and @pins[14].value == 1
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

	class IC_4072
		# 4072 = Dual 4 input OR gate
		# Pin_1 = OR(Pin_2, Pin_3, Pin_4, Pin_5)
    	# Pin_13 = OR(Pin_9, Pin_10, Pin_11, Pin_12)
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[6] = @pins[8] = nil
			
			@pins = Pin.to_pin(@pins)
			@uses_pin_class = true

			self.set_IC(
				{ 	1 => {'desc' => 'Q1: Output of OR gate 1'},
                    2 => {'desc' => 'A1: Input 1 of OR gate 1'},
                    3 => {'desc' => 'B1: Input 2 of OR gate 1'},
                    4 => {'desc' => 'C1: Input 3 of OR gate 1'},
                    5 => {'desc' => 'D1: Input 4 of OR gate 1'},
                    6 => {'desc' => 'NC'},
                    7 => {'desc' => 'GND'},
                    8 => {'desc' => 'NC'},
                    9 => {'desc' => 'D2: Input 4 of OR gate 2'},
                    10 => {'desc' => 'C2: Input 3 of OR gate 2'},
                    11 => {'desc' => 'B2: Input 2 of OR gate 2'},
                    12 => {'desc' => 'A2: Input 1 of OR gate 2'},
                    13 => {'desc' => 'Q2: Output of OR gate 2'},
                    14 => {'desc' => 'VCC'}
                })

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[1] = LogicGates::OR.new(@pins[2].value, @pins[3].value, @pins[4].value, @pins[5].value).output()
			output[13] = LogicGates::OR.new(@pins[9].value, @pins[10].value, @pins[11].value, @pins[12].value).output()
			
			if @pins[7].value == 0 and @pins[14].value == 1
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
	
	class IC_4077
		# 4077 = Quad 2 input XNOR gate
		# Pin_3 = XNOR(Pin_1, Pin_2)
    	# Pin_4 = XNOR(Pin_5, Pin_6)
    	# Pin_10 = XNOR(Pin_8, Pin_9)
    	# Pin_11 = XNOR(Pin_12, Pin_13)
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = nil
			
			@pins = Pin.to_pin(@pins)
			@uses_pin_class = true

			self.set_IC(
				{   1 => {'desc' => 'A1: Input 1 of XNOR gate 1'},
                    2 => {'desc' => 'B1: Input 2 of XNOR gate 1'},
                    3 => {'desc' => 'Q1: Output of XNOR gate 1'},
                    4 => {'desc' => 'Q2: Output of XNOR gate 2'},
                    5 => {'desc' => 'B2: Input 2 of XNOR gate 2'},
                    6 => {'desc' => 'A2: Input 1 of XNOR gate 2'},
                    7 => {'desc' => 'GND'},
                    8 => {'desc' => 'A3: Input 1 of XNOR gate 3'},
                    9 => {'desc' => 'B3: Input 2 of XNOR gate 3'},
                    10 => {'desc' => 'Q3: Output of XNOR gate 3'},
                    11 => {'desc' => 'Q4: Output of XNOR gate 4'},
                    12 => {'desc' => 'B4: Input 2 of XNOR gate 4'},
                    13 => {'desc' => 'A4: Input 1 of XNOR gate 4'},
                    14 => {'desc' => 'VCC'}
                })

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[3] = LogicGates::XNOR.new(@pins[1].value, @pins[2].value).output()
			output[4] = LogicGates::XNOR.new(@pins[5].value, @pins[6].value).output()
			output[10] = LogicGates::XNOR.new(@pins[8].value, @pins[9].value).output()
			output[11] = LogicGates::XNOR.new(@pins[12].value, @pins[13].value).output()

			if @pins[7].value == 0 and @pins[14].value == 1
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

	class IC_4078
		# 4078 = 8 input NOR gate
		# Pin_13 = NOR(Pin_2, Pin_3, Pin_4, Pin_5, Pin_9, Pin_10, Pin_11, Pin_12)
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[1] = @pins[6] = @pins[8] = nil
			
			@pins = Pin.to_pin(@pins)
			@uses_pin_class = true

			self.set_IC(
				{ 	1 => {'desc' => 'NC'},
                    2 => {'desc' => 'Input 1 of NOR gate'},
                    3 => {'desc' => 'Input 2 of NOR gate'},
                    4 => {'desc' => 'Input 3 of NOR gate'},
                    5 => {'desc' => 'Input 4 of NOR gate'},
                    6 => {'desc' => 'NC'},
                    7 => {'desc' => 'GND'},
                    8 => {'desc' => 'NC'},
                    9 => {'desc' => 'Input 5 of NOR gate'},
                    10 => {'desc' => 'Input 6 of NOR gate'},
                    11 => {'desc' => 'Input 7 of NOR gate'},
                    12 => {'desc' => 'Input 8 of NOR gate'},
                    13 => {'desc' => 'Output of NOR gate'},
                    14 => {'desc' => 'VCC'}
                })

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[13] = LogicGates::NOR.new(@pins[2].value, @pins[3].value, @pins[4].value, @pins[5].value, @pins[9].value, @pins[10].value, @pins[11].value, @pins[12].value).output()

			if @pins[7].value == 0 and @pins[14].value == 1
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
	
	class IC_4081
		# 4081 = Quad 2 input AND gate
		# Pin_3 = AND(Pin_1, Pin_2)
    	# Pin_4 = AND(Pin_5, Pin_6)
    	# Pin_10 = AND(Pin_8, Pin_9)
    	# Pin_11 = AND(Pin_12, Pin_13)
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = nil
			
			@pins = Pin.to_pin(@pins)
			@uses_pin_class = true

			self.set_IC(
				{ 	1 => {'desc' => 'A1: Input 1 of AND gate 1'},
                    2 => {'desc' => 'B1: Input 2 of AND gate 1'},
                    3 => {'desc' => 'Q1: Output of AND gate 1'},
                    4 => {'desc' => 'Q2: Output of AND gate 2'},
                    5 => {'desc' => 'B2: Input 2 of AND gate 2'},
                    6 => {'desc' => 'A2: Input 1 of AND gate 2'},
                    7 => {'desc' => 'GND'},
                    8 => {'desc' => 'A3: Input 1 of AND gate 3'},
                    9 => {'desc' => 'B3: Input 2 of AND gate 3'},
                    10 => {'desc' => 'Q3:Output of AND gate 3'},
                    11 => {'desc' => 'Q4:Output of AND gate 4'},
                    12 => {'desc' => 'B4: Input 2 of AND gate 4'},
                    13 => {'desc' => 'A4: Input 1 of AND gate 4'},
                    14 => {'desc' => 'VCC'}
                })

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[3] = LogicGates::AND.new(@pins[1].value, @pins[2].value).output()
			output[4] = LogicGates::AND.new(@pins[5].value, @pins[6].value).output()
			output[10] = LogicGates::AND.new(@pins[8].value, @pins[9].value).output()
			output[11] = LogicGates::AND.new(@pins[12].value, @pins[13].value).output()

			if @pins[7].value == 0 and @pins[14].value == 1
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
	
	class IC_4082
		# 4082 = Dual 4 input AND gate
		# Pin_1 = AND(Pin_2, Pin_3, Pin_4, Pin_5)
    	# Pin_13 = AND(Pin_9, Pin_10, Pin_11, Pin_12)
		include Base_14pin

		def initialize
			@pins = Array.new(15, 0)
			@pins[0] = @pins[6] = @pins[8] = nil
			
			@pins = Pin.to_pin(@pins)
			@uses_pin_class = true

			self.set_IC(
				{ 	1 => {'desc' => 'Q1: Output of AND gate 1'},
                    2 => {'desc' => 'A1: Input 1 of AND gate 1'},
                    3 => {'desc' => 'B1: Input 2 of AND gate 1'},
                    4 => {'desc' => 'C1: Input 3 of AND gate 1'},
                    5 => {'desc' => 'D1: Input 4 of AND gate 1'},
                    6 => {'desc' => 'NC'},
                    7 => {'desc' => 'GND'},
                    8 => {'desc' => 'NC'},
                    9 => {'desc' => 'D2: Input 4 of AND gate 2'},
                    10 => {'desc' => 'C2: Input 3 of AND gate 2'},
                    11 => {'desc' => 'B2: Input 2 of AND gate 2'},
                    12 => {'desc' => 'A2: Input 1 of AND gate 2'},
                    13 => {'desc' => 'Q2: Output of AND gate 2'},
                    14 => {'desc' => 'VCC'}
                })

			Base_14pin.set_properties
		end

		def run
			output = Hash.new
			output[1] = LogicGates::AND.new(@pins[2].value, @pins[3].value, @pins[4].value, @pins[5].value).output()
			output[13] = LogicGates::AND.new(@pins[9].value, @pins[10].value, @pins[11].value, @pins[12].value).output()
			
			if @pins[7].value == 0 and @pins[14].value == 1
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


	### ICs with 16 pins ###

	class IC_4008
		# 4008 = 4 bit Binary Full Adder
		include Base_16pin

		def initialize
			@pins = Array.new(17, 0)
			@pins[0] = @pins[11] = @pins[12] = @pins[13] = @pins[14] = nil
			
			@pins = Pin.to_pin(@pins)
			@uses_pin_class = true

			self.set_IC(
				{ 	1 => {'desc' => 'A3'},
                    2 => {'desc' => 'B2'},
                    3 => {'desc' => 'A2'},
                    4 => {'desc' => 'B1'},
                    5 => {'desc' => 'A1'},
                    6 => {'desc' => 'B0'},
                    7 => {'desc' => 'A0'},
                    8 => {'desc' => 'VSS'},
                    9 => {'desc' => 'C0'},
                    10 => {'desc' => 'S0'},
                    11 => {'desc' => 'S1'},
                    12 => {'desc' => 'S2'},
                    13 => {'desc' => 'S3'},
                    14 => {'desc' => 'C4'},
                    15 => {'desc' => 'B3'},
                    16 => {'desc' => 'VDD'},
                })

			Base_16pin.set_properties
		end

		def run
			output = Hash.new
			output[10] = ((@pins[2].to_logic) ^ (@pins[3].to_logic) ^ (@pins[9].to_logic)).to_logic
			output[11] = ((@pins[5].to_logic) ^ (@pins[4].to_logic) ^ ((@pins[7].to_logic & @pins[6].to_logic) \
						 | ((@pins[7].to_logic | @pins[6].to_logic) & (@pins[9].to_logic)))).to_logic
			output[12] = ((@pins[3].to_logic) ^ (@pins[2].to_logic) ^ ((@pins[5].to_logic & @pins[4].to_logic) \
						 | ((@pins[5].to_logic | @pins[4].to_logic) & (@pins[7].to_logic & @pins[6].to_logic)) \
						 | ((@pins[5].to_logic | @pins[4].to_logic) & (@pins[7].to_logic | @pins[6].to_logic) & (@pins[9].to_logic)))).to_logic
			output[13] = ((@pins[1].to_logic) ^ (@pins[15].to_logic) ^ ((@pins[3].to_logic & @pins[2].to_logic) | ((@pins[3].to_logic | @pins[2].to_logic) \
						 & (@pins[5].to_logic & @pins[4].to_logic)) | ((@pins[3].to_logic | @pins[2].to_logic) & (@pins[5].to_logic | @pins[4].to_logic) \
						 & (@pins[7].to_logic & @pins[6].to_logic)) | ((@pins[3].to_logic | @pins[2].to_logic) & (@pins[5].to_logic | @pins[4].to_logic) \
						 & (@pins[7].to_logic | @pins[6].to_logic) & (@pins[9].to_logic)))).to_logic

			output[14] = ((@pins[1].to_logic & @pins[15].to_logic) | ((@pins[1].to_logic | @pins[15].to_logic) & (@pins[3].to_logic & @pins[2].to_logic)) \
						 | ((@pins[1].to_logic | @pins[15].to_logic) & (@pins[3].to_logic | @pins[2].to_logic) & (@pins[5].to_logic & @pins[4].to_logic)) \
						 | ((@pins[1].to_logic | @pins[15].to_logic) & (@pins[3].to_logic | @pins[2].to_logic) & (@pins[5].to_logic | @pins[4].to_logic) \
						 & (@pins[7].to_logic & @pins[6].to_logic)) | ((@pins[1].to_logic | @pins[15].to_logic) & (@pins[3].to_logic | @pins[2].to_logic) \
						 & (@pins[5].to_logic | @pins[4].to_logic) & (@pins[7].to_logic | @pins[6].to_logic) & (@pins[9].to_logic))).to_logic
			
			if @pins[8].value == 0 and @pins[16].value == 1
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

	class IC_4015
		# 4015 = Dual 4 stage static shift register
		include Base_16pin

		def initialize
			@pins = [nil, 0, nil, nil, nil, nil, 0, 0, 0, 0, nil, nil, nil, nil, 0, 0, 0]
			
			@pins = Pin.to_pin(@pins)
			@uses_pin_class = false

			self.set_IC(
				{ 	1 => {'desc' => 'CLKB'},
                    2 => {'desc' => 'Q4'},
                    3 => {'desc' => 'Q3'},
                    4 => {'desc' => 'Q2'},
                    5 => {'desc' => 'Q1'},
                    6 => {'desc' => 'RST1'},
                    7 => {'desc' => 'DA'},
                    8 => {'desc' => 'VSS'},
                    9 => {'desc' => 'CLKA'},
                    10 => {'desc' => 'Q4'},
                    11 => {'desc' => 'Q3'},
                    12 => {'desc' => 'Q2'},
                    13 => {'desc' => 'Q1'},
                    14 => {'desc' => 'RSTB'},
                    15 => {'desc' => 'DB'},
                    16 => {'desc' => 'VDD'}
				})

			Base_16pin.set_properties
		end

		def run
			output = Hash.new
			if not (@pins[1].is_a?(Clock) and @pins[9].is_a?(Clock))
				raise "Invalid Clock Input"
			end

			sr1 = Register::Shift.new([@pins[7], @pins[4], @pins[3], @pins[2]], @pins[1], LogicGates::NOT.new(@pins[6]).output())	
			sr2 = Register::Shift.new([@pins[15], @pins[12], @pins[11], @pins[10]], @pins[9], LogicGates::NOT.new(@pins[14]).output())	

			sr1 = sr1.output()
			4.times do |i|
				output[5 - i] = sr1[i]
			end

			sr2 = sr2.output()
			4.times do |i|
				output[13 - i] = sr1[i]
			end

			if @pins[8].value == 0 and @pins[16].value == 1
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
	
	class IC_4017
		# 4017 = CMOS Counter
		include Base_16pin

		def initialize
			@pins = Array.new(17, nil)
			@pins[8] = @pins[13] = @pins[14] = @pins[15] = 0
			@pins[16] = 1
			
			@pins = Pin.to_pin(@pins)
			@uses_pin_class = false

			self.set_IC(
				{ 	1 => {'desc' => '5'},
                    2 => {'desc' => '1'},
                    3 => {'desc' => '0'},
                    4 => {'desc' => '2'},
                    5 => {'desc' => '6'},
                    6 => {'desc' => '7'},
                    7 => {'desc' => '3'},
                    8 => {'desc' => 'VSS'},
                    9 => {'desc' => '8'},
                    10 => {'desc' => '4'},
                    11 => {'desc' => '9'},
                    12 => {'desc' => 'carry'},
                    13 => {'desc' => 'CLKI'},
                    14 => {'desc' => 'CLK'},
                    15 => {'desc' => 'RST'},
                    16 => {'desc' => 'VDD'}
                })

			@step = 0
			Base_16pin.set_properties
		end

		def run
			output = Hash.new
			if not (@pins[13].is_a?(Clock) and @pins[14].is_a?(Clock))
				raise "Invalid Clock Input"
			end

			counter = Counter::Decade.new(@pins[14].clock_connector, 0, Connector.new(1), Connector.new(LogicGates::NOT.new(@pins[15]).output()))

			@step.each do |i|
				counter.trigger()
			end

			@step = @step + 1
			out = counter.state().map(&:to_s).join('').to_i(2)

			output[12] = if out <= 4 then 1 else 0 end

			(1..12).each do |i|
				output[i] = 0
			end

			out_output_map = {5 => 1, 1 => 2, 0 => 3, 2 => 4, 6 => 5, 7 => 6, 3 => 7, 8 => 9, 4 => 10, 9 => 11}
			output[out_output_map[out]] = 1	

			if @pins[8].value == 0 and @pins[16].value == 1
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
	
	class IC_4019
		# 4019 = 8 to 4 line non-inverting MUX with OR gate
		include Base_16pin

		def initialize
			@pins = Array.new(17, nil)
			@pins[8] = @pins[13] = @pins[14] = @pins[15] = 0
			@pins[16] = 1
			
			@pins = Pin.to_pin(@pins)
			@uses_pin_class = false

			self.set_IC(
				{ 	1 => {'desc' => '4A1'},
                    2 => {'desc' => '3A0'},
                    3 => {'desc' => '3A1'},
                    4 => {'desc' => '2A0'},
                    5 => {'desc' => '2A1'},
                    6 => {'desc' => '1A0'},
                    7 => {'desc' => '1A1'},
                    8 => {'desc' => 'GND'},
                    9 => {'desc' => 'S0'},
                    10 => {'desc' => 'Y1'},
                    11 => {'desc' => 'Y2'},
                    12 => {'desc' => 'Y3'},
                    13 => {'desc' => 'Y4'},
                    14 => {'desc' => 'S1'},
                    15 => {'desc' => '4A0'},
                    16 => {'desc' => 'VCC'}
				})

			Base_16pin.set_properties
		end

		def run
			output = Hash.new
			output[10] = LogicGates::OR.new(LogicGates::AND.new(self.pins[9], self.pins[6]).output(), LogicGates::AND.new(self.pins[14], self.pins[7]).output()).output()
			output[11] = LogicGates::OR.new(LogicGates::AND.new(self.pins[9], self.pins[4]).output(), LogicGates::AND.new(self.pins[14], self.pins[5]).output()).output()
        	output[12] = LogicGates::OR.new(LogicGates::AND.new(self.pins[9], self.pins[2]).output(), LogicGates::AND.new(self.pins[14], self.pins[3]).output()).output()
        	output[13] = LogicGates::OR.new(LogicGates::AND.new(self.pins[9], self.pins[1]).output(), LogicGates::AND.new(self.pins[14], self.pins[15]).output()).output()

			if @pins[8].value == 0 and @pins[16].value == 1
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
	
	class IC_4022
		# 4022 = Octal counter
		include Base_16pin

		def initialize
			@pins = Array.new(17, nil)
			@pins[8] = @pins[13] = @pins[14] = @pins[15] = 0
			@pins[16] = 1
			
			@pins = Pin.to_pin(@pins)
			@uses_pin_class = false

			self.set_IC(
				{ 	1 => {'desc' => '1'},
                    2 => {'desc' => '0'},
                    3 => {'desc' => '2'},
                    4 => {'desc' => '5'},
                    5 => {'desc' => '6'},
                    6 => {'desc' => ''},
                    7 => {'desc' => '3'},
                    8 => {'desc' => 'VSS'},
                    9 => {'desc' => ''},
                    10 => {'desc' => '7'},
                    11 => {'desc' => '4'},
                    12 => {'desc' => 'carry'},
                    13 => {'desc' => 'CLKI'},
                    14 => {'desc' => 'CLK'},
                    15 => {'desc' => 'RST'},
                    16 => {'desc' => 'VDD'}
				})

			@step = 0

			Base_16pin.set_properties
		end

		def run
			output = Hash.new
			if not (@pins[13].is_a?(Clock) and @pins[14].is_a?(Clock))
				raise "Invalid Clock Input"
			end

			counter = Counter::Octal.new(@pins[14].clock_connector, 0, Connector.new(1), Connector.new(LogicGates::NOT.new(@pins[15]).output()))

			@step.each do |i|
				counter.trigger()
			end

			@step = @step + 1
			out = counter.state().map(&:to_s).join('').to_i(2)

			output[12] = if out <= 3 then 1 else 0 end

			(1..12).each do |i|
				output[i] = 0
			end

			out_output_map = {5 => 4, 1 => 1, 0 => 2, 2 => 3, 6 => 5, 7 => 10, 3 => 7, 4 => 11}
			output[out_output_map[out]] = 1	

			if @pins[8].value == 0 and @pins[16].value == 1
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

	class IC_4027
		# 4027 = Dual JK FF with set and reset
		include Base_16pin

		def initialize
			@pins = Array.new(17, 0)
			@pins[0] = @pins[1] = @pins[2] = @pins[14] = @pins[15] = nil
			@pins[16] = 1
			
			@pins = Pin.to_pin(@pins)
			@uses_pin_class = false

			self.set_IC(
				{ 	1 => {'desc' => 'Q1'},
                    2 => {'desc' => '~Q1'},
                    3 => {'desc' => 'CLK1'},
                    4 => {'desc' => 'RST1'},
                    5 => {'desc' => 'K1'},
                    6 => {'desc' => 'J1'},
                    7 => {'desc' => 'SET1'},
                    8 => {'desc' => 'GND'},
                    9 => {'desc' => 'SET2'},
                    10 => {'desc' => 'J2'},
                    11 => {'desc' => 'K2'},
                    12 => {'desc' => 'RST2'},
                    13 => {'desc' => 'CLK2'},
                    14 => {'desc' => '~Q2'},
                    15 => {'desc' => 'Q2'},
                    16 => {'desc' => 'VCC'}
                })

			Base_16pin.set_properties
		end

		def run
			output = Hash.new
			if not (@pins[13].is_a?(Clock) and @pins[3].is_a?(Clock))
				raise "Invalid Clock Input"
			end

			ff1 = FlipFlop::JK.new(@pins[6], @pins[5], Connector.new(1), @pins[3].clock_connector, @pins[7], @pins[4])

	        ff2 = FlipFlop::JK.new(@pins[10], @pins[11], Connector.new(1), @pins[13].clock_connector, @pins[9], @pins[12])
	   
	        while true
	            if @pins[3].clock_connector.state == 1
	                ff1.trigger()
	                break
	            end
	        end

	        while true
	            if @pins[3].clock_connector.state == 0
	                ff1.trigger()
	                break
	            end
	        end
	        
	        output[1], output[2] = ff1.state()
	        
	        while true
	            if @pins[13].clock_connector.state == 1
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
	        
	        output[15], output[14] = ff2.state()

			if @pins[8].value == 0 and @pins[16].value == 1
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
	
	class IC_4028
		# 4028 = BCD to decimal decoder
		include Base_16pin

		def initialize
			@pins = Array.new(17, nil)
			@pins[8] = @pins[10] = @pins[11] = @pins[12] = @pins[13] = 0
			@pins[16] = 1
			
			@pins = Pin.to_pin(@pins)
			@uses_pin_class = false

			self.set_IC(
				{ 	1 => {'desc' => 'Y4'},
                    2 => {'desc' => 'Y2'},
                    3 => {'desc' => 'Y0'},
                    4 => {'desc' => 'Y7'},
                    5 => {'desc' => 'Y9'},
                    6 => {'desc' => 'Y5'},
                    7 => {'desc' => 'Y6'},
                    8 => {'desc' => 'GND'},
                    9 => {'desc' => 'Y8'},
                    10 => {'desc' => 'S0'},
                    11 => {'desc' => 'S3'},
                    12 => {'desc' => 'S2'},
                    13 => {'desc' => 'S1'},
                    14 => {'desc' => 'Y1'},
                    15 => {'desc' => 'Y3'},
                    16 => {'desc' => 'VCC'}
				})

			Base_16pin.set_properties
		end

		def run
			output = Hash.new

			d = Combinational::DEMUX.new(1)
			d.select_lines(@pins[10], @pins[13], @pins[12], @pins[11])
			d = d.output()[0, 10]
			output_demux_map = {1 => 4, 2 => 2, 3 => 0, 4 => 7, 5 => 9, 6 => 5, 7 => 6, 9 => 8, 14 => 1, 15 => 3}			

			output_demux_map.each do |outidx, didx|
				output[outidx] = d[didx]
			end

			if @pins[8].value == 0 and @pins[16].value == 1
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