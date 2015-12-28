require 'csv'
require 'sunlight/congress'
require 'erb'
require 'date'
require 'pry'

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

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

def find_hour(date_string)
  convert_to_date_object(date_string).hour
end

def find_day(date_string)
  day = convert_to_date_object(date_string).wday
  convert_to_day_name(day)
end

def convert_to_day_name(day_int)
  case day_int
  when 0
    'Sunday'
  when 1
    'Monday'
  when 2
    'Tuesday'
  when 3
    'Wednesday'
  when 4
    'Thursday'
  when 5
    'Friday'
  when 6
    'Saturday'
  end
end

def convert_to_date_object(date_string)
  DateTime.strptime(date_string, '%m/%d/%y %H:%M')
end

def legislators_by_zipcode(zipcode)
  Sunlight::Congress::Legislator.by_zipcode(zipcode)
end

def save_thank_you_letters(id,form_letter)
  Dir.mkdir("output") unless Dir.exists?("output")

  filename = "output/thanks_#{id}.html"

  File.open(filename,'w') do |file|
    file.puts form_letter
  end
end

puts "EventManager initialized."

contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol

# template_letter = File.read "form_letter.erb"
# erb_template = ERB.new template_letter
hours = []
days = []

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  phone = clean_phone_number(row[:homephone])
  zipcode = clean_zipcode(row[:zipcode])
  hour = find_hour(row[:regdate])
  day = find_day(row[:regdate])
  hours << hour
  days << day
  # legislators = legislators_by_zipcode(zipcode)

  puts "#{name} | #{phone} | #{zipcode} | #{hour} | #{day}"
  #
  # form_letter = erb_template.result(binding)
  #
  # save_thank_you_letters(id,form_letter)
end

hour_freq = hours.inject(Hash.new(0)) { |k, v| k[v] += 1; k }.sort_by { |k, v| v }.reverse
p hour_freq

day_freq = days.inject(Hash.new(0)) { |k, v| k[v] += 1; k }.sort_by { |k, v| v }.reverse
p day_freq
