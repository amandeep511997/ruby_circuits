require_relative '../design/structure'
require_relative '../design/base_14pin'
require_relative '../design/base_16pin'
# require [connectors, gates, ic.base, combinational, sequential, and clock]
# require [base14pin, base16pin]

# This module contains all classes for 4000 series
# length of pins used in programming is one more than actual number of pins
# as pin0 is not used

# ICs in this module

# ICs with 14 pins
# 4001 = Quad 2 input NOR gate
# 4002 = Dual 4 input NOR gate
# 4011 = Quad 2 input NAND gate
# 4012 = Dual 4 input NOR gate
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
# 4020 = 14 bit asynchronous binary counter with reset
# 4022 = Octal counter
# 4027 = Dual JK FF with set and reset
# 4028 = BCD to decimal decoder
# 4029 = 4 bit synchronous binary/decade up/down counter

module Series4000
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
			@
			self.set_properties

		end

		def run

		end
	end
end