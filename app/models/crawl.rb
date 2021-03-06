require 'open-uri'
require "uri"
require "net/http"
require 'json'

class Crawl
  def self.get_lac(tag)
    url = 'http://www.depvd.com/' + tag
    doc = Nokogiri::HTML(open(url))
    jstext = doc.css("head").css("script").last.text
    lac = jstext.gsub!(/\D/,"")
  end

  def self.crawl_first_albums(tag)
    url = 'http://www.depvd.com/' + tag
    doc = Nokogiri::HTML(open(url))
    doc.css(".vd-topic").each do |element|
      title = element.css('.vd-topic-title').text.gsub("\t", "")
      album_url = element.css('a').attr('href').value
      widget_url = element.css('img').attr('src').value
      upload_time = element.css('.vd-user').css('span').text.gsub(", ","")
      if Album.where(url: album_url, tag: tag).first 
        return nil
      else
        Album.create!(title: title, url: album_url, widget_url: widget_url, upload_time: upload_time, tag: tag)
      end
    end
  end

  def self.crawl_photo_from_album(url)
    doc = Nokogiri::HTML(open(url))
    @albums = Album.where(url: url)
    doc.css('.item').each do |element|
      link = element.css('img').attr('data-original').value
      @albums.each do |album|
        @photo = album.beauties.create!(url: link)
      end
      puts "Crawl photo #{@albums.first.title} #{@photo.url}"
    end    
  end

  def self.get_album_from_json(tag, lac, page)
    params = { "lac" => lac, "p.cp" => page }
    response = Net::HTTP.post_form(URI.parse('http://www.depvd.com/pajax/topic/list/' + tag), params)
    content = JSON.parse(response.body)
    lac = content['lac']
    if content['topics']
      content['topics'].each do |topic|
        title = topic['title']
        album_url = 'http://www.depvd.com/' + topic['viewUrl']
        widget_url = 'http://www.depvd.com/' + topic['widgetImage']
        upload_time = topic['creationTimeString']
        @album = Album.create!(title: title, url: album_url, widget_url: widget_url, upload_time: upload_time, tag: tag)
        puts "Crawl album #{@album.title} #{@album.url}"
      end
      return lac
    else
      return nil
    end
  end

	def self.crawl_from_tag(tag)
  	@firstCrawl = true
    lac = Crawl.get_lac(tag)
    9999.times do |i|
      if @firstCrawl
        if Crawl.crawl_first_albums(tag)
          @firstCrawl = false
        else
          return
        end
      else
        previous_lac = lac
        lac = Crawl.get_album_from_json(tag, lac, i)
        if ( i == 22 && tag == 'us-uk')
          return
        end
        if !lac
          return
        end
      end
    end
	end
end