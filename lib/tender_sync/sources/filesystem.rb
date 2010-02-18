class TenderSync::Sources::Filesystem
  attr_reader   :path
  attr_accessor :config

  def initialize(config = nil)
    self.config = config
  end

  def path=(v)
    @path = v ? File.expand_path(v) : nil
  end

  def path
    if !@path && config && config.path
      self.path = config.path
    end
    @path
  end

  def fetch_dir
    if !path
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