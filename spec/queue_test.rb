require 'queue'
require 'minitest/autorun'
require 'minitest/pride'

class QueueTest < Minitest::Test
  def setup
    @queue = Queue.new
  end

  def test_initializes_with_count_of_zero
    assert_equal 0, @queue.count
  end

  def test_initializes_with_nil_results
    assert_nil @queue.results
  end

  def test_update_results_updates_both_count_and_results
    data = [1, 2, 3]
    @queue.update_results(data)

    assert_equal 3, @queue.count
    assert_equal data, @queue.results
  end
end
