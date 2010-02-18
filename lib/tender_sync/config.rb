require 'faraday'

class TenderSync::Config < Struct.new(:site, :api_key)
  def create_connection
    Faraday::Connection.new "https://api.tenderapp.com/#{site}?auth=#{api_key}" do |c|
      c.request  :yajl
      c.use :net_http
      c.response :yajl
    end
  end
end