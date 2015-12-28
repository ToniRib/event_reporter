require 'event_reporter'
require 'minitest/autorun'
require 'minitest/pride'

class EventReporterTest < Minitest::Test
  def setup
    @er = EventReporter.new
    file = './data/event_attendees.csv'
    @er.load(file)
  end

  def test_finds_all_entries_with_first_name_john
    @er.find(first_name: 'John')

    assert_equal 63, @er.queue.count
  end

  def test_clear_queue_resets_queue_count_to_zero
    @er.find(first_name: 'John')
    assert_equal 63, @er.queue.count

    @er.clear_queue
    assert_equal 0, @er.queue.count
  end
end
