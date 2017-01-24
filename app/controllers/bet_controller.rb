class BetController < ApplicationController

  def index

    # Predictions
    f538_datas = []

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
      f538_home_team = match.css(".match-top .team-div .name").text.strip
      f538_away_team = match.css(".match-bottom .team-div .name").text.strip
      f538_home_prob = match.css(".match-top .prob:not(.tie-prob)").text.strip.chop.to_f
      f538_away_prob = match.css(".match-bottom .prob:not(.tie-prob)").text.strip.chop.to_f
      f538_tie_prob  = match.css(".match-top .tie-prob").text.strip.chop.to_f

      f538 = {'home_team' => f538_home_team,
              'away_team' => f538_away_team,
              'home_prob' => f538_home_prob,
              'tie_prob'  => f538_tie_prob,
              'away_prob' => f538_away_prob}

      f538_datas << f538
    end

    print f538_datas

    # Odds
    source = 'https://www.parionssport.fr/api/1n2/offre?competition=[241,315,317,322,325]&sport=100'
    resp = Net::HTTP.get_response(URI.parse(source))
    data = resp.body
    @odds = JSON.parse(data)

    @final_data = []
    @odds.each do |odd|
      odd_home_team = odd["label"].split('-')[0].strip
      odd_away_team = odd["label"].split('-')[1].strip
      odd_home_prob = odd["outcomes"][0]["cote"]
      odd_tie_prob  = odd["outcomes"][1]["cote"]>
      odd_away_prob = odd["outcomes"][2]["cote"]
      @p1 = (1/@b1.gsub(',', '.').to_f).round(2)
      @pN = (1/@bN.gsub(',', '.').to_f).round(2)
      @p2 = (1/@b2.gsub(',', '.').to_f).round(2)
      @pS = (@p1 + @pN + @p2).round(2)
      @ap1 = (@p1/@pS).round(2)
      @apN = (@pN/@pS).round(2)
      @ap2 = (@p2/@pS).round(2)
    end
  end

end
