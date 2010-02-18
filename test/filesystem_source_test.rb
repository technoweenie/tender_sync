require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

class TestFilesystemSource < Test::Unit::TestCase
  def setup
    @config = TenderSync::Config.new
    @config.path = File.join(File.dirname(__FILE__), 'sample')
    @source = TenderSync::Sources::Filesystem.new(@config)
  end

  def test_builds_tender_sync_dir_from_fetched_faqs
    dir = @source.fetch_dir

    assert (faqs = dir['abc'])
    assert_equal 'abc', faqs[0].filename
    assert_equal 'abc', faqs[0].body
    assert_equal 'def', faqs[1].filename
    assert_equal 'def', faqs[1].body
  end
end