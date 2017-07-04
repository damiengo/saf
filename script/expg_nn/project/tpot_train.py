# -*- coding: utf-8 -*-
import sys
import numpy as np
import pandas as pd
import logging as log

log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')
log.info("START")

if(len(sys.argv) < 2):
    print "Use: command <datas>"
    sys.exit(2)

train_file = sys.argv[1]

all_shots = pd.read_csv(data_file)

#print(all_shots.columns.values)

all_shots = all_shots[['goal', 'start_x', 'start_y', 'distance', 'degree', 'event_type', 'event_type2',
                       'on_corner', 'on_cross', 'on_pass', 'on_back_pass', 'headed', 'n1_headed', 'n1_long_ball', 'n1_through_ball',
                       'zone_10', 'zone_11', 'zone_12', 'zone_13', 'zone_14', 'zone_15', 'zone_16', 'zone_17', 'zone_18']]

log.info("END")
