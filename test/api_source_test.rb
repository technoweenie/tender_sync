require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

class TestApiSource < Test::Unit::TestCase
  def setup
    @config = TenderSync::Config.new 'help', 'abc'
    @source = TenderSync::Sources::Api.new(@config)

  end

  def test_fetches_multiple_pages_of_faqs
    setup_connection_for_faqs
    assert_equal [
        {:section => 'abc', :permalink => 'abc', :body => 'abc'},
        {:section => 'abc', :permalink => 'def', :body => 'def'}
      ], @source.fetch
  end

  def test_builds_tender_sync_dir_from_fetched_faqs
    setup_connection_for_faqs
    dir = @source.fetch_dir

    assert (faqs = dir['abc'])
    assert_equal 'abc', faqs[0].filename
    assert_equal 'abc', faqs[0].body
    assert_equal 'def', faqs[1].filename
    assert_equal 'def', faqs[1].body
  end

  def setup_connection_for_faqs
    setup_connection do |stub|
      stub.get 'faqs?page=1' do |env|
        [200, {}, '{"faqs":[{"html_href":"https://abc.com/faqs/abc/abc","body":"abc"}],"offset":0,"per_page":1,"total":2}']
      end
      stub.get 'faqs?page=2' do |env|
        [200, {}, '{"faqs":[{"html_href":"https://abc.com/faqs/abc/def","body":"def"}],"offset":1,"per_page":1,"total":2}']
      end
    end
  end

  def setup_connection
    @source.connection = Faraday::Connection.new do |c|
      c.request  :yajl
      c.adapter :test do |stub|
        yield stub
      end
      c.response :yajl
    end
  end
end