# Special hash where keys are sections and values are arrays of article files
class TenderSync::Dir < Hash
  class File < Struct.new(:filename, :body)
  end

  def add(section, file)
    (self[section] ||= []) << file
  end
end