require_relative 'convert_expressions'

def make_expression(variables, terms, dont_care=nil, minterms=true)
	ones = Array.new

	if minterms == true
		ones = terms
		
		if ones[-1] >= (2**(variables.length))
			raise "invalid minterms"
		end
	else
		zeros = terms
		
		if zeros[-1] >= (2**(variables.length))
			raise "invalid maxterms"
		end
		
		(2**(variables.length)).times do |idx|
			unless zeros.include?(idx)
			 	ones << idx
			end
		end
	end

	unless dont_care.nil?
	 	_dont_care = Array(dont_care).map(&:to_i)
	end

	qm_method = QM.new(variables)

	if dont_care.nil?
		logical_expression = qm_method.get_function(qm_method.solve(ones)[1])
	else
		logical_expression = qm_method.get_function(qm_method.solve(ones, _dont_care)[1])
	end

	gate_form = convert_expression(logical_expression)

	return [logical_expression, gate_form]
end