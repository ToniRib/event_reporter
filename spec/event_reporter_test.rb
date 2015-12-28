require 'event_reporter'
require 'minitest/autorun'
require 'minitest/pride'

class EventReporterTest < Minitest::Test
  def test_finds_all_entries_with_first_name_john
    er = EventReporter.new
    file = './data/event_attendees.csv'
    er.load(file)

    er.find(first_name: 'John')

    assert_equal 63, er.queue.count
  end
end
