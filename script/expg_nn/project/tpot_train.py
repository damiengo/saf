# -*- coding: utf-8 -*-
import sys
import pandas as pd
import numpy as np
import logging as log
from sklearn.model_selection import train_test_split
from sklearn_ import tpot_
from data_preparation import clean_data
from data_preparation import target_features

# Data normalization
def normalize(df, column):
    return (df[column] - df[column].min())/(df[column].max() - df[column].min())

log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')
log.info("START")

if(len(sys.argv) < 3):
    print "Use: command <datas> <output"
    sys.exit(2)

train_file = sys.argv[1]
save_file  = sys.argv[2]

all_shots = pd.read_csv(train_file)

# Cleaning
cd = clean_data.CleanData()
all_shots = cd.run(all_shots)

# Train/test splitting
tf = target_features.TargetFeatures()
X  = all_shots[tf.X].as_matrix()
y  = all_shots[tf.y].as_matrix()

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.25, random_state=42)

# Choose model
model_chooser = tpot_.ModelChooser()
model_chooser.run(X_train, y_train, X_test, y_test, save_file)

"""
Results:
Normalized: 0.902096291177 - XGBClassifier(max_depth=3, n_estimators=100, nthread=1, subsample=0.45)
No-Normalized: 0.902787376181 - XGBClassifier(max_depth=2, min_child_weight=9, n_estimators=100, nthread=1, subsample=0.65)

No-Normalized: 0.908546417876 - LogisticRegression(input_matrix, LogisticRegression__C=10.0, LogisticRegression__dual=DEFAULT, LogisticRegression__penalty=l2)
Normalized: 0.908776779544 - LogisticRegression(input_matrix, LogisticRegression__C=10.0, LogisticRegression__dual=DEFAULT, LogisticRegression__penalty=l2)

Normalized: 0.907164247869
exported_pipeline = make_pipeline(
    StackingEstimator(estimator=LinearSVC(C=10.0, dual=True, loss="squared_hinge", penalty="l2")),
    ExtraTreesClassifier(criterion="entropy", max_features=0.65, min_samples_leaf=12, min_samples_split=5)
)
"""

log.info("END")
