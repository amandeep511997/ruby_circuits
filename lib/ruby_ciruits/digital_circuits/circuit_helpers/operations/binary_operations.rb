=begin
	This class implements the primary arithmetic binary functions ADD, SUB, MUL, DIV, COMP(Complement)
	Inputs - unsigned or signed numbers.

	Examples 
	--------
	> op = BinaryOperations.new
	> op.add('1100', '0001')

=end 

class BinaryOperations

	def add(input1, input2)
		parsed_input1, parsed_input2 = parsed_inputs(input1, input2)

	end
	
	def subtract(input1, input2)
		parsed_input1, parsed_input2 = parsed_inputs(input1, input2)
	end

	def multiply(input1, input2)
		parsed_input1, parsed_input2 = parsed_inputs(input1, input2)
	end

	def divide(input1, input2)
		parsed_input1, parsed_input2 = parsed_inputs(input1, input2)
	end

	def complement(input, option)
		parsed_input = parse_input(input)
		
	end

	def self.dec_to_bin(number)

	end

	def self.bin_to_dec(number)

	end
private

	def parse_input(input)
		if input.is_a?(Array)
			input = input.join('')
		elsif input.is_a?(String) == false
			input = input.to_s
		end
		return input
	end

	def parsed_inputs(input1, input2)
		parsed_input1 = parse_input(input1)
		parsed_input2 = parse_input(input2)
		return parsed_input1, parsed_input2
	end
end