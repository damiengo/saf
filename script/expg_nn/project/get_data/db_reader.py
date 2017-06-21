# -*- coding: utf-8 -*-
#
# Get data from database.
# 2017/06/21
#

import psycopg2
import pandas as pd
import logging as log

# Get data from DB
class DBReader:

    def __init__(self):
        log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')
        try:
            self.conn = psycopg2.connect("dbname='saf' user='saf' host='localhost' password='saf'")
            self.cur = self.conn.cursor()
        except:
            log.error("I am unable to connect to the database")

    # Read from database
    def get(self, query):
        log.info('Read from database')
        return pd.read_sql_query(open(query).read(), con=self.conn)
