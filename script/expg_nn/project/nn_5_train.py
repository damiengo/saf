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
hidden_size: 1, alpha: 0.001, itera: 100, reg_lambda: 0.1 -> 0.00236529895934 (445.0 goals/446.696127253 expg) <=
hidden_size: 1, alpha: 0.0001, itera: 1000, reg_lambda: 0.1 -> 0.00241489765891 (445.0 goals/447.825648888 expg)

hidden_size: 2, alpha: 0.0001, itera: 1000, reg_lambda: 0.01 -> 0.00208179836908 (445.0 goals/443.852741287 expg)
hidden_size: 2, alpha: 0.0001, itera: 1000, reg_lambda: 0.001 -> 0.00207708215199 (445.0 goals/443.960384219 expg)
hidden_size: 2, alpha: 0.0001, itera: 1000, reg_lambda: 0.0001 -> 0.00207661068657 (445.0 goals/443.971145078 expg)
hidden_size: 2, alpha: 0.0001, itera: 1000, reg_lambda: 1e-05 -> 0.00207656354159 (445.0 goals/443.97222113 expg) <=

hidden_size: 3, alpha: 1e-05, itera: 2000, reg_lambda: 0.1 -> 0.00264911884457 (445.0 goals/445.746928767 expg) <==
hidden_size: 3, alpha: 1e-05, itera: 2000, reg_lambda: 0.01 -> 0.002623811691 (445.0 goals/446.314044 expg)
hidden_size: 3, alpha: 1e-05, itera: 2000, reg_lambda: 0.001 -> 0.00262128409649 (445.0 goals/446.370685056 expg)
hidden_size: 3, alpha: 1e-05, itera: 2000, reg_lambda: 0.0001 -> 0.00262103136823 (445.0 goals/446.376348458 expg)
hidden_size: 3, alpha: 1e-05, itera: 2000, reg_lambda: 1e-05 -> 0.00262100609572 (445.0 goals/446.376914791 expg)

hidden_size: 4, alpha: 0.001, itera: 100, reg_lambda: 0.01 -> 0.00248603474916 (445.0 goals/440.318180947 expg)
hidden_size: 4, alpha: 0.001, itera: 100, reg_lambda: 0.001 -> 0.00249082853325 (445.0 goals/440.424768987 expg)
hidden_size: 4, alpha: 0.001, itera: 100, reg_lambda: 0.0001 -> 0.00249130774357 (445.0 goals/440.435424008 expg)
hidden_size: 4, alpha: 0.001, itera: 100, reg_lambda: 1e-05 -> 0.00249135566292 (445.0 goals/440.436489472 expg) <=

hidden_size: 5, alpha: 0.001, itera: 100, reg_lambda: 0.01 -> 0.00170345075787 (445.0 goals/442.161478857 expg)
hidden_size: 5, alpha: 0.001, itera: 100, reg_lambda: 0.001 -> 0.00169932959231 (445.0 goals/442.26154184 expg)
hidden_size: 5, alpha: 0.001, itera: 100, reg_lambda: 0.0001 -> 0.00169891760105 (445.0 goals/442.271544911 expg)
hidden_size: 5, alpha: 0.001, itera: 100, reg_lambda: 1e-05 -> 0.00169887640318 (445.0 goals/442.272545186 expg) <=
hidden_size: 5, alpha: 0.0001, itera: 1000, reg_lambda: 0.01 -> 0.00170043687776 (445.0 goals/442.223863277 expg)
hidden_size: 5, alpha: 0.0001, itera: 1000, reg_lambda: 0.001 -> 0.00169630219822 (445.0 goals/442.324148836 expg)
hidden_size: 5, alpha: 0.0001, itera: 1000, reg_lambda: 0.0001 -> 0.00169588885973 (445.0 goals/442.334174084 expg)
hidden_size: 5, alpha: 0.0001, itera: 1000, reg_lambda: 1e-05 -> 0.00169584752718 (445.0 goals/442.335176576 expg)

"""

network = regularization_5.Network(hidden_size=3, alpha=0.00001, iter=2000, reg_lambda=0.1)
network.fit(features, targets)
network.save_weights('save/5_regularization')

log.info("END")
