require_relative 'data_loader'
require_relative 'queue'
require 'pry'

class EventReporter
  attr_reader :data, :queue

  def valid_commands
    {
      'load <filename>' => "Erases any loaded data and parses the specified file. If no filename is  given, default is event_attendees.csv.",
      'help' => "Outputs a listing of available commands.",
      'help <command>' => "Outputs a description of how to use the specific command.",
      'queue count' => "Outputs how many records are in the current queue.",
      'queue clear' => "Empties the queue.",
      'queue print' => "Prints out a tab-delimited data table with headers.",
      'queue print by <attribute>' => "Prints the data table sorted by the specified attribute.",
      'queue save to <filename.csv>' => "Exports the current queue to the specified filename as a CSV.",
      'find <attribute> <criteria>' => "Loads the queue with all records matching the criteria for the given attribute."
    }
  end

  def initialize
    @queue = Queue.new
  end

  def find(options)
    return if @data.nil?

    attribute = options.keys.first
    matcher = generate_matcher(options.values.first)

    results = @data.find_all { |row| row[attribute] =~ matcher }
    @queue.update_results(results)
  end

  def generate_matcher(criteria)
    /\A\s*#{criteria}\s*\z/i
  end

  def load(file)
    @data = DataLoader.new.load(file)
  end

  def clear_queue
    @queue.clear
  end

  def print
    @queue.print
  end
end

if __FILE__ == $0
  event_reporter = EventReporter.new

  puts "Welcome to Event Reporter"

  loop do
    puts "\nPlease enter a command:"
    command = gets.chomp

    break if command == 'exit'

    if command.start_with?('load')
      if command.split.count == 1
        filename = 'event_attendees.csv'
      else
        filename = command.split.last
      end

      event_reporter.load(filename)
      puts "Data loaded from file: #{filename}"
    elsif command == 'queue count'
      puts "Number of records in current queue: #{event_reporter.queue.count}"
    elsif command == 'queue clear'
      event_reporter.clear_queue
      puts "Queue has been cleared."
    elsif command.start_with?('find')
      options = {}
      attribute, criteria = command.split[1..2]
      options[attribute.to_sym] = criteria

      event_reporter.find(options)
      puts "Queue loaded with #{event_reporter.queue.count} matching records"
    elsif command == 'queue print'
      puts event_reporter.print
    elsif command == 'help'
      puts "\nThe following commands are available:"
      puts event_reporter.valid_commands.keys
    elsif command.start_with?('help')
      function = command[5..-1]

      if event_reporter.valid_commands.keys.include?(function)
        puts "\nThe function #{function} does the following:"
        puts event_reporter.valid_commands[function]
      else
        puts "\nThe function #{function} is not a recognized function"
      end
    end
  end

  puts "Exiting Event Reporter"
end
