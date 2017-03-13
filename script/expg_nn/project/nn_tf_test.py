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

# Add non goal
targets = np.column_stack(((1-targets), targets))

# Reshape target
#targets = targets.reshape((targets.shape[0], 1))

network = tf_7.Network()
network.fit(features, targets)
network.predict(features)
