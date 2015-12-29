require 'pry'
require_relative 'file_reader'
require_relative 'queue'

class CommandProcessor
  attr_reader :data, :queue

  def initialize
    @queue = Queue.new
  end

  def generate_response(command)
    if load_file?(command)
      file = determine_file(command)
      @data = FileReader.new.read(file)
      response_prompt("Loaded data from #{file}")
    elsif help?(command)
      determine_help_response(command)
    elsif queue_or_find?(command)
      determine_queue_response(command)
    end
  end

  def help?(command)
    command.start_with?('help')
  end

  def load_file?(command)
    command.start_with?('load')
  end

  def queue_or_find?(command)
    command.start_with?('queue') || command.start_with?('find')
  end

  def determine_file(command)
    if command.length > 4
      command.split.last
    else
      'event_attendees.csv'
    end
  end

  def determine_help_response(command)
    if command.length > 4
      response_prompt(all_commands[command[5..-1]])
    else
      build_string_of_all_commands
    end
  end

  def determine_queue_response(command)
    case command
    when 'queue count'
      response_prompt(queue.count)
    when 'queue clear'
      queue.clear
      response_prompt("Queue has been cleared")
    when /find/
      attribute = command.split[1]
      criteria = command.split[2..-1].join(' ')
      find(attribute.to_sym, criteria)
      response_prompt("#{queue.count} items loaded into the queue")
    when 'queue print'
      return response_prompt("No data to print") if data.nil?
      
      response_prompt("All Records in Queue:\n") + queue.print
    when /queue print by/
      return response_prompt("No data to print") if data.nil?

      attribute = command[15..-1]
      response_prompt("All Records in Queue Sorted By #{attribute}:\n") + queue.print_by(attribute.to_sym)
    when /queue save to/
      filename = command[14..-1]
      queue.save(filename)
      response_prompt("Queue data saved to #{filename}")
    end
  end

  def find(attribute, criteria)
    return if @data.nil?

    matcher = generate_matcher(criteria)

    results = @data.find_all { |row| row[attribute] =~ matcher }
    @queue.update_results(results)
  end

  def generate_matcher(criteria)
    /\A\s*#{criteria}\s*\z/i
  end

  def response_prompt(response)
    ">> #{response}"
  end

  def build_string_of_all_commands
    command_str = ""
    all_commands.each { |k, v| command_str += "#{k}  --\t#{v}\n" }
    response_prompt("Available Commands:\n") + command_str
  end

  def all_commands
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
end
