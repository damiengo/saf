class BetController < ApplicationController

  def index

    # Predictions
    f538_datas = []

    url = "https://projects.fivethirtyeight.com/soccer-predictions/ligue-1/"
    resp = Net::HTTP.get_response(URI.parse(url))
    data = resp.body

    first_page = Nokogiri::HTML(data, nil, "utf-8")
    first_page.css(".match-container").each do |match|
      f538_home_team = match.css(".match-top .team-div .name").text.strip
      f538_away_team = match.css(".match-bottom .team-div .name").text.strip
      f538_home_prob = match.css(".match-top .prob:not(.tie-prob)").text.strip.chop.to_f
      f538_away_prob = match.css(".match-bottom .prob:not(.tie-prob)").text.strip.chop.to_f
      f538_tie_prob  = match.css(".match-top .tie-prob").text.strip.chop.to_f

      f538 = {'home_538_team' => f538_home_team,
              'away_538_team' => f538_away_team,
              'home_538_prob' => f538_home_prob,
              'tie_538_prob'  => f538_tie_prob,
              'away_538_prob' => f538_away_prob}

      f538_datas << f538
    end

    # Odds
    source = 'https://www.parionssport.fr/api/1n2/offre?competition=[241,315,317,322,325]&sport=100'
    resp = Net::HTTP.get_response(URI.parse(source))
    data = resp.body
    @odds = JSON.parse(data)

    @final_data = []
    @odds.each do |odd|
      odd_data = {}
      odd_home_team = odd["label"].split('-')[0].strip
      odd_away_team = odd["label"].split('-')[1].strip
      odd_home_prob = odd["outcomes"][0]["cote"]
      odd_tie_prob  = odd["outcomes"][1]["cote"]
      odd_away_prob = odd["outcomes"][2]["cote"]
      odd_prob_home = (1/odd_home_prob.gsub(',', '.').to_f).round(2)
      odd_prob_tie  = (1/odd_tie_prob.gsub(',', '.').to_f).round(2)
      odd_prob_away = (1/odd_away_prob.gsub(',', '.').to_f).round(2)

      odd_data['home_team']      = odd_home_team
      odd_data['away_team']      = odd_away_team
      odd_data['home_odd']       = odd_home_prob
      odd_data['tie_odd']        = odd_tie_prob
      odd_data['away_odd']       = odd_away_prob
      odd_data['home_odd_prob']  = odd_prob_home
      odd_data['tie_odd_prob']   = odd_prob_tie
      odd_data['away_odd_prob']  = odd_prob_away

      f538_data = f538_datas.select{
        |f538_data|
        get538TeamName(f538_data['home_538_team']) == odd_home_team &&
        get538TeamName(f538_data['away_538_team']) == odd_away_team
      }

      odd_data.merge!(Hash[*f538_data])
      puts odd_data

      @final_data << odd_data
    end
  end

  def get538TeamName(name)
    names = {
      'Marseille'   => 'Marseille',
      'Montpellier' => 'Montpellier',
      'Lyon'        => 'Lyon',
      'Lille'       => 'Lille',
      'Rennes'      => 'Rennes',
      'Nantes'      => 'Nantes',
      'Nancy'       => 'Nancy',
      'Bordeaux'    => 'Bordeaux',
      'Lorient'     => 'Lorient',
      'Dijon FCO'   => 'Dijon',
      'Bastia'      => 'Bastia',
      'Caen'        => 'Caen',
      'Angers'      => 'Angers',
      'Metz'        => 'Metz',
      'Nice'        => 'Nice',
      'Guingamp'    => 'Guingamp',
      'Toulouse'    => 'Toulouse',
      'St Etienne'  => 'St Etienne',
      'PSG'         => 'Paris SG',
      'Monaco'      => 'Monaco'
    }

    return names[name]
  end

end
