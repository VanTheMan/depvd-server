namespace :db do
  desc "Crawl albums"
  task crawl_albums: :environment do
    tags = [ 'new', 'vn', 'asia', 'us-uk']
    tags.each do |tag|
      puts "Crawl #{tag}"
      Crawl.crawl_from_tag(tag)
    end
  end

  desc "Crawl photos"
  task crawl_photos: :environment do
    Album.all.each do |album|
      Crawl.crawl_photo_from_album(album.url)
    end
  end
end