# -*- coding: utf-8 -*-
import sys
import numpy as np

from nn import regularization_5
import logging as log

log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')
log.info("START")

if(len(sys.argv) < 2):
    print "Use: command <datas>"
    sys.exit(2)

data_file = sys.argv[1]

all_shots = np.genfromtxt(data_file, delimiter=';', skip_header=1)
sample = all_shots

# First 15000 entries are for train
train_target = sample[:15000, 0]
# 1: degree, 2: distance, 5: headed
train_input  = sample[:15000, [1, 2, 5]]

# Last entries are for test
test_target    = sample[15000:, 0]
test_input     = sample[15000:, [1, 2, 5]]
test_input_all = sample[15000:, :]

# Train network
network = regularization_5.Network()
network.fit(train_input, train_target)
network.save_weights('save/5_regularization')

"""
# Test network
network.set_data(test_input, test_target)
test_out = network.fit(False)
log.debug(np.c_[test_input, test_target, test_out])
log.debug('Test RMSE: '+str(np.power(np.mean(np.power(test_target - test_out, 2)), 0.5)))
log.debug(network.print_weights())
"""

log.info("END")
