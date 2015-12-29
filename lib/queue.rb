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
    rows = data.map { |r| generate_clean_data_string(r) }
    table = table_headers + "\n"
    rows.each { |r| table += r + "\n" }
    table
  end

  def generate_clean_data_string(row)
    [row[:last_name],
     row[:first_name],
     row[:email_address],
     clean_zipcode(row[:zipcode]),
     clean_city_state_or_address(row[:city]),
     clean_city_state_or_address(row[:state]),
     clean_city_state_or_address(row[:street]),
     clean_phone_number(row[:homephone])].join("\t")
  end

  def clean_city_state_or_address(text)
    if text == 'null' || text == 'x'
      'Not Provided'
    else
      text
    end
  end

  def clean_zipcode(zipcode)
    zipcode.to_s.rjust(5,"0")[0..4]
  end

  def remove_unnecessary_chars(number)
    number.gsub!(/\D/, '')
  end

  def bad_number
    '0000000000'
  end

  def good_number?(number)
    number.length == 10
  end

  def number_prefix_one?(number)
    number.length == 11 && number[0] == '1'
  end

  def clean_phone_number(number)
    remove_unnecessary_chars(number)
    if good_number?(number)
      number
    elsif number_prefix_one?(number)
      number[1..-1]
    else
      bad_number
    end
  end

  def table_headers
    ["LAST NAME", "FIRST NAME", "EMAIL", "ZIPCODE", "CITY", "STATE", "ADDRESS", "PHONE"].join("\t")
  end
end
