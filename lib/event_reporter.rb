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
