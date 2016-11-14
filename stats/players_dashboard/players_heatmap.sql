select
    round(ale.start_x/2)*2 as x, 
    round(ale.start_y/2)*2 as y, 
    count(*) as nb
from 
    sqw_players p 
inner join
    sqw_all_passes_events ale on p.id = ale.sqw_player_id
inner join 
    sqw_games g on ale.sqw_game_id = g.id
inner join
    sqw_seasons s on g.sqw_season_id = s.id
where 
    p.last_name = 'Umtiti'
and
    s.start = 2015
group by
    x, 
    y;