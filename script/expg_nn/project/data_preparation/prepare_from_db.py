# -*- coding: utf-8 -*-
#
# Data preparation from database.
# 2017/05/21
#

import psycopg2
import pandas as pd
import logging as log

# Prepare the data
class Preparation:
    def __init__(self):
        log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')
        try:
            self.conn = psycopg2.connect("dbname='saf' user='saf' host='localhost' password='saf'")
            self.cur = self.conn.cursor()
        except:
            log.error("I am unable to connect to the database")

    # Realize the preparation
    def prepare(self):
        df = self.getData()
        df = self.getShots(df)
        log.info(df.head())

    # Read from database
    def getData(self):
        log.info('Read from database')
        return pd.read_sql_query(open('queries/games_chrono.sql').read(), con=self.conn)

    # Get shots
    def getShots(self, df):
        log.info('Get only shots')
        # Previous events
        for i in range(1, 4):
            df['n'+str(i)+'_event_type']        = df.shift(i)['event_type']
            df['n'+str(i)+'_event_type2']       = df.shift(i)['event_type2']
            df['n'+str(i)+'_event_team_name']   = df.shift(i)['event_team_name']
            df['n'+str(i)+'_event_player_name'] = df.shift(i)['event_player_name']
            df['n'+str(i)+'_minsec']            = df.shift(i)['minsec']
            df['n'+str(i)+'_start_x']           = df.shift(i)['start_x']
            df['n'+str(i)+'_start_y']           = df.shift(i)['start_y']
        shots = df[df.event_type == 'shot']
        # Penalties
        #shots['penalty'] = (shots.start_x >= 88.4 and shots.start_x <= 88.6 and shots.start_y >= 49.8 and shots.start_y <= 50.4)
        shots['penalty'] = shots.apply(lambda shot: shot.start_x >= 88.4 and shot.start_x <= 88.6 and shot.start_y >= 49.8 and shot.start_y <= 50.4, axis=1)
        shots.to_csv('/tmp/shots.csv')
        return shots
