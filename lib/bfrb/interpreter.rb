require File.expand_path(File.join(File.dirname(__FILE__), "memory.rb"))

module BfRb
	# interprets brainfuck code
	class Interpreter
	
		attr_reader :program_counter, :memory_counter
		attr_accessor :input_stream, :output_stream
	
		# initialize the interpreter
		def initialize
			@memory = Memory.new
			initialize_environment
			@input_stream = $stdin
			@output_stream = $stdout
		end
		
		# cleans the memory and initializes member variables
		def initialize_environment
			@memory.clear
			@program_counter = 0
			@memory_counter = 0
			@code = ""
			@loop_stack = []
		end
		
		# run a given piece of code
		def run(code)
			@code += code.delete "^[]<>.,+-"
			if check_for_matching_braces
				catch :quit do
					evaluate_code
				end
			end
		end
		
		# checks the code to be run to make sure all braces match
		def check_for_matching_braces
			brace_counter = 0
			@code.each_char do |char|
				if char == "["
					brace_counter += 1
				elsif char == "]"
					brace_counter -= 1
					if brace_counter < 0
						@output_stream.puts "Unmatched ]"
						return false
					end
				end
			end
			if brace_counter > 0
				@output_stream.puts "Unmatched ["
				return false
			end
			return true
		end
		
		# evaluate each instruction in the current code
		def evaluate_code
			while ((0 <= @program_counter) and (@program_counter < @code.length))
				evaluate_instruction(@code[@program_counter])
			end
		end
		
		# evaluate an individual instruction
		def evaluate_instruction(instruction)
			case instruction
			# shift right in memory
			when ">"
				@memory_counter += 1
			# shift left in memory, unless we're at the beginning
			when "<"
				if @memory_counter > 1
					@memory_counter -= 1
				else
					@memory_counter = 0
				end
			# increment value in memory
			when "+"
				@memory.set(@memory_counter, current_memory + 1)
			# decrement value in memory
			when "-"
				unless current_memory == 0
					@memory.set(@memory_counter, current_memory - 1)
				end
			# print value in memory
			when "."
				@output_stream.print current_memory.chr
			# input a character into memory
			when ","
				@output_stream.puts
				input = @input_stream.gets.getbyte(0)
				if input == 24
					throw :quit
				end
				@memory.set(@memory_counter, input)
			# jump to the closing bracket if memory is 0
			when "["
				if current_memory != 0
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
			# return to the opening bracket if memory is not zero
			when "]"
				matching_bracket = @loop_stack.pop
				if current_memory != 0
					@program_counter = matching_bracket - 1
				end
			end
			@program_counter += 1
		end
		
		# returns the value in the current memory cell
		def current_memory
			return @memory.get(@memory_counter)
		end
	end
end