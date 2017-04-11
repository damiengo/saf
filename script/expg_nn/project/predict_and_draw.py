# -*- coding: utf-8 -*-
from nn import tf_7
from sklearn_ import logistic
from soccerfield import soccerfield
import psycopg2
import logging as log
import numpy as np
from datetime import datetime
from slugify import slugify
import sys

log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')
log.info("START")

# Connect to DB
try:
    conn = psycopg2.connect("dbname='saf' user='saf' host='localhost' password='saf'")
except:
    print "Error while connecting to database"

# Load network
#model = tf_7.Network(learning_rate=0.1)
model = logistic.Model()
model.load('save/sklearn')

cur = conn.cursor()
cur.execute(open('queries/last_n_games.sql').read(), [20])
rows_games = cur.fetchall()
for row_game in rows_games:
    game_id      = row_game[0]
    kickoff      = row_game[1]
    home_team_id = row_game[2]
    away_team_id = row_game[3]
    home_team    = row_game[4]
    away_team    = row_game[5]
    home_color   = row_game[6]
    away_color   = row_game[7]
    home_goals   = row_game[8]
    away_goals   = row_game[9]
    home_p_goals = row_game[10]
    away_p_goals = row_game[11]

    log.info(kickoff.strftime('%Y%m%d')+' '+home_team+' - '+away_team+': '+str(home_goals)+'-'+str(away_goals))

    # home shots
    cur.execute(open('queries/expg_by_game.sql').read(), [game_id, home_team_id])
    home_rows_shots   = cur.fetchall()
    home_rows_shots   = np.asarray(home_rows_shots)
    home_match_shots  = home_rows_shots[:, [11, 12, 13]]
    home_match_shots  = home_match_shots.astype(np.float)

    # away shots
    cur.execute(open('queries/expg_by_game.sql').read(), [game_id, away_team_id])
    away_rows_shots   = cur.fetchall()
    away_rows_shots   = np.asarray(away_rows_shots)
    away_match_shots  = away_rows_shots[:, [11, 12, 13]]
    away_match_shots  = away_match_shots.astype(np.float)

    #home_match_shots_setted = network.set_data(home_match_shots)
    home_match_shots_setted = home_match_shots
    home_expg = model.predict(home_match_shots_setted)
    #away_match_shots_setted = network.set_data(away_match_shots)
    away_match_shots_setted = away_match_shots
    away_expg = model.predict(away_match_shots_setted)

    home_shots = np.array(np.c_[home_rows_shots[:, [7, 8, 6]], home_expg], dtype='f')
    away_shots = np.array(np.c_[away_rows_shots[:, [7, 8, 6]], away_expg], dtype='f')

    field = soccerfield.Soccerfield(home_shots, away_shots,
                                    home_team,  away_team,
                                    ((home_goals) - (home_p_goals)), ((away_goals) - (away_p_goals)),
                                    (home_p_goals), (away_p_goals),
                                    home_color, away_color
                                    )
    field.save('/home/dam/Images/expg/'+kickoff.strftime('%Y%m%d')+'_'+slugify(home_team)+'_'+slugify(away_team)+'.png')
log.info("END")
