# -*- coding: utf-8 -*-
from nn import regularization_5
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
    game_id    = row_game[0]
    kickoff    = row_game[1]
    home_team  = row_game[2]
    away_team  = row_game[3]
    home_color = row_game[4]
    away_color = row_game[5]

    cur.execute(open('queries/expg_by_game.sql').read(), [game_id])
    rows_shots = cur.fetchall()
    match_shots  = np.fromiter(iterable=rows_shots, dtype=float, count=-1)#[:, [11, 12, 13]]
    print match_shots


# Train network
network = regularization_5.Network()
network.load_weights('save/5_regularization')
network.print_weights()
network.predict()

log.info("END")
