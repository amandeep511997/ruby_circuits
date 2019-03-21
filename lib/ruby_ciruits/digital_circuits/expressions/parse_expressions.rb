=begin 
	This can be used to parse any expression which contains boolean 
	variables. 
	Input can be in the form of logical operators which can be parsed to Gates 
	using this class.
	This can also be used to obtain truth tables.

	Logical Operator Form: function takes only equation as an input
	Gates Form: Needs input variables also as an argument after the equation
	

=end


class ParseExpression
	def initialize(equation, *variables)
		begin
			@no_error = true

			if variables.length > 0
				@variables = Array(variables)
				@equation = equation
			else
				@variables = Array.new
				@equation = self.parse_equation(equation)
			end
		rescue
			raise ArgumentError, "invalid arguments"
		end

	end

	def parse
		return @equation
	end

	def truth_table
		@variables.each do |var|
			print(var, ' ')
		end
		print('O')
		(2**(@variables.length)).times do |idx|
			number = idx.to_s(2).rjust(@variables.length, "0")
			number = number.split.map(&:to_i)

			number.length.times do |i|
				
				print(number[i], ' ')
				
				if i + 1 == number.length 
					if LogicGates.belongs?(eval(@equation))
						print(eval(@equation).output())
					else
						print(eval(@equation))
					end
				end
			end
		end 
	end

	def remove_braces(position, equation)
		# removes braces due to clubbing of the gates 
		# position is the index of the clubbed gates
		eq = equation
		
		if position != -1
			eq = equation.slice(0, position)
			stack = 0
			equation.slice(position, equation.length).each do |ch|
				if (ch == '(') and (stack != -1)
					stack = stack + 1
					eq = eq + ch
				elsif (ch == ')') and (stack != -1)
					stack = stack - 1
					if stack == 0
						stack = -1 
					else 
						eq = eq + ch
					end
				else
					eq = eq + ch
				end
			end
		end

		return eq
	end

	def find_matching_brace(position, string)
		# returns index of the opposite matching braces for the brace at string[position]
		if position != -1
			if string[position] != '('
				return -1
			end
	
			stack = 0
			pos = position
	
			string.slice(position, string.length).each do |ch|
				if (ch == '(') and (stack != -1)
					stack = stack + 1
				elsif (ch == ')') and (stack != -1)
					stack = stack - 1
					if stack == 0
						return pos
					end
				end
				pos = pos + 1
			end
		end
		return -1		
	end

	def parse_equation(equation, is_operand_type=method(:is_alpha?))
		eqn = equation.delete(' ')
		equation_final = String.new
		operators = Array.new # Stack for operators
		operands = Array.new # Stack for operands
		flag = false

		idx = 0
		while idx < eqn.length
			unless @no_error
			 	break
			end
			if ['~', '&', '|', '^'].include?(eqn[idx])
				if flag
					operands << eqn[idx - 1]
					flag = false
				end
				operators << eqn[idx]

			elsif eqn[idx] == '('
				if flag
					print("equation error at " + eqn.slice(idx - 1, idx + 1))
					@no_error = false
					break
				end
				
				pos = self.find_matching_brace(idx, eqn)
				
				if pos == -1
					print("equation error - unmatched braces")
					@no_error = false
					break
				end
				
				temp = self.parse_equation(eqn.slice(idx + 1, pos))
				operands << temp
				idx = pos

			elsif is_operand_type.call(eqn[idx])
				if flag
					# for 2 letter operand
					operands << eqn.slice(idx - 1, idx + 1)
					flag = false
				else
					flag = true
				end
			else
				print("unrecognized characters in equation " + eqn[idx])
				@no_error = false
			end
			idx = idx + 1
		end	

		if flag
			operands << eqn[-1]
			flag = false
		end

		unless @no_error
			return
		end

		@variables = operands

		while operators.length > 0
			op = operators.pop
			if op == '~'
				operands << ('NOT(' + operands.pop + ')')
			elsif op == '&'
				operands << ('AND(' + operands.pop + ', ' + operands.pop + ')')
			elsif op == '|'
				operands << ('OR(' + operands.pop + ', ' + operands.pop + ')')
			elsif op == '^'
				operands << ('XOR(' + operands.pop + ', ' + operands.pop + ')')
			end
		end

		equation_final = operands.pop

		# Optimize the final equation by clubbing the gates together

		unoptimized = true
		replace_gates = [
			['NOT(AND(', 'NAND('], 
			['NOT(OR(', 'NOR('], 
			['NOT(XOR(', 'XNOR('], 
			['AND(AND(', 'AND('], 
			['OR(OR(', 'OR('],
			['XOR(XOR(', 'XOR('],
			['NAND(NAND(', 'NAND('],
			['NOR(NOR(', 'NOR('],
			['XNOR(XNOR(', 'XNOR('],
			['NAND(AND(', 'NAND('],
			['NOR(OR(', 'NOR(']
		]

		while unoptimized
			unoptimized = false

			replace_gates.each do |pair|
				from = pair[0]
				to = pair[1]

				pos, equation_final = club_gates(equation_final, from, to)
				unoptimized |= not_nil?(pos)
			end
		end

		if @no_error
			return equation_final
		end
		return nil
	end

private 

	def is_alpha?(string)
		return !!string.match(/^[[:alpha:]]+$/)
	end

	def club_gates(equation, from, to)
		pos = equation.index(from)
		unless pos.nil?
			first_half_eqn = equation.slice(0, pos)
			second_half_eqn = equation.slice(pos, equation.length).sub(from, to)
			equation = first_half_eqn + second_half_eqn
			equation = self.remove_braces(pos, equation)
		end
		return [pos, equation]
	end

	def not_nil?(value)
		return (not value.nil?)
	end	

end