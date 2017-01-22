class BetController < ApplicationController

  def index
    # Predictions

    url = "https://projects.fivethirtyeight.com/soccer-predictions/ligue-1/"
    #File.open("/tmp/538.html", 'w') { |file| file.write(session.html) }
    resp = Net::HTTP.get_response(URI.parse(url))
    data = resp.body
    first_page = Nokogiri::HTML(data, nil, "utf-8")
    first_page.css(".match-container").each do |match|
      puts match.css(".match-top")
    end

    # Odds
    source = 'https://www.parionssport.fr/api/1n2/offre?competition=[241,315,317,322,325]&sport=100'
    resp = Net::HTTP.get_response(URI.parse(source))
    data = resp.body
    @odds = JSON.parse(data)
  end

end
