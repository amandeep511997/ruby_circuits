require_relative 'structure'

# base module for ICs with 5 pins
module Base_5pin
	include IC
	
	def self.set_properties
		@total_pins = 5
		@uses_pin_class = false
		IC.set_properties
	end

	def set_pin(pin_no, pin_value)
		if pin_no < 1 or pin_no > 5
			raise "there are only 5 pins in this IC"
		end

		if not @uses_pin_class
			@pins[pin_no] = pin_value
		else
			@pins[pin_no].set_pin_param(pin_value)
		end
	end
end