# -*- coding: utf-8 -*-
import sys
import numpy as np
import pandas as pd
import logging as log
from sklearn import preprocessing

def normalize(df, column):
    return (df[column] - df[column].min())/(df[column].max() - df[column].min())

log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')
log.info("START")

if(len(sys.argv) < 2):
    print "Use: command <datas>"
    sys.exit(2)

train_file = sys.argv[1]

all_shots = pd.read_csv(train_file)

#print(all_shots.columns.values)

# Filter shots
all_shots = all_shots[all_shots.penalty == False]
all_shots = all_shots[all_shots.own_goal == False]

# Reduce columns
all_shots = all_shots[['goal', 'distance', 'degree', 'long_ball', 'through_ball', 'headed',
                       'on_corner', 'on_cross', 'on_pass', 'on_back_pass', 'on_back_cross', 'on_shot_save',
                       'on_shot_off', 'on_shot_block', 'on_shot_ww', 'on_interception', 'on_tackle', 'on_gk_failedcatch',
                       'on_gk_punch', 'on_gk_save', 'on_gk_failedclearance', 'on_gk_clearance', 'on_gk_catch', 'same_team',
                       'pass_distance', 'minsec_diff', 'n1_headed', 'n1_long_ball', 'n1_through_ball',
                       'zone_10', 'zone_11', 'zone_12', 'zone_13', 'zone_14', 'zone_15', 'zone_16', 'zone_17', 'zone_18',
                       'n1_zone_10', 'n1_zone_11', 'n1_zone_12', 'n1_zone_13', 'n1_zone_14',
                       'n1_zone_15', 'n1_zone_16', 'n1_zone_17', 'n1_zone_18']]

# Normalize values
all_shots['distance']      = normalize(all_shots, 'distance')
all_shots['degree']        = normalize(all_shots, 'degree')
all_shots['pass_distance'] = normalize(all_shots, 'pass_distance')
all_shots['minsec_diff']   = normalize(all_shots, 'minsec_diff')

log.debug(all_shots.head())

log.info("END")
