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

  def test_srites_tender_sync_dir_to_filesystem
    dir = TenderSync::Dir.new
    dir.add 'foo', TenderSync::Dir::File.new('foo',    'foo')
    dir.add 'foo', TenderSync::Dir::File.new('foobar', 'foobar')
    dir.add 'bar', TenderSync::Dir::File.new('foobar', 'foobar')

    @source.write_dir(dir)

    assert_equal 'foo',    IO.read(File.join(@config.path, 'foo', 'foo.mkdn'))
    assert_equal 'foobar', IO.read(File.join(@config.path, 'foo', 'foobar.mkdn'))
    assert_equal 'foobar', IO.read(File.join(@config.path, 'bar', 'foobar.mkdn'))
  ensure
    FileUtils.rm_rf File.join(@config.path, 'foo')
    FileUtils.rm_rf File.join(@config.path, 'bar')
  end
end