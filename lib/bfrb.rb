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
	end
end