require "open-uri"
require "nokogiri"

def fetch_movie_urls
  url = "https://www.imdb.com/chart/top"
  response = open(url, 'Accept-Language' => 'en').read
  doc = Nokogiri::HTML(response)
  hrefs = []
  doc.search('.titleColumn a').first(5).each do |link|
    hrefs << "http://www.imdb.com#{link.attributes['href'].value}"
  end
  hrefs
end

def scrape_movie(url)
  response = open(url, "Accept-Language" => "en").read
  doc = Nokogiri::HTML(response)
  m = doc.search("h1").text.match /(.*)[[:space:]]\((\d{4})\)/
  title = m[1]
  year = m[2].to_i

  storyline = doc.search(".plot_summary div:first-child").text.strip
  director = doc.search("h4:contains('Director:') + a").text
  cast = []
  doc.search(".primary_photo + td a").take(3).each do |element|
    cast << element.text.strip
  end

  { title: title, year: year, storyline: storyline, cast: cast, director: director }
end
