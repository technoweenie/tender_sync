require 'faraday'

# required keys:
#   for Tender API
#     'site'
#     'api_key'
class TenderSync::Config < Hash
  def initialize(site = nil, api_key = nil)
    update 'site' => site, 'api_key' => api_key
  end

  def create_connection
    options = {:headers => {'X-Tender-Auth' => self['api_key'], 'Accept' => 'application/vnd.tender-v1+json'}}
    Faraday::Connection.new "https://api.tenderapp.com/#{self['site']}", options do |c|
      c.request  :yajl
      c.adapter  :net_http
      c.response :yajl
    end
  end
end