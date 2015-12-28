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
    criteria = options.values.first
    matcher = /\A\s*#{criteria}\s*\z/i

    results = @data.find_all { |row| row[attribute] =~ matcher }
    @queue.count = results.count
    results
  end

  def load(file)
    @data = @data_loader.load(file)
  end
end
