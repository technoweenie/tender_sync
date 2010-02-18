# Special hash where keys are sections and values are arrays of article files
class TenderSync::Dir < Hash
  class File < Struct.new(:filename, :raw_body)
    def initialize(*args)
      super
      @body = nil
    end

    def body
      @body ||= (raw_body.respond_to?(:call) ? raw_body.call : raw_body).to_s
    end
  end

  def add(section, file)
    (self[section] ||= []) << file
  end
end