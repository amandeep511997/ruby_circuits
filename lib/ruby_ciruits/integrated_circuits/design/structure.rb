require_relative "../utility/symbols"

# this is a base module for all ICs
module IC
	def set_properties
		@output_connector = Hash.new
	end

	def set_output(index, value)
		if not value.is_a?(Connector)
			raise "Expecting a Connector class object"
		end
		value.tap(self, "output")
		@output_connector[index] = value
		begin
			output = self.run()
		rescue 
			print("Invalid Arguments")
		end
	end

	def set_IC(args_hash)
		# If Pin module is not used then this method takes a hash with the format
		# {PINNO: PINVALUE, ...}
		# else it takes a hash of hashes of the format
		# { PINNO1: {PARAM1:VAL1, PARAM2:VAL2, ...}, PINNO2: {PARAM!:VAL1, PARAM2:VAL2}, ...} 
		if not args_hash.is_a?(Hash)
			raise "Invalid Arguments"
		end

		args_hash.each_key do |pin|
			if @uses_pin_class
				@pins[pin] = set_pin_param(args_hash[pin])
			else
				@pins[pin] = args_hash[pin]
			end	
		end
	end

	def draw_IC
		if [14, 24].include?(@total_pins)
			top = "\n\n              " + VHU_ + (H_ * 9) + U_ + (H_ * 9) + HVD_ + N_
            bottom = "              " + VHD_ + (H_ * 19) + HVU_ + "  "
            diag = top

            ic_number = (self.class.split('_')[-1]).to_s 
            ic_name = (' ' * 2) + ic_number + (' ' * 10)

            (1..((@total_pins / 2) + 1)).each do |i|
            	j = @total_pins - i + 1
            	if @uses_pin_class
            		v1 = if @pins[i].value.nil? then 'Z' else @pins[i].value.to_s end
            		v2 = if @pins[j].value.nil? then 'Z' else @pins[j].value.to_s end 

            		f = [@pins[i].pin_tag, v1, i.to_s, ic_name[i], j.to_s, v2, @pins[j].pin_tag]
            	else
					v1 = if @pins[i].nil? then 'Z' else @pins[i].to_s end
            		v2 = if @pins[j].nil? then 'Z' else @pins[j].to_s end

            		f = ['   ', v1, i.to_s, ic_name[i], j.to_s, v2, '   ']             		
            	end
            	diag += "              |                   |\n"
                diag += "   #{f[0]} [#{f[1]}]    ---|  #{f[2]}      #{f[3]}      #{f[4]}  |---    [#{f[5]}s]   #{f[6]}s\n"
                diag += "              |                   |\n"
           	end 

           	diag += bottom
            diag = diag.gsub("---|",H_ * 2 + LT_).gsub("|---", RT_ + H_ * 2).gsub('|', V_)
            print(diag)
		else 
			raise "IC is not supported"
		end
	end
end

# Pin class for defining particular pin of an IC
class Pin
	def initialize(pin_no, args_hash=Hash.new)
		@pin_no = pin_no
		@pin_tag = '   '
		@can_vary = true
		self.set_pin_param(args_hash)
	end

	def set_pin_param(args_hash)
		if args_hash.is_a?(Hash)
			#store the contents of the hash to the respective parameters
			args_hash.each do |key, value|
				if key == "value"
					@value = value
				elsif key == "desc"
					if not args_hash.include?("pin_tag") or args_hash["pin_tag"].length < 3
						if value.length >= 3
							@pin_tag = value[0, 3].upcase
						end
					end
				elsif key == "pin_tag"
					if value.length >= 3
						@pin_tag = value[0, 3].upcase
					end
				elsif key == "can_vary"
					@can_vary = value
				end
			end
		elsif args_hash.is_a?(Fixnum) and [0, 1, nil].include?(args_hash)
			value = args_hash
			@value = value			
		else
			raise "unknown parameter type"
		end
	end

	def 

	def to_s
		return self.value.to_s
	end

	# this method converts a list of logic gates to pin instances
	def self.to_pin(args)
		if arg.is_a?(Array)
			list_of_pins = Array.new
			
			arg.each_with_index do |el, idx|
				list_of_pins << (self.new(idx + 1, {"value" => el, "desc" => '   ', "can_vary" => true}))
			end
			return list_of_pins
		else
			raise "unknown parameter type, Array is required"
		end
	end

end


