# -*- coding: utf-8 -*-
import logging as log
import sys
from data_preparation import prepare_data
from get_data import db_reader

log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')
log.info("START")

if(len(sys.argv) < 1):
    print "Use: command <save_folder>"
    sys.exit(2)

save_folder = sys.argv[1]

reader = db_reader.DBReader()

start = 2017
end = 2018
for year in xrange(start, end, 1):
    log.info("  -> Year "+str(year))
    histo_data = reader.get('queries/games_chrono.sql', str(year))
    histo_data.to_csv(save_folder+'/'+str(year)+'.csv', index=False)

log.info("END")
