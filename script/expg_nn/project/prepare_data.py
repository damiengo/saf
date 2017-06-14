# -*- coding: utf-8 -*-
import logging as log
from data_preparation import prepare_from_db

log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')
log.info("START")

prep = prepare_from_db.Preparation()
prep.prepare()

log.info("END")
