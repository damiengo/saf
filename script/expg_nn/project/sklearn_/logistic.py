# -*- coding: utf-8 -*-
#
# 2017/04/11
#

from sklearn import linear_model
from sklearn.externals import joblib
import numpy as np
import logging as log

# A LogisticRegression model
class Model:
    def __init__(self):
        np.random.seed(8)
        np.set_printoptions(precision=5, suppress=True, threshold='nan')
        log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')
        self.save_file = 'logistic_regression.save'
        self.clf = linear_model.LogisticRegression()

    # Fitting the model
    def fit(self, features, target):
        self.clf.fit(features, target)

    def predict(self, features):
        return self.clf.predict(features)

    def save(self, save_dir):
        joblib.dump(self.clf, save_dir+'/'+self.save_file)

    def load(self, save_dir):
        joblib.load(self.clf, save_dir+'/'+self.save_file)
