require_relative 'command_processor'

def user_wants_to_exit(command)
  command == 'exit' || command == 'quit'
end

processor = CommandProcessor.new

puts "=========================="
puts "Welcome to Event Reporter!"
puts "=========================="

loop do
  puts "\nPlease enter a command, or 'help' to see a listing of commands:"
  command = gets.chomp

  break if user_wants_to_exit(command)

  response = processor.generate_response(command)
  puts response
end

puts "Thank you for using Event Reporter!"
