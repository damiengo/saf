# -*- coding: utf-8 -*-
#
# Data preparation from database.
# 2017/05/21
#

import psycopg2
import pandas as pd
import logging as log
import math

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
    def prepare(self, df):
        df = self.getShots(df)
        return df

    # Get shots
    def getShots(self, df):
        log.info('Get only shots')
        # https://lukehussey.wordpress.com/2012/04/18/zone-14/
        df['zone_10'] = df.apply(lambda e: e.start_x > 50 and e.start_x <= 66.66 and e.start_y >= 0 and e.start_y <= 33.33, axis=1)
        df['zone_11'] = df.apply(lambda e: e.start_x > 50 and e.start_x <= 66.66 and e.start_y > 33.33 and e.start_y <= 66.66, axis=1)
        df['zone_12'] = df.apply(lambda e: e.start_x > 50 and e.start_x <= 66.66 and e.start_y > 66.66 and e.start_y <= 100, axis=1)
        df['zone_13'] = df.apply(lambda e: e.start_x > 66.66 and e.start_x <= 83.34 and e.start_y >= 0 and e.start_y <= 33.33, axis=1)
        df['zone_14'] = df.apply(lambda e: e.start_x > 66.66 and e.start_x <= 83.34 and e.start_y > 33.33 and e.start_y <= 66.66, axis=1)
        df['zone_15'] = df.apply(lambda e: e.start_x > 66.66 and e.start_x <= 83.34 and e.start_y > 66.66 and e.start_y <= 100, axis=1)
        df['zone_16'] = df.apply(lambda e: e.start_x > 83.34 and e.start_x <= 100 and e.start_y >= 0 and e.start_y <= 33.33, axis=1)
        df['zone_17'] = df.apply(lambda e: e.start_x > 83.34 and e.start_x <= 100 and e.start_y > 33.33 and e.start_y <= 66.66, axis=1)
        df['zone_18'] = df.apply(lambda e: e.start_x > 83.34 and e.start_x <= 100 and e.start_y > 66.66 and e.start_y <= 100, axis=1)
        # Previous events
        for i in range(1, 3):
            df['n'+str(i)+'_event_type']        = df.shift(i)['event_type']
            df['n'+str(i)+'_event_type2']       = df.shift(i)['event_type2']
            df['n'+str(i)+'_assist']            = df.shift(i)['assist']
            df['n'+str(i)+'_long_ball']         = df.shift(i)['long_ball']
            df['n'+str(i)+'_through_ball']      = df.shift(i)['through_ball']
            df['n'+str(i)+'_headed']            = df.shift(i)['headed']
            df['n'+str(i)+'_event_team_name']   = df.shift(i)['event_team_name']
            df['n'+str(i)+'_event_player_name'] = df.shift(i)['event_player_name']
            df['n'+str(i)+'_minsec']            = df.shift(i)['minsec']
            df['n'+str(i)+'_start_x']           = df.shift(i)['start_x']
            df['n'+str(i)+'_start_y']           = df.shift(i)['start_y']
            df['n'+str(i)+'_zone_10']           = df.shift(i)['zone_10']
            df['n'+str(i)+'_zone_11']           = df.shift(i)['zone_11']
            df['n'+str(i)+'_zone_12']           = df.shift(i)['zone_12']
            df['n'+str(i)+'_zone_13']           = df.shift(i)['zone_13']
            df['n'+str(i)+'_zone_14']           = df.shift(i)['zone_14']
            df['n'+str(i)+'_zone_15']           = df.shift(i)['zone_15']
            df['n'+str(i)+'_zone_16']           = df.shift(i)['zone_16']
            df['n'+str(i)+'_zone_17']           = df.shift(i)['zone_17']
            df['n'+str(i)+'_zone_18']           = df.shift(i)['zone_18']
        # Delete goals from n-1 (residual errors)
        shots = df[df.event_type == 'shot']
        shots = shots[shots.n1_event_type2 != 'goal']
        shots = shots.copy()
        shots = self.calc_events(shots)
        return shots

    # Reduce data for expg
    def calc_events(self, df):
        log.info('Calc events')
        df['penalty']       = df.apply(lambda item: item.start_x >= 88.4 and item.start_x <= 88.6 and item.start_y >= 49.8 and item.start_y <= 50.4, axis=1)
        df['distance']      = df.apply(lambda item: math.sqrt(math.pow(100-item.start_x, 2)+math.pow(50-item.start_y, 2)), axis=1)
        df['degree']        = df.apply(lambda item: math.atan2(100-item.start_x, 50-item.start_y) * (180 / math.pi), axis=1)
        df['goal']          = df.apply(lambda item: item.event_type2 == 'goal', axis=1)
        df['on_corner']     = df.apply(lambda item: item.n1_event_type == 'corner' or item.n2_event_type == 'corner', axis=1)
        df['on_cross']      = df.apply(lambda item: item.n1_event_type == 'cross' and item.n2_event_type != 'corner', axis=1)
        df['on_pass']       = df.apply(lambda item: item.n1_event_type == 'pass', axis=1)
        df['on_back_pass']  = df.apply(lambda item: item.n1_event_type == 'pass' and item.start_y < item.n1_start_y, axis=1)
        df['on_back_cross'] = df.apply(lambda item: item.n1_event_type == 'cross' and item.n2_event_type != 'corner' and item.start_y < item.n1_start_y, axis=1)
        df['on_shot_off']   = df.apply(lambda item: item.n1_event_type == 'shot' and item.n1_event_type2 == 'off_target', axis=1)
        df['on_shot_save']  = df.apply(lambda item: item.n1_event_type == 'shot' and item.n1_event_type2 == 'save', axis=1)
        df['on_shot_block'] = df.apply(lambda item: item.n1_event_type == 'shot' and item.n1_event_type2 == 'blocked', axis=1)
        df['on_shot_ww']    = df.apply(lambda item: item.n1_event_type == 'shot' and item.n1_event_type2 == 'wood_work', axis=1)
        df['pass_distance'] = df.apply(lambda item: math.sqrt(math.pow(item.n1_start_x-item.start_x, 2)+math.pow(item.n1_start_y-item.start_y, 2)), axis=1)
        """
        df = df[['goal', 'start_x', 'start_y', 'distance', 'degree', 'event_type', 'event_type2',
                 'on_corner', 'on_cross', 'on_pass', 'on_back_pass', 'headed', 'n1_headed', 'n1_long_ball', 'n1_through_ball',
                 'zone_10', 'zone_11', 'zone_12', 'zone_13', 'zone_14', 'zone_15', 'zone_16', 'zone_17', 'zone_18']]
        """
        return df
