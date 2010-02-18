require 'rubygems'
require 'rake'

namespace :tsync do
  desc "fetches FAQ articles from Tender into the local filesystem"
  task :fetch => :load_config do
    api = TenderSync::Sources::Api.new($config)
    fs  = TenderSync::Sources::Filesystem.new($config)
    dir = api.fetch_dir
    fs.write_dir(dir)
  end

  desc "helps you configure your tender-sync settings"
  task :config do
    sample = <<-SAMPLE
tender:
  path: "faqs/tender_support"
  site: "help"
  api_key: "abc123foo"
    SAMPLE
    if File.exist?("config.yml")
      puts "A sample config file might look like:"
      puts sample
    else
      File.open('config.yml', 'w') do |f|
        f << sample
      end
      puts "This has been written to config.yml, your shiny new config file:"
      puts sample
    end
    puts
    puts "Now, you can fetch FAQs from tender with:"
    puts "  rake tsync:fetch SITE=tender"
  end

  task :load_config do
    $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
    require 'tender_sync'

    config = nil
    if File.exist?("config.yml")
      require 'yaml'
      global_config = YAML.load_file("config.yml")
      config = global_config[ENV['SITE'].to_s]
    end

    if config
      $config = TenderSync::Config.new
      config.each do |key, value|
        $config.send "#{key}=", value
      end
    else
      puts "Invalid Site: #{ENV['SITE'].inspect}"
      if File.exist?("config.yml")
        puts "Check config.yml"
      else
        puts
        Rake::Task['tsync:config'].execute
      end
      exit
    end
  end
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "tender_sync"
    gem.summary = %Q{sync Tender FAQs to and from Tender}
    gem.description = %Q{sync Tender FAQs to and from Tender}
    gem.email = "technoweenie@gmail.com"
    gem.homepage = "http://github.com/technoweenie/tender_sync"
    gem.authors = ["rick"]
    gem.add_dependency "faraday", "~> 0.2.0"
    gem.add_dependency 'yajl-ruby'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "tender_sync #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
