class TenderSync::Sources::Api
  attr_writer :connection

  def initialize(config = nil)
    @config, @connection = config, nil
  end

  def fetch_dir
    dir = TenderSync::Dir.new
    fetch.each do |faq|
      dir.add faq[:section], TenderSync::Dir::File.new(faq[:permalink], faq[:body])
    end
    dir
  end

  def fetch(page=1)
    resp = connection.get "faqs?page=#{page}"
    total, per_page, offset, faqs = resp.body['total'], resp.body['per_page'], resp.body['offset'], resp.body['faqs']
    if faqs.size.zero?
      []
    else
      extras = offset+faqs.size >= total ? [] : fetch(page+1)
      all = faqs + extras
      if page == 1
        all.map! do |faq|
          href = faq['html_href']
          section, perma = href.scan(/\/\/[^\/]+\/faqs\/([^\/]+)\/([^\/]+)/).first
          {:section => section, :permalink => perma, :body => faq['body']}
        end.delete_if { |faq| !faq[:section] }
      end
      all
    end
  end

  def connection
    @connection ||= @config.create_connection
  end
end