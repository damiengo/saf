# -*- coding: utf-8 -*-
import logging as log
import sys
from data_preparation import prepare_data
from get_data import db_reader

log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')
log.info("START")

if(len(sys.argv) < 2):
    print "Use: command <train_save> <predict_save>"
    sys.exit(2)

train_save   = sys.argv[1]
predict_save = sys.argv[2]

reader = db_reader.DBReader()
prep = prepare_data.Preparation()

# TRAIN
log.info("  -> Train data")
histo_data = reader.get('queries/games_chrono.sql', "2012, 2013, 2014, 2015")
shots = prep.prepare(histo_data)
shots.to_csv(train_save, index=False)

# TO USE
log.info("  -> Predict data")
predict_data = reader.get('queries/games_chrono.sql', "2016")
predict_shots = prep.prepare(predict_data)
predict_shots.to_csv(predict_save, index=False)

log.info("END")
