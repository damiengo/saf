# -*- coding: utf-8 -*-
#
# Data preparation from database.
# 2017/05/21
#

import pandas as pd
import logging as log
import numpy as np
import math

# Prepare the data
class Engineer:
    def __init__(self):
        log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')
        self.max_history = 30
        # Field in meters
        self.field_x_size = 105
        self.field_y_size = 68
        self.goal_y1 = self.field_y_size/2 - 7.32/2
        self.goal_y2 = self.field_y_size/2 + 7.32/2

    # Reduce data for expg
    def process(self, df):
        log.info('Engineer features')
        df['penalty']               = df.apply(self.penalty, axis=1)
        df['distance']              = df.apply(self.distance, axis=1)
        df['degree']                = df.apply(self.degree, axis=1)
        df['goal']                  = df.apply(lambda item: item.event_type2 == 'goal', axis=1)
        df['on_corner']             = df.apply(self.onCorner, axis=1)
        df['on_cross']              = df.apply(self.onCross, axis=1)
        df['on_pass']               = df.apply(lambda item: item.n1_event_type == 'pass', axis=1)
        df['on_back_pass']          = df.apply(lambda item: item.n1_event_type == 'pass' and item.start_x < item.n1_start_x, axis=1)
        df['on_back_cross']         = df.apply(self.onBackCross, axis=1)
        df['on_shot_save']          = df.apply(lambda item: item.n1_event_type == 'shot' and item.n1_event_type2 == 'save', axis=1)
        df['on_shot_off']           = df.apply(lambda item: item.n1_event_type == 'shot' and item.n1_event_type2 == 'off_target', axis=1)
        df['on_shot_block']         = df.apply(lambda item: item.n1_event_type == 'shot' and item.n1_event_type2 == 'blocked', axis=1)
        df['on_shot_ww']            = df.apply(lambda item: item.n1_event_type == 'shot' and item.n1_event_type2 == 'wood_work', axis=1)
        df['on_interception']       = df.apply(lambda item: item.n1_event_type == 'interception', axis=1)
        df['on_tackle']             = df.apply(lambda item: item.n1_event_type == 'tackle', axis=1) # Same team or other team
        df['on_gk_failedcatch']     = df.apply(lambda item: item.n1_event_type == 'gk' and item.n1_event_type2 == 'failedcatch', axis=1)
        df['on_gk_punch']           = df.apply(lambda item: item.n1_event_type == 'gk' and item.n1_event_type2 == 'punch', axis=1)
        df['on_gk_save']            = df.apply(lambda item: item.n1_event_type == 'gk' and item.n1_event_type2 == 'save', axis=1)
        df['on_gk_failedclearance'] = df.apply(lambda item: item.n1_event_type == 'gk' and item.n1_event_type2 == 'failedclearance', axis=1)
        df['on_gk_clearance']       = df.apply(lambda item: item.n1_event_type == 'gk' and item.n1_event_type2 == 'clearance', axis=1)
        df['on_gk_catch']           = df.apply(lambda item: item.n1_event_type == 'gk' and item.n1_event_type2 == 'catch', axis=1)
        df['same_team']             = df.apply(lambda item: item.event_team_name == item.n1_event_team_name, axis=1)
        df['minsec_diff']           = df.apply(lambda item: item.minsec - item.n1_minsec, axis=1)
        df['direct_set_piece']      = df.apply(self.directSetPiece, axis=1)
        df['indirect_set_piece']    = df.apply(self.indirectSetPiece, axis=1)
        df['own_goal']              = df.apply(lambda item: item.start_x < 20, axis=1)
        df['pass_distance']         = df.apply(self.passDistance, axis=1)
        df['nb_passes']             = df.apply(self.nbPasses, axis=1)
        df['is_strong_possession']  = df.apply(self.isStrongPossession, axis=1)
        df['is_reverse_attack']     = df.apply(self.isReverseAttack, axis=1)
        df['attack_speed']          = df.apply(self.attackSpeed, axis=1)
        df['is_pass_headed']        = df.apply(self.isPassHeaded, axis=1)

        # To add:
        #  - How many successful tackles in last 10 events (from team and other team) if possession
        #  -|- How many successful passes in last 10 events (from team and other team) if possession
        #  -|- Last other team defense position
        #  - If possession speed of the attack
        #  - Mean of expg by shots of the team in the last 10 games
        #  - Game state
        #  - If passe, distance run between pass reception and shot
        #    * If run is in goal direction directly, other team is not in well position
        #  - Number of passes of the team in last 5 minutes
        #  - Number of passes of the team in last 25 meters in the last 5 minutes
        #  -|- Is headed pass
        #  - Add goals + wood work as goals when generating expg

        return df

    #
    # Is the shot a penalty.
    #
    def penalty(self, df):
        return df.start_x >= 88.2 and df.start_x <= 88.8 and \
               df.start_y >= 49.6 and df.start_y <= 50.6 and \
               (df.n1_event_type == 'foul' or df.n1_event_type2 == 'penalty')

    #
    # Pass distance.
    #
    def passDistance(self, df):
        if (df.on_corner or \
           df.on_cross or \
           df.on_pass or \
           df.indirect_set_piece) and \
           (df.n1_event_team_name == df.event_team_name):
            return math.sqrt(math.pow(df.n1_adj_start_x-df.adj_start_x, 2)+math.pow(df.n1_adj_start_y-df.adj_start_y, 2))

        return None

    #
    # Distance from goal.
    #
    def distance(self, df):
        return math.sqrt(math.pow(self.field_x_size-df.adj_start_x, 2)+math.pow(self.field_y_size/2-df.adj_start_y, 2))

    #
    # Degree visibilty for the kicker.
    #
    def degree(self, df):
        deltaY = df.adj_start_y - self.field_y_size/2
        deltaX = df.adj_start_x - self.field_x_size

        return 90 - np.absolute(np.arctan(deltaY / deltaX) * 180 / math.pi)

    #
    # Is the attacking passed the ball a lot.
    #
    def isStrongPossession(self, df):
        for i in range(1, self.max_history):
            if df['event_team_name'] != df['n'+str(i)+'_event_team_name'] or \
               (df['n'+str(i)+'_event_type'] != 'pass' and df['n'+str(i)+'_event_type'] != 'cross'):
                return False

        return True

    #
    # Is the attack reversed (quick interception and shot).
    #
    def isReverseAttack(self, df):
        shot_time = df['minsec']
        for i in range(1, self.max_history):
            if df['event_team_name'] != df['n'+str(i)+'_event_team_name'] and \
               df['n'+str(i)+'_event_type'] == 'pass':
                if(shot_time - df['n'+str(i)+'_minsec'] < 10):
                    return True
                else:
                    return False

        return False

    #
    # Speed of the attack.
    # @TODO : check if there is no foul or offside
    #
    def attackSpeed(self, df):
        first_pass = df['nb_passes']
        if(first_pass == 0):
            return None

        end_x    = df['adj_start_x']
        end_y    = df['adj_start_y']
        end_time = df['minsec']

        start_x    = df['n'+str(first_pass)+'_adj_start_x']
        start_y    = df['n'+str(first_pass)+'_adj_start_y']
        start_time = df['n'+str(first_pass)+'_minsec']

        distance = math.sqrt(math.pow(end_x-start_x, 2)+math.pow(end_y-start_y, 2))
        delta_time = end_time - start_time

        # No division by 0
        if(delta_time == 0):
            delta_time = 1

        return distance/delta_time

    #
    # Is the pass headed
    #
    def isPassHeaded(self, df):
        return (df['n1_event_type'] == 'pass') and df['n1_headed']

    #
    # Number of consecutive successful passes
    #
    def nbPasses(self, df):
        nb = 0
        for i in range(1, self.max_history):
            if df['event_team_name'] == df['n'+str(i)+'_event_team_name'] and \
               (df['n'+str(i)+'_event_type'] == 'pass' or \
               df['n'+str(i)+'_event_type'] == 'cross'):
               nb = nb+1
            else:
                return nb

        return nb

    #
    # Is the shot on cross
    #
    def onCross(self, df):
        return df.n1_event_type == 'cross' and \
               df.n1_event_type2 == 'Completed' and \
               df.n2_event_type != 'corner'

    #
    # Is the shot on back cross
    #
    def onBackCross(self, df):
        return df.on_cross == True and \
               df.start_x < df.n1_start_x

    #
    # Is the shot on corner
    #
    def onCorner(self, df):
        return (df.n1_event_type == 'corner' or df.n2_event_type == 'corner') \
               or \
               (df.n1_event_type == 'set_piece' and df.n1_event_type2 == 'corner')

    #
    # Is the shot on indirect set piece
    #
    def indirectSetPiece(self, df):
        return (df.n2_event_type == 'foul' and df.n1_event_type != 'shot') \
               or \
               (df.n1_event_type == 'set_piece' and df.n1_event_type2 == 'crossed') \
               or \
               (df.n1_event_type == 'foul' and df.penalty == False and \
               math.sqrt(math.pow(df.n1_adj_start_x-df.adj_start_x, 2)+math.pow(df.n1_adj_start_y-df.adj_start_y, 2)) > 5)

    #
    # Is the shot on direct set piece
    #
    def directSetPiece(self, df):
        return (df.n1_event_type == 'foul' and df.penalty == False and \
               math.sqrt(math.pow(df.n1_adj_start_x-df.adj_start_x, 2)+math.pow(df.n1_adj_start_y-df.adj_start_y, 2)) < 5) \
               or \
               (df.n1_event_type == 'set_piece' and df.n1_event_type2 == 'direct')
