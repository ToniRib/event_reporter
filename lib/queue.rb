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

  def print
    create_table(@results)
  end

  def print_by(attribute)
    sorted = results.sort_by { |r| r[attribute] }
    create_table(sorted)
  end

  def create_table(data)
    rows = data.map do |r|
      [r[:last_name], r[:first_name], r[:email_address], r[:zipcode], r[:city],
       r[:state], r[:street], r[:homephone]].join("\t")
    end
    table = self.headers + "\n"
    rows.each { |r| table += r + "\n" }
    table
  end

  def headers
    ["LAST NAME", "FIRST NAME", "EMAIL", "ZIPCODE", "CITY", "STATE", "ADDRESS", "PHONE"].join("\t")
  end
end
