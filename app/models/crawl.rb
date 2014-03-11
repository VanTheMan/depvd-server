require 'open-uri'

class Crawl
  def self.get_lac(url)
    doc = Nokogiri::HTML(open(url))
    jstext = doc.css("head").css("script").last.text
    lac = jstext.gsub!(/\D/,"")
  end

  def crawl_first_albums(url)
    doc = Nokogiri::HTML(open(url))
    doc.css(".vd-topic").each do |element|
      title = element.css('.vd-topic-title').text.gsub("\t", "")
      album_url = element.css('a').attr('href').value
      widget_url = element.css('img').attr('src').value
      upload_time = element.css('.vd-user').css('span').text.gsub(", ","")
      Album.create(title: title, url: album_url, widget_url: widget_url, upload_time: upload_time)
    end
  end

  def crawl_photo_from_album(url)
    doc = Nokogiri::HTML(open('url'))
    doc.css('.item').each do |element|
      link = element.css('img').attr('data-original').value
      Beauty.create(url: link)
    end    
  end

  def get_album_from_json(url)
    conn = Faraday.new(:url => 'http://www.depvd.com') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    lac = Crawl.get_lac('http://www.depvd.com/new')
    response = conn.post do |req| 
      req.url '/pajax/topic/list/new'
      req.body = '{ "lac" : lac, "p.cp" : 2 }'
    end
    binding.pry
  end

	def crawl_from_tag
  	{
      'new'   => 'http://www.depvd.com/pajax/topic/list/new', # lac: 1365999014000
      'vn'    => 'http://www.depvd.com/pajax/topic/list/vn', # lac: 1366001460000
      'asia'  => 'http://www.depvd.com/pajax/topic/list/asia', # lac: 1365961278000
      'us-uk' => 'http://www.depvd.com/pajax/topic/list/us-uk', # lac: 1365662277000
    }.each do |tag, page_url|
      # TODO Add crawler code
    end
	end
end
