# -*- coding: utf-8 -*-
import logging as log

class TargetFeatures:

    X = [  'distance', 'degree', 'long_ball', 'through_ball', 'headed',
           'on_corner', 'on_cross', 'on_pass', 'on_back_pass', 'on_back_cross', 'on_shot_save',
           'on_shot_off', 'on_shot_block', 'on_shot_ww', 'on_interception', 'on_tackle', 'on_gk_failedcatch',
           'on_gk_punch', 'on_gk_save', 'on_gk_failedclearance', 'on_gk_clearance', 'on_gk_catch', 'same_team',
           'pass_distance', 'minsec_diff', 'n1_headed', 'n1_long_ball', 'n1_through_ball',
           'zone_10', 'zone_11', 'zone_12', 'zone_13', 'zone_14', 'zone_15', 'zone_16', 'zone_17', 'zone_18',
           'n1_zone_10', 'n1_zone_11', 'n1_zone_12', 'n1_zone_13', 'n1_zone_14',
           'n1_zone_15', 'n1_zone_16', 'n1_zone_17', 'n1_zone_18']
    y = 'goal'

    def __init__(self):
        log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')

    def run(self, df):
        y = df['goal'].as_matrix()
        X = df.drop('goal', axis=1, inplace=False).as_matrix()

        return X, y
