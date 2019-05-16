require_relative 'structure'

# base module for ICs with 14 pins
module Base_14pin
	include IC
	
	def set_properties
		@total_pins = 14
		@uses_pin_class = false
		self.set_properties
	end

	def set_pin(pin_no, pin_value)
		if pin_no < 1 or pin_no > 14
			raise "there are only 14 pins in this IC"
		end

		if not @uses_pin_class
			@pins[pin_no] = pin_value
		else
			@pins[pin_no].set_pin_param(pin_value)
		end
	end

	def set_pin_param(pin_no, param_hash)
		if pin_no < 1 or pin_no > 14
			raise "there are only 14 pins in this IC"
		end

		if not @uses_pin_class
			raise "IC does not use Pin set class"
		else
			@pins[pin_no].set_pin_param(param_hash)
		end
	end
end