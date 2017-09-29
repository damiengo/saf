# -*- coding: utf-8 -*-
import logging as log
import sys
import gc
import pandas as pd
from data_preparation import prepare_data

log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')
log.info("START")

if(len(sys.argv) < 2):
    print "Use: command <extract_folder> <prepared_folder>"
    sys.exit(2)

extracted_folder = sys.argv[1]
prepared_folder  = sys.argv[2]

prep = prepare_data.Preparation()

start = 2016
end = 2017
for year in xrange(start, end, 1):
    log.info("  -> Year "+str(year))
    data = pd.read_csv(extracted_folder+'/'+str(year)+'.csv')
    shots = prep.prepare(data)
    shots.to_csv(prepared_folder+'/'+str(year)+'.csv', index=False)
    data = None
    shots = None
    gc.collect()

log.info("END")
