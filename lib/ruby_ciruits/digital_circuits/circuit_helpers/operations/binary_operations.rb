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
		x, y = parsed_inputs(input1, input2)
		z = (x.to_i(2) + y.to_i(2)).to_s(2)
		if z[0] == '-'
			return z.slice(1, z.length)
		end
		return z
	end
	
	def subtract(input1, input2)
		x, y = parsed_inputs(input1, input2)
		z = (x.to_i(2) - y.to_i(2)).to_s(2)
		if z[0] == '-'
			return z.slice(1, z.length)
		end
		return z
	end

	def multiply(input1, input2)
		x, y = parsed_inputs(input1, input2)
		z = (x.to_i(2) * y.to_i(2)).to_s(2)
		if z[0] == '-'
			return z.slice(1, z.length)
		end
		return z
	end

	def divide(input1, input2)
		x, y = parsed_inputs(input1, input2)
		z = (x.to_i(2) / y.to_i(2)).to_s(2)
		if z[0] == '-'
			return z.slice(1, z.length)
		end
		return z
	end

	def complement(input, option)
		x = parse_input(input)
		z = (x.to_i(2) ^ ('1' * input.length).to_i(2)).to_s(2)
		op = (z.to_i(2) + '1'.to_i(2)).to_s(2)
		if option == '1'
			return (((input.length - z.length) * '0') + z)
		end
		return (((input.length - op.length) * op[0]) + op)
	end

	def self.dec_to_bin(number)
		#todo
	end

	def self.bin_to_dec(number)
		#todo
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