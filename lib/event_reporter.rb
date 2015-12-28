require_relative 'data_loader'
require_relative 'queue'
require 'pry'

class EventReporter
  attr_reader :data, :queue, :data_loader

  def initialize
    @data_loader = DataLoader.new
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
    @data = @data_loader.load(file)
  end

  def clear_queue
    @queue.clear
  end
end

if __FILE__ == $0
  event_reporter = EventReporter.new

  puts "Welcome to Event Reporter"

  loop do
    puts "\nPlease enter a command:"
    command = gets.chomp

    if command.start_with?('load')
      if command.split.count == 1
        filename = './data/event_attendees.csv'
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
    end
  end

end
