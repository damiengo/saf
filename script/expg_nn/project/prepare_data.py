# -*- coding: utf-8 -*-
import logging as log
from data_preparation import prepare_data
from get_data import db_reader

log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')
log.info("START")

reader = db_reader.DBReader()
prep = prepare_data.Preparation()

# TRAIN
log.info("  -> Train data")
histo_data = reader.get('queries/games_chrono.sql', "2012, 2013, 2014, 2015")
shots = prep.prepare(histo_data)
shots.to_csv('save/expg_prepared_data/shots_train.csv', index=False)

# TO USE
log.info("  -> Predict data")
predict_data = reader.get('queries/games_chrono.sql', "2016")
predict_shots = prep.prepare(predict_data)
predict_shots.to_csv('save/expg_prepared_data/shots_to_predict.csv', index=False)

log.info("END")
