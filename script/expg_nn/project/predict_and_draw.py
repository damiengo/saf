# -*- coding: utf-8 -*-
from nn import regularization_5
from soccerfield import soccerfield
import psycopg2
import logging as log
import numpy as np

log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')
log.info("START")

# Connect to DB
try:
    conn = psycopg2.connect("dbname='saf' user='saf' host='localhost' password='saf'")
except:
    print "Error while connecting to database"

cur = conn.cursor()
cur.execute(open('queries/last_n_games.sql').read(), [20])
rows_games = cur.fetchall()
for row_game in rows_games:
    game_id      = row_game[0]
    kickoff      = row_game[1]
    home_team    = row_game[2]
    away_team    = row_game[3]
    home_color   = row_game[4]
    away_color   = row_game[5]
    home_goals   = row_game[6]
    away_goals   = row_game[7]
    home_p_goals = row_game[8]
    away_p_goals = row_game[9]

    cur.execute(open('queries/expg_by_game.sql').read(), [game_id])
    rows_shots = cur.fetchall()
    rows_shots = np.asarray(rows_shots)
    match_shots  = rows_shots[:, [11, 12, 13]]
    match_shots = match_shots.astype(np.float)

    network = regularization_5.Network()
    network.load_weights('save/5_regularization')
    match_shots_setted = network.set_data(match_shots)
    expg = network.predict(match_shots_setted)
    log.debug(np.c_[rows_shots, expg])

log.info("END")
