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
			puts "For interpreter commands, type 'help'"
			while true
				puts ""
				print "bfrb> "
				input = gets.chomp
				case input
				when "help"
					repl_help
				when "exit", 24.chr
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
		
		# prints out a help message
		def repl_help
			puts "'exit' or Ctrl-X leaves the REPL"
			puts "'mem' displays the value in the current cell of memory"
			puts "'clear' clears everything from memory"
			puts "'help' displays this message"
		end
	end
end