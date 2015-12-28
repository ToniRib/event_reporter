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
    results = [1, 2, 3]

    q.update_results(results)
    assert_equal 3, q.count
    assert_equal results, q.results

    q.clear
    assert_equal 0, q.count
    assert_nil q.results
  end
end
