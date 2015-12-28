require 'data_loader'
require 'minitest/autorun'
require 'minitest/pride'

class DataLoaderTest < Minitest::Test
  def test_loads_the_event_attendees
    file = 'event_attendees.csv'
    data = CSV.readlines(file, headers: true, header_converters: :symbol)
    loader = DataLoader.new

    loader.load(file)

    assert_equal data, loader.data
  end
end
