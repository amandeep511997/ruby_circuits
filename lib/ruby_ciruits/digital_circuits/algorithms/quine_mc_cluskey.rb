require 'set'

class QM
	def initialize(variables)
		@variables = Array(variables)
		@number_of_variables = variables.length
	end	

	def solve(ones, dont_care=Array.new)
		# returns - (a, b)
		# a = the complexity of the result
		# b = list of minterms which is the minified boolean function expressed as SOP form

		if ones.length == 0
			return [0, '0']
		end

		if ones.length + dont_care.length == (2**(@number_of_variables))
			return [0, '1']
		end

		primes = compute_prime_implicants(ones + dont_care)
		return self.unate_cover(primes, ones)
	end

	def calculate_complexity(minterms)
		# complexity is calculated on the basis of following rules -
		# A NOT gate adds 1 to the complexity
		# A n-input AND or OR gate adds n to the complexity

		complexity = minterms.length
		if complexity == 1
			complexity = 0
		end
		mask = (2**@number_of_variables) - 1
		minterms.each do |minterm|
			masked = ~minterm[1] & mask
			term_complexity = bit_count(masked)
			if term_complexity == 1
				term_complexity = 0
			end
			complexity = complexity + term_complexity
			complexity = complexity + bit_count(~minterm[0] & masked)
		end
		return complexity
	end

	def get_function(minterms)
		# return in human readable form a SOP function
		# using AND, OR, NOT form
		if minterms.is_a?(String)
			return minterms
		end

		or_terms = Array.new
		minterms.each do |minterm|
			and_terms = Array.new

			@variables.length.times do |idx|
				if minterm[0] & 1 << idx
					and_terms << @variables[idx]
				elsif not (minterm[1] & 1 << idx)
					and_terms << ("(NOT #{@variables[idx]})")
				end
			end

			or_terms << (parentheses(' AND ', and_terms))
		end	

		return parentheses(' OR ', or_terms)
	end

private 
	
	# find all primes implicants of the function
	def compute_prime_implicants(cubes)
		# cubes = a list of indices for the minterms for which the function evaluates 
		# to 1 or don't care
		sigma = Array.new(@number_of_variables + 1, Set.new)

		cubes.each do |x|
			sigma[bit_count(x)].add([i, 0])
		end
		
		primes = Set.new

		#while sigma.length > 0 
		#	nsigma = []
		#	redundant = Set.new
		#
		#end


	end

	def unate_cover(primes, ones)
		# use the prime implicants to find the essential prime implicants of the function
		# as well as the other prime implicants that are necessary to cover the function.
		# This uses the Petrick's method - to find all minimum SOP solutions from a prime
		# implicant chart

		chart = Array.new

		ones.each do |one|
			column = Array.new
			primes.each_with_index do |prime, idx|
				if (one & (~prime[1])) == prime[0]
					column << idx
				end
			end
			chart << column
		end

		covers = Array.new
		
		if chart.length > 0
			covers = chart[0].map { |el| Set.new(Array(el)) }
		end
		
		(1..(chart.length)).each do |i|
			new_covers = Array.new
			covers.each do |cover|
				chart[i].each do |prime_index|
					x = Set.new(cover)
					x.add(prime_index)
					append = true
					((new_covers.length) - 1).downto(0) do |j|
						if x <= new_covers[j]
							# delete new_covers[j] here
						elsif x > new_covers[j]
							append = false
						end
					end
					if append
						new_covers << x
					end
				end
			end
			covers = new_covers
		end

		min_complexity = 99999999
		covers.each do |cover|
			#primes_in_cover = cover.map
			complexity = self.calculate_complexity(primes_in_cover)
			if complexity < min_complexity
				min_complexity = complexity
				result = primes_in_cover
			end
		end
		return [min_complexity, result]
	end

	def parentheses(delim, list)
		if list.length > 1
			return ['(', list.join(delim), ')'].join('')
		else
			return list.join(delim)
		end
	end

	def bit_count(x)
		count = 0
		while x > 0
			count = count + 1
			x = x & (x - 1)
		end
		return count
	end

	def is_power_two_or_zero?(x)
		return ((x & (~x + 1)) == x)
	end

	def merge(x, y)
		if x[1] != y[1]
			return nil
		end
		t = x[0] ^ y[0]
		if not is_power_two_or_zero?(t)
			return nil
		end
		return (x[0] & y[0], x[1] | t)
	end

end