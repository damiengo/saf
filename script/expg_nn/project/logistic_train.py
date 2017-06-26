# -*- coding: utf-8 -*-
import sys
import numpy as np
import pandas as pd

from sklearn.model_selection import KFold
from sklearn_ import logistic
import logging as log

log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')
log.info("START")

if(len(sys.argv) < 2):
    print "Use: command <datas>"
    sys.exit(2)

data_file = sys.argv[1]

all_shots = pd.read_csv(data_file)
log.debug(all_shots.head())

"""features = all_shots[:, [1, 2, 5]]
targets  = all_shots[:, 0]

np.random.seed(8)

model = logistic.Model()
model.fit(features, targets)
model.save('save/sklearn')
"""

log.info("END")
