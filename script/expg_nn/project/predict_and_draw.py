# -*- coding: utf-8 -*-
from nn import regularization_5
import psycopg2
import logging as log

log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')
log.info("START")

try:
    conn = psycopg2.connect("dbname='saf' user='saf' host='localhost' password='saf'")
except:
    print "Error while connecting to database"

# Train network
network = regularization_5.Network()
network.load_weights('save/5_regularization')
network.print_weights()
network.predict()

log.info("END")
