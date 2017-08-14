# -*- coding: utf-8 -*-
import sys
import logging as log
import pandas as pd
from data_preparation import clean_data
from data_preparation import target_features
from xgboost import XGBClassifier
from sklearn.linear_model import LogisticRegression

log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')
log.info("START")

if(len(sys.argv) < 3):
    print "Use: command <test> <predict>"
    sys.exit(2)

test_file    = sys.argv[1]
predict_file = sys.argv[2]
save_file    = sys.argv[3]

test_shots    = pd.read_csv(test_file)
predict_shots = pd.read_csv(predict_file)

# Cleaning
cd               = clean_data.CleanData()
test_shots_cl    = cd.run(test_shots)
predict_shots_cl = cd.run(predict_shots)

# Train/test splitting
tf = target_features.TargetFeatures()

# Predict
clf = LogisticRegression(C=10.0, penalty="l2")
clf.fit(test_shots_cl[tf.X], test_shots_cl[tf.y])
predicted = clf.predict_proba(predict_shots_cl[tf.X])

predict_shots_cl['expg'] = predicted[:,1]
predict_shots_cl.to_csv(save_file, index=False)

log.info("END")
