require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

class TestConfig < Test::Unit::TestCase
  def setup
    @config = TenderSync::Config.new 'abc', 'def'
    @conn   = @config.create_connection
  end

  def test_creates_faraday_connection
    assert_kind_of Faraday::Connection, @conn
  end

  def test_sets_tender_site_from_config
    assert_equal '/abc', @conn.path_prefix
  end

  def test_sets_api_key_from_config
    assert_equal 'def', @conn.params['auth']
  end
end