# -*- coding: utf-8 -*-
#
# Data preparation from database.
# 2017/05/21
#

import pandas as pd
import logging as log
import math

# Prepare the data
class Preparation:
    def __init__(self):
        log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')
        self.field_x_size = 105
        self.field_y_size = 68

    # Realize the preparation
    def prepare(self, df):
        df = self.getShots(df)
        return df

    # Get shots
    def getShots(self, df):
        log.info('Get only shots')
        df['adj_start_x'] = df.apply(self.adjustCoordStartX, axis=1)
        df['adj_start_y'] = df.apply(self.adjustCoordStartY, axis=1)
        df['adj_end_x']   = df.apply(self.adjustCoordEndX, axis=1)
        df['adj_end_y']   = df.apply(self.adjustCoordEndY, axis=1)
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
        for i in range(1, 9):
            log.info('  Range '+str(i))
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
            df['n'+str(i)+'_adj_start_x']       = df.shift(i)['adj_start_x']
            df['n'+str(i)+'_adj_start_y']       = df.shift(i)['adj_start_y']
            df['n'+str(i)+'_end_x']             = df.shift(i)['end_x']
            df['n'+str(i)+'_end_y']             = df.shift(i)['end_y']
            df['n'+str(i)+'_adj_end_x']         = df.shift(i)['adj_end_x']
            df['n'+str(i)+'_adj_end_y']         = df.shift(i)['adj_end_y']
            df['n'+str(i)+'_zone_10']           = df.shift(i)['zone_10']
            df['n'+str(i)+'_zone_11']           = df.shift(i)['zone_11']
            df['n'+str(i)+'_zone_12']           = df.shift(i)['zone_12']
            df['n'+str(i)+'_zone_13']           = df.shift(i)['zone_13']
            df['n'+str(i)+'_zone_14']           = df.shift(i)['zone_14']
            df['n'+str(i)+'_zone_15']           = df.shift(i)['zone_15']
            df['n'+str(i)+'_zone_16']           = df.shift(i)['zone_16']
            df['n'+str(i)+'_zone_17']           = df.shift(i)['zone_17']
            df['n'+str(i)+'_zone_18']           = df.shift(i)['zone_18']
        shots = df[df.event_type == 'shot']
        # Delete goals from n-1 (residual errors)
        shots = shots[shots.n1_event_type2 != 'goal']
        return shots

    #
    # Adjust coordinates to 105m (x) x 68m (y)
    #
    def adjustCoordStartX(self, df):
        return df.start_x * self.field_x_size/100

    #
    # Adjust coordinates to 105m (x) x 68m (y)
    #
    def adjustCoordStartY(self, df):
        return df.start_y * self.field_y_size/100

    #
    # Adjust coordinates to 105m (x) x 68m (y)
    #
    def adjustCoordEndX(self, df):
        return df.end_x * self.field_x_size/100

    #
    # Adjust coordinates to 105m (x) x 68m (y)
    #
    def adjustCoordEndY(self, df):
        return df.end_y * self.field_y_size/100
