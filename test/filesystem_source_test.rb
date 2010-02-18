require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

class TestApiSource < Test::Unit::TestCase
  def setup
    @source = TenderSync::Sources::Filesystem.new(File.join(File.dirname(__FILE__), 'sample'))
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