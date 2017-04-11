# -*- coding: utf-8 -*-
#
# 2017/04/11
#

from sklearn import linear_model
import numpy as np
import logging as log

# A LogisticRegression model
class Model:
    def __init__(self):
        np.random.seed(8)
        np.set_printoptions(precision=5, suppress=True, threshold='nan')
        log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')

    # Fitting the model
    def fit(self, features, target):
        clf = linear_model.LogisticRegression()
        clf.fit(features, target)
