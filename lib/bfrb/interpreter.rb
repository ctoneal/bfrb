require File.expand_path(File.join(File.dirname(__FILE__), "memory.rb"))

module BfRb
	# interprets brainfuck code
	class Interpreter
	
		# initialize the interpreter
		def initialize
			@memory = Memory.new
			initialize_environment
		end
		
		# cleans the memory and initializes member variables
		def initialize_environment
			@memory.clear
			@program_counter = 0
			@memory_counter = 0
			@code = ""
			@loop_stack = []
		end
		
		def run(code)
			@code = code
			evaluate_code
		end
		
		def evaluate_code
			while ((0 <= @program_counter) and (@program_counter < @code.length))
				evaluate_instruction
			end
		end
		
		def evaluate_instruction
			case @code[@program_counter]
			when ">"
				@memory_counter += 1
			when "<"
				if @memory_counter > 1
					@memory_counter -= 1
				else
					@memory_counter = 0
				end
			when "+"
				@memory.set(@memory_counter, @memory.get(@memory_counter) + 1)
			when "-"
				@memory.set(@memory_counter, @memory.get(@memory_counter) - 1)
			when "."
				print @memory.get(@memory_counter).chr
			when ","
				input = $stdin.gets.getbyte(0)
				@memory.set(@memory_counter, input)
			when "["
				if @memory.get(@memory_counter) != 0
					@loop_stack.push @program_counter
				else
					bracket_counter = 1
					while ((bracket_counter != 0) and (@program_counter < @code.length - 1))
						@program_counter += 1
						if @code[@program_counter] == "["
							bracket_counter += 1
						elsif @code[@program_counter] == "]"
							bracket_counter -= 1
						end
					end
				end
			when "]"
				matching_bracket = @loop_stack.pop
				if @memory.get(@memory_counter) != 0
					@program_counter = matching_bracket - 1
				end
			end
			@program_counter += 1
		end
	end
end