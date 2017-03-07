# -*- coding: utf-8 -*-
from nn import tf_7
import sys
import numpy as np

if(len(sys.argv) < 2):
    print "Use: command <datas>"
    sys.exit(2)

data_file = sys.argv[1]

all_shots = np.genfromtxt(data_file, delimiter=';', skip_header=1)
features = all_shots[:, [1, 2, 5]]
targets  = all_shots[:, 0]

# Reshape target
targets = targets.reshape((targets.shape[0], 1))

batch_size = 100

for i in xrange(0, 20000, batch_size):
    batch_X = features[i:i+batch_size, :]
    batch_Y =  targets[i:i+batch_size, :]
    tf_7.training_step(batch_X, batch_Y)
