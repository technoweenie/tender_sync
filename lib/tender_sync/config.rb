require 'faraday'

class TenderSync::Config
  attr_accessor \
    :site, :api_key, # Tender API
    :path            # Filesystem
  def initialize(site = nil, api_key = nil)
    @site, @api_key = site, api_key
  end

  def create_connection
    options = {:headers => {'X-Tender-Auth' => @api_key, 'Accept' => 'application/vnd.tender-v1+json'}}
    Faraday::Connection.new "https://api.tenderapp.com/#{@site}", options do |c|
      c.request  :yajl
      c.adapter  :net_http
      c.response :yajl
    end
  end
end