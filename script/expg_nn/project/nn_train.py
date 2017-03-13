# -*- coding: utf-8 -*-
import sys
import numpy as np

from sklearn.model_selection import KFold
from nn import tf_7
import logging as log

log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')
log.info("START")

if(len(sys.argv) < 2):
    print "Use: command <datas>"
    sys.exit(2)

data_file = sys.argv[1]

all_shots = np.genfromtxt(data_file, delimiter=';', skip_header=1)
features = all_shots[:, [1, 2, 5]]
targets  = all_shots[:, 0]

np.random.seed(8)

network = tf_7.Network(learning_rate=0.001)
network.fit(features, targets)
network.save_weights('save/tf_7')

log.info("END")
