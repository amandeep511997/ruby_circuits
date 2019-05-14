require_relative "../utility/oscilloscope_symbols"
require 'celluloid'

=begin
	Oscilloscope is helpful in visualising simulations 
	The screen of the oscilloscope changes in background processes
	The screen is only displayed when display is called.

	Usage - 
		# A clock of 1Hz frequency
		clock = Clock.new
		clock_connector = clock.clock_connector

		bc = BinaryCounter.new
		os = Oscilloscope.new((bc.out[1], 'lsb'), (bc.out[0], 'msb'))
		os.start
		# Triggering the counter	
		(0..4).each do |i|
			bc.trigger()
			puts(b.state)
		end
		os.stop
		os.display
=end

class Oscilloscope
	include Celluloid

	attr_reader :max_inp, :width, :inputs, :scale

	def initialize(*inputs)
		@max_inp = 15
		@width = 150
		@width_itr = 0

		@inputs = Array.new
		@len_inputs = 0

		@labels = Hash.new
		@logic_array = Array.new
		self._clear_LA()

		# ANSI codes for colored print in terminal
		@color = "\x1b[0m" 

		if inputs.length > 0
			self.set_inputs(*inputs)
		end
		@scale = 1

		@started = false
		@stopped = false

		@oscilloscope = nil
		# needs to be started by the user
	end

	def start
		if not @started
			@started = true

			@oscilloscope = every 0.1 do 
				@width.times do |i|
					sleep @scale
					sampler(i)
				end
			end
		elsif @stopped and not @oscilloscope.nil?
			@stopped = false
			@oscilloscope.resume
		end
	end

	def stop
		if not @stopped and not @oscilloscope.nil?
			@oscilloscope.pause
			@stopped = true
		end
	end

	def kill
		self.terminate
	end

	def unhold
		if not @oscilloscope.nil?
			clear(true)
			@width_itr = 0
			@oscilloscope.pause
		end
	end

	def hold
		if not @oscilloscope.nil?
			@oscilloscope.resume
		end
	end

	def _clear_LA
		@max_inp.times do 
			@logic_array << Array.new(@width, 0)
		end
	end

	def set_width(w=150)
		# set the maximum width of the oscilloscope it depends on the monitor configuration
		# if w outside the range no change happens
		if w.between?(50, 300)
			@width = w
		end
	end

	def set_scale(scale=0.05)
		# decides the time per unit xwidth
		# to avoid waveform distortion follow nyquist sampling theorem
		# i.e. if the least time period of the waveform is T
		# Set the scale to be greater than T/2 [preferably T/5 - to avoid edge sampling effects]

		@scale = scale
	end

	def set_inputs(*inputs)
		# sets inputs using a list of tuples
		# example - os.set_inputs((conn1, "label"), ...)
		clear(true)

		if inputs.length < 1
			raise "too few inputs given"
		end

		if inputs.length > @max_inp - @len_inputs
			raise "maximum inputs exceeded"
		end

		inputs.each do |inp|
			if not (inp.is_a?(Array) and inp[0].is_a?(Connector) and inp[1].is_a?(String))
				raise "invalid input format"
			end
		end
		
		inputs.each do |inp|
			if not @labels.include?(inp[0])
				@inputs << inp[0]
			end
			@labels[inp[0]] = inp[1][0, 5].rjust(5, ' ')		
		end

		@len_inputs = @inputs.length
	end

	def set_color(foreground=nil, background=nil)
		# acceptable values are 1 = RED, 2 = GREEN, 4 = BLUE, 7 = WHITE
		# will run without an issue on most linux systems

		if foreground.nil? and background.nil?
			@color = "\x1b[0m"
		else
			@color = "\x1b[3#{foreground}m\x1b[4#{background}m"
		end
	end

	def disconnect(connector)
		# disconnect connection from input dictionary
		self.hold()
		clear(true)
		@labels.delete(connector)
		@inputs.delete(connector)
		@len_inputs = @inputs.length
	end

	def display
		self.hold()

		begin
			sclstr = "SCALE - X-AXIS : 1 UNIT WIDTH = #{@scale}"
			llen = @width + 15
			disp = @color + ("=" * llen) + "\nOscilloscope\n" + ("=" * llen)
			disp += N_ + sclstr.rjust(llen, " ") + N_ + ("=" * llen) + N_ 

			@len_inputs.times do |i|
				conn = @inputs[i]

				lA2 = [0] + @logic_array[i] + [0]
				lA = Array.new
				lA2.each do |j|
					lA << (if j.nil? then 0 else j end)
				end

				disp += " " * 10 + V_ + N_
				disp += " " * 10 + V_ + N_
				disp += " " * 10 + V_ + " "

				(1..(lA.length - 2)).each do |i|
					cmpstr = [lA[i - 1], lA[i]]
					if cmpstr == [1, 0]
						disp += HVD_
					elsif cmpstr == [1, 1]
						disp += H_
					elsif cmpstr == [0, 0]
						disp += " "
					elsif cmpstr == [0, 1]
						disp += VHU_
					end
				end

				disp += N_ + (" " * 3) + @labels[conn] + "  " + V_ + " "

				(1..(lA.length - 2)).each do |i|
					cmpstr = [lA[i - 1], lA[i]]
					if cmpstr == [1, 0]
						disp += V_
					elsif cmpstr == [0, 1]
						disp += V_
					else 
						disp += " "
					end
				end

				disp += N_ + (" " * 10) + H_ + " "

				(1..(lA.length - 2)).each do |i|
					cmpstr = [lA[i - 1], lA[i]]
					if cmpstr == [1, 0]
						disp += VHD_
					elsif cmpstr == [1, 1]
						disp += " "
					elsif cmpstr == [0, 0]
						disp += H_
					elsif cmpstr == [0, 1]
						disp += HVU_
					end
				end
				disp += N_ + (" " * 10) + V_ + N_
				disp += (" " * 10) + V_ + N_
			end

			disp += V_ * llen + N_
			disp += H_ * llen + N_ + "\x1b[0m"
			print(disp)
		rescue 
			print("\x1b[0mERROR: Display error - Restart the Oscilloscope. If problem persist please submit an issue at the homepage of gem.\n")
		end
	end	

private

	def sampler(trig_point)
		@len_inputs.times do |i|
			@logic_array[i][trig_point] = @inputs[i].state
		end
	end

	def clear(keep_inputs=false)
		print("\x1b[0m")

		self._clear_LA()

		if not keep_inputs
			@inputs = Array.new
			@len_inputs = 0
		end

	end

end
