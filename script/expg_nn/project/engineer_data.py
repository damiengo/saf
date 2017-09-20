# -*- coding: utf-8 -*-
import logging as log
import sys
import gc
import pandas as pd
from data_preparation import feature_engineer

log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')
log.info("START")

if(len(sys.argv) < 2):
    print "Use: command <prepared_folder> <engineered_folder>"
    sys.exit(2)

prepared_folder   = sys.argv[1]
engineered_folder = sys.argv[2]

eng = feature_engineer.Engineer()

start = 2017
end = 2018
for year in xrange(start, end, 1):
    log.info("  -> Year "+str(year))
    data = pd.read_csv(prepared_folder+'/'+str(year)+'.csv')
    shots = eng.process(data)
    shots.to_csv(engineered_folder+'/'+str(year)+'.csv', index=False)
    data = None
    shots = None
    gc.collect()

log.info("END")
