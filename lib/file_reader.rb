require 'csv'

class FileReader
  def read(file)
    CSV.readlines(file, headers: true, header_converters: :symbol)
  end
end
