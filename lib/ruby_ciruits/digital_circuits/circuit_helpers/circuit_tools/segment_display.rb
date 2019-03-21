=begin 
	This simulates a 7 segment display
=end

class SegmentDisplay

	attr_reader :name

	def initialize(name)
		@name = name
	end

	def evaluate(pin_configuration)
		if pin_configuration.length != 10
			if pin_configuration.length != 7
				raise "there must be 10 or 7 values"
			end
		end

		vcc = 0
		# test_digit = [a, b, c, d, e, f, g]
		test_digit = Array.new(7, 0)

		if pin_configuration.length == 10
			vcc = (pin_configuration[2] | pin_configuration[7])
			idx = [6, 5, 3, 1, 0, 8, 9]
			7.times do |i|
				test_digit[i] = pin_configuration[idx[i]]
			end
		elsif pin_configuration.length == 7
			vcc = 1
			7.times do |i|
				test_digit[i] = pin_configuration[i]
			end
		end

		if vcc == 1
			digit_mapping = { 
				"0" => [1, 1, 1, 1, 1, 1, 0],
				"1" => [0, 1, 1, 0, 0, 0, 0],
				"2" => [1, 1, 0, 1, 1, 0, 1],
				"3" => [1, 1, 1, 1, 0, 0, 1],
				"4" => [0, 1, 1, 0, 0, 1, 1],
				"5" => [1, 0, 1, 1, 0, 1, 1],
				"6" => [1, 0, 1, 1, 1, 1, 1],
				"7" => [1, 1, 1, 0, 0, 0, 0],
				"8" => [1, 1, 1, 1, 1, 1, 1],
				"9" => [1, 1, 1, 1, 0, 1, 1]
			}
			digit_mapping.each do |digit, mapping|
				if test_digit == mapping
					return digit.to_i
				end
			end
			return nil
		else
			return nil
		end
	end	
end