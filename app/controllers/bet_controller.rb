class BetController < ApplicationController

  def index
  end

  # Get JSON odds
  def odds

    # Predictions
    f538_datas = []
    f538_datas = f538_datas + get538Ligue("https://projects.fivethirtyeight.com/soccer-predictions/ligue-1/")
    f538_datas = f538_datas + get538Ligue("https://projects.fivethirtyeight.com/soccer-predictions/bundesliga/")
    f538_datas = f538_datas + get538Ligue("https://projects.fivethirtyeight.com/soccer-predictions/la-liga/")
    f538_datas = f538_datas + get538Ligue("https://projects.fivethirtyeight.com/soccer-predictions/serie-a/")


    # Odds
    source = 'https://www.parionssport.fr/api/1n2/offre?competition=[241,315,317,322,325]&sport=100'
    resp = Net::HTTP.get_response(URI.parse(source))
    data = resp.body
    @odds = JSON.parse(data)

    @final_data = []
    @odds.each do |odd|
      odd_data = {}
      competition   = odd["competition"]
      odd_end       = DateTime.parse(odd["end"]).strftime("%Y-%m-%d %H:%M")
      odd_home_team = odd["label"].split('-')[0].strip
      odd_away_team = odd["label"].split('-')[1].strip
      odd_home_prob = odd["outcomes"][0]["cote"].gsub(',', '.').to_f
      odd_tie_prob  = odd["outcomes"][1]["cote"].gsub(',', '.').to_f
      odd_away_prob = odd["outcomes"][2]["cote"].gsub(',', '.').to_f
      odd_prob_home = (1/odd_home_prob).round(2)
      odd_prob_tie  = (1/odd_tie_prob).round(2)
      odd_prob_away = (1/odd_away_prob).round(2)
      odd_sum       = odd_prob_home + odd_prob_tie + odd_prob_away
      odd_home_prob_adj = (odd_prob_home/odd_sum).round(2)
      odd_tie_prob_adj  = (odd_prob_tie/odd_sum).round(2)
      odd_away_prob_adj = (odd_prob_away/odd_sum).round(2)

      odd_data['competition']       = competition
      odd_data['odd_end']           = odd_end
      odd_data['home_team']         = odd_home_team
      odd_data['away_team']         = odd_away_team
      odd_data['home_odd']          = odd_home_prob
      odd_data['tie_odd']           = odd_tie_prob
      odd_data['away_odd']          = odd_away_prob
      odd_data['home_odd_prob']     = odd_prob_home
      odd_data['tie_odd_prob']      = odd_prob_tie
      odd_data['away_odd_prob']     = odd_prob_away
      odd_data['home_odd_prob_adj'] = odd_home_prob_adj
      odd_data['tie_odd_prob_adj']  = odd_tie_prob_adj
      odd_data['away_odd_prob_adj'] = odd_away_prob_adj

      f538_data_selected = f538_datas.select{
        |f538_data|
        get538TeamName(f538_data['home_538_team']) == odd_home_team &&
        get538TeamName(f538_data['away_538_team']) == odd_away_team
      }

      odd_data.merge!(Hash[*f538_data_selected])

      @final_data << odd_data
    end

    render json: {:odds=> @final_data}, status: 200
  end

  # Return 538 datas for a Ligue
  def get538Ligue(url)
    # Predictions
    f538_datas = []

    resp = Net::HTTP.get_response(URI.parse(url))
    data = resp.body

    first_page = Nokogiri::HTML(data, nil, "utf-8")
    first_page.css(".match-container").each do |match|
      f538_home_team = match.css(".match-top .team-div .name").text.strip
      f538_away_team = match.css(".match-bottom .team-div .name").text.strip
      f538_home_prob = match.css(".match-top .prob:not(.tie-prob)").text.strip.chop.to_f/100
      f538_away_prob = match.css(".match-bottom .prob:not(.tie-prob)").text.strip.chop.to_f/100
      f538_tie_prob  = match.css(".match-top .tie-prob").text.strip.chop.to_f/100

      f538 = {'home_538_team' => f538_home_team,
              'away_538_team' => f538_away_team,
              'home_538_prob' => f538_home_prob,
              'tie_538_prob'  => f538_tie_prob,
              'away_538_prob' => f538_away_prob}

      f538_datas << f538
    end

    return f538_datas
  end

  # Return global names from 538 names
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
      'Monaco'      => 'Monaco',

      'Schalke 04'    => 'Schalke 04',
      'Eintracht'     => 'Ein.Francfort',
      'Werder'        => 'Werder Brême',
      'Bayern Munich' => 'Bayern Munich',
      'Wolfsburg'     => 'Wolfsburg',
      'FC Augsburg'   => 'Augsburg',
      'Darmstadt 98'  => 'SV Darmstadt',
      'FC Cologne'    => 'Cologne',
      'Ingolstadt'    => 'Ingolstadt 04',
      'Hamburg SV'    => 'Hambourg',
      'RB Leipzig'    => 'RB Leipzig',
      'Hoffenheim'    => 'Hoffenheim',
      'Bayer'         => 'Leverkusen',
      'Gladbach'      => 'M\'Gladbach',
      'SC Freiburg'   => 'Fribourg',
      'Hertha Berlin' => 'Hertha Berlin',
      'Mainz'         => 'Mayence',
      'Dortmund'      => 'Dortmund',

      'Villarreal'      => 'Villarreal',
      'Granada'         => 'Granada CF',
      'Alavés'          => 'Alaves',
      'Atletico Madrid' => 'AtleticoMadrid',
      'Eibar'           => 'Eibar',
      'Deportivo'       => 'Dep.Corogne',
      'Leganes'         => 'CD Leganes',
      'Celta Vigo'      => 'Celta Vigo',
      'Real Betis'      => 'Betis Séville',
      'Barcelona'       => 'FC Barcelone',
      'Espanyol'        => 'Espanyol',
      'Sevilla'         => 'FC Séville',
      'Athletic Bilbao' => 'AthleticBilbao',
      'Sporting Gijón'  => 'Gijon',
      'Real Madrid'     => 'Real Madrid',
      'Real Sociedad'   => 'Real Sociedad',
      'Las Palmas'      => 'Las Palmas',
      'Valencia'        => 'FC Valence',

      'Lazio'           => 'Lazio Rome',
      'Chievo'          => 'Chievo Vérone',
      'Inter Milan'     => 'Inter Milan',
      'Pescara'         => 'Pescara',
      'Torino'          => 'Torino',
      'Atalanta'        => 'Atal.Bergame',
      'Udinese'         => 'Udinese',
      'AC Milan'        => 'Milan AC',
      'Sampdoria'       => 'Sampdoria',
      'Roma'            => 'AS Rome',
      'Fiorentina'      => 'Fiorentina',
      'Genoa'           => 'Genoa',
      'Cagliari'        => 'Cagliari',
      'Bologna'         => 'Bologne',
      'Sassuolo'        => 'Sassuolo',
      'Juventus'        => 'Juventus Turin',
      'Crotone'         => 'Crotone',
      'Empoli'          => 'Empoli',
      'Napoli'          => 'Naples',
      'Palermo'         => 'Palerme'
    }

    return names[name]
  end

end
