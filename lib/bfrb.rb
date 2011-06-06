require File.expand_path(File.join(File.dirname(__FILE__), "bfrb", "interpreter.rb"))

module BfRb
	# loads and interprets brainfuck code
	class Base
		
		# initialize the interpreter
		def initialize
			@interpreter = Interpreter.new
		end
		
		# run the given brainfuck code
		def run(code)
			@interpreter.run(code)
		end
		
		# load brainfuck code from a file and run it
		def load_file(file_path)
			code = File.open(file_path) { |f| f.read }
			run(code)
		end
		
		# interactive read-evaluate-print loop
		def repl
			puts "'exit' leaves the REPL"
			puts "'mem' displays the value in the current cell of memory"
			puts "'clear' clears everything from memory"
			while true
				puts ""
				print "bf> "
				input = gets.chomp
				case input
				when "exit"
					puts "Exiting"
					break
				when "mem"
					puts "Cell: #{@interpreter.memory_counter} Value: #{@interpreter.current_memory}"
				when "clear"
					@interpreter.initialize_environment
				else
					@interpreter.run(input)
				end
			end
		end
	end
end