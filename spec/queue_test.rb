require 'queue'
require 'minitest/autorun'
require 'minitest/pride'

class QueueTest < Minitest::Test
  def test_initial_queue_count_is_zero
    q = Queue.new

    assert_equal 0, q.count
  end
end
