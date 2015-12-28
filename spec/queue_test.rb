require 'queue'
require 'minitest/autorun'
require 'minitest/pride'

class QueueTest < Minitest::Test
  def test_initial_queue_count_is_zero
    q = Queue.new

    assert_equal 0, q.count
  end

  def test_clear_resets_queue_count_back_to_zero
    q = Queue.new
    q.update_count(10)

    assert_equal 10, q.count

    q.clear

    assert_equal 0, q.count
  end
end
