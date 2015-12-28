require 'csv'

class DataLoader
  attr_reader :data

  def load(file)
    @data = CSV.readlines(file, headers: true, header_converters: :symbol)
  end
end
