module BfRb
	# memory for brainfuck interpreter
	class Memory
	
		# initialize the memory
		def initialize
			clear
		end
		
		# get the value at the given address
		def get(address)
			unless @mem.has_key?(address)
				set(address, 0)
			end
			return @mem[address]
		end
		
		# set the given address to a certain value
		def set(address, value)
			@mem[address] = value
		end
		
		# clear the memory
		def clear
			@mem = {}
		end
	end
end