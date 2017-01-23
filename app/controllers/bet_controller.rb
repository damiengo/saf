class BetController < ApplicationController

  def index
    # Predictions

    url = "https://projects.fivethirtyeight.com/soccer-predictions/ligue-1/"
    resp = Net::HTTP.get_response(URI.parse(url))
    data = resp.body

    # File.open("/tmp/538.html", 'w:UTF-8') { |file| file.write(data.encode('UTF-8', {
    #   :invalid => :replace,
    #   :undef   => :replace,
    #   :replace => '?'
    # })) }

    first_page = Nokogiri::HTML(data, nil, "utf-8")
    first_page.css(".match-container").each do |match|
      home_team = match.css(".match-top .team-div .name").text
      away_team = match.css(".match-bottom .team-div .name").text
      home_prob = match.css(".match-top .prob:not(.tie-prob)").text.chop
      away_prob = match.css(".match-bottom .prob:not(.tie-prob)").text.chop
      tie_prob  = match.css(".match-top .tie-prob").text.chop

      puts home_team + " - " + away_team + ": " + home_prob.to_s + "/" + tie_prob.to_s + "/" + away_prob.to_s
    end

    # Odds
    source = 'https://www.parionssport.fr/api/1n2/offre?competition=[241,315,317,322,325]&sport=100'
    resp = Net::HTTP.get_response(URI.parse(source))
    data = resp.body
    @odds = JSON.parse(data)
  end

end
