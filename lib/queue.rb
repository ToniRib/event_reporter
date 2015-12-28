class Queue
  attr_reader :count, :results

  def initialize
    @count = 0
  end

  def clear
    @count = 0
    @results = nil
  end

  def update_results(data)
    @results = data
    @count = data.count
  end

  def headers
    ["LAST NAME", "FIRST NAME", "EMAIL", "ZIPCODE", "CITY", "STATE", "ADDRESS", "PHONE"].join("\t")
  end
end
