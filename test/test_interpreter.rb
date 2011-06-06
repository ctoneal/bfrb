require 'helper'

module BfRb
	class TestInterpreter < Test::Unit::TestCase
		def setup
			@interpreter = Interpreter.new
		end

		context ">" do	
			should "increment the memory counter" do
				initial_mc = @interpreter.memory_counter
				@interpreter.evaluate_instruction(">")
				assert_equal(initial_mc + 1, @interpreter.memory_counter)
			end
			
		end
		
		context "<" do
			should "decrement the memory counter" do
				@interpreter.evaluate_instruction(">")
				initial_mc = @interpreter.memory_counter
				@interpreter.evaluate_instruction("<")
				assert_equal(initial_mc - 1, @interpreter.memory_counter)
			end
			
			should "not decrement below zero" do
				@interpreter.evaluate_instruction("<")
				assert_equal(0, @interpreter.memory_counter)
			end
		end
		
		context "+" do			
			should "increment the current value in memory" do
				initial_value = @interpreter.current_memory
				@interpreter.evaluate_instruction("+")
				assert_equal(initial_value + 1, @interpreter.current_memory)
			end
		end
		
		context "-" do			
			should "decrement the current value in memory" do
				@interpreter.evaluate_instruction("+")
				initial_value = @interpreter.current_memory
				@interpreter.evaluate_instruction("-")
				assert_equal(initial_value - 1, @interpreter.current_memory)
			end
			
			should "not decrement below zero" do
				@interpreter.evaluate_instruction("-")
				assert_equal(0, @interpreter.current_memory)
			end
		end
		
		context "[]" do
			should "loop properly if value in memory is not zero" do
				@interpreter.evaluate_instruction("+")
				initial_value = @interpreter.program_counter
				@interpreter.evaluate_instruction("[")
				@interpreter.evaluate_instruction("+")
				@interpreter.evaluate_instruction("]")				
				assert_equal(initial_value, @interpreter.program_counter)
			end
			
			should "break out of the loop if value in memory is zero" do
				@interpreter.evaluate_instruction("+")
				initial_value = @interpreter.program_counter
				@interpreter.evaluate_instruction("[")
				@interpreter.evaluate_instruction("-")
				@interpreter.evaluate_instruction("]")				
				assert_not_equal(initial_value, @interpreter.program_counter)
			end
		end		
	end
end