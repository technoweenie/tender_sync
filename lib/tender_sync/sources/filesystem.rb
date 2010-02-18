class TenderSync::Sources::Filesystem
  attr_reader :path

  def initialize(path = nil)
    self.path = path
  end

  def path=(v)
    @path = v ? File.expand_path(v) : nil
  end

  def fetch_dir
    if !@path
      raise ArgumentError, "Path cannot be nil"
    end

    dir = TenderSync::Dir.new
    Dir[path + "/**/*.mkdn"].each do |file|
      faq = file[path.size+1..-1]
      section, filename = faq.split("/")
      permalink, ext = filename.split(".")
      dir.add section, TenderSync::Dir::File.new(permalink, lambda { IO.read(file) })
    end
    dir
  end
end