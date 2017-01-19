# -*- coding: utf-8 -*-
import sys
import numpy as np

from sklearn.model_selection import KFold
from nn import regularization_5
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

"""
hidden_size: 1, alpha: 0.001, itera: 100, reg_lambda: 0.1 -> 0.00236529895934 (445.0 goals/446.696127253 expg)
hidden_size: 1, alpha: 0.0001, itera: 1000, reg_lambda: 0.1 -> 0.00241489765891 (445.0 goals/447.825648888 expg)

hidden_size: 2, alpha: 0.0001, itera: 1000, reg_lambda: 0.01 -> 0.00208179836908 (445.0 goals/443.852741287 expg)
hidden_size: 2, alpha: 0.0001, itera: 1000, reg_lambda: 0.001 -> 0.00207708215199 (445.0 goals/443.960384219 expg)
hidden_size: 2, alpha: 0.0001, itera: 1000, reg_lambda: 0.0001 -> 0.00207661068657 (445.0 goals/443.971145078 expg)
hidden_size: 2, alpha: 0.0001, itera: 1000, reg_lambda: 1e-05 -> 0.00207656354159 (445.0 goals/443.97222113 expg)
"""

network = regularization_5.Network(hidden_size=2, alpha=0.0001, iter=1000, reg_lambda=0.00001)
network.fit(features, targets)
network.save_weights('save/5_regularization')

log.info("END")
