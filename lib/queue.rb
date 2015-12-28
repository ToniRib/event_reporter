class Queue
  attr_reader :count

  def initialize
    @count = 0
  end

  def update_count(num)
    @count = num
  end

  def clear
    @count = 0
  end
end
