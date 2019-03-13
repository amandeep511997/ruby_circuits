=begin 
	The CircuitIndexer is a indexing and listing service 
	to bind a unique index and store them as key:value pair 
	This makes it easier to debug connections.

	Instance Functions
	------------------
	1. index 
	2. unindex
	3. get_element
	4. get_index

	Examples 
	--------
	> a = Connector.new
	> b = Connector.new
	> a.index
	1
	> b.index
	2
=end


class CircuitIndexer
	@@indices = Hash.new # { gates.AND => {1 => <AND instance>}}
	@@inverse_indices = Hash.new # { gates.AND => {<AND instance> => 1}}
	@@maximum_index = Hash.new # {gates.AND => 1}

	def self.index(element)
		if element.nil?
			raise ArgumentError, "no element to index"
		end

		# add an element to the indexed list and return its unique ID
		unless @@indices.include?(element.class)
			@@indices[element.class] = Hash.new
			@@inverse_indices[element.class] = Hash.new
			@@maximum_index[element.class] = 0
		end 

		if CircuitIndexer.get_index(element).nil?
			return CircuitIndexer.get_index(element)
		end

		# unique ID numbers are not reused 
		@@maximum_index[element.class] += 1

		element_index = @@maximum_index[element.class]

		@@indices[element.class][element_index] = element
		@@inverse_indices[element.class][element] = element_index

		return element_index
	end

	def self.unindex(element=nil, element_index=nil, element_class=nil)
		if element.nil? == false
			element_index = CircuitIndexer.get_index(element)
			element_class = element.class
		elsif element.nil? and (element_index.nil? and element_class.nil?)
			raise ArgumentError, "operation not possible, insufficient parameters"
		end
		element ||= @@indices[element_class][element_index]
		@@indices[element_class].delete(element_index)
		@@inverse_indices[element_class].delete(element)
	end

	def self.get_index(element)
		if element.nil?
			raise ArgumentError, "no element to index"
		end

		if @@inverse_indices[element.class].has_key?(element)
			return @@inverse_indices[element.class][element]
		end
		return nil
	end

	def self.get_element(element_index, element_class)
		if element_index.nil? or element_class.nil?
			raise ArgumentError, "insufficient arguments, 2 arguments required "
		end

		if @@indices.has_key?(element_class) and @@indices[element_class].has_key?(element_index)
			return @@indices[element_class][element_index]
		end
		return nil
	end
end