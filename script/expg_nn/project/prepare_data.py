# -*- coding: utf-8 -*-
import logging as log
from data_preparation import prepare_data
from get_data import db_reader

log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')
log.info("START")

# Read data
reader = db_reader.DBReader()
histo_data = reader.get('queries/games_chrono.sql')
# Prepare data
prep = prepare_data.Preparation()
shots = prep.prepare(histo_data)

log.info(shots.head())

log.info("END")
