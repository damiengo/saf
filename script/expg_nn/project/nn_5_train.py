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
nb_folds = 5
hidden_sizes = [1, 2, 3, 4, 5]
alphas = [1, 0.1, 0.01, 0.001, 0.0001, 0.00001]
iters = [100, 500, 1000, 2000, 4000]
reg_lambdas = [1, 0.1, 0.01, 0.001, 0.0001, 0.00001]
kf = KFold(n_splits=nb_folds, shuffle=True)

for hidden_size in hidden_sizes:
    for alpha in alphas:
        for itera in iters:
            for reg_lambda in reg_lambdas:
                #log.info("hidden_size: "+str(hidden_size)+", alpha: "+str(alpha)+", itera: "+str(itera)+", reg_lambda: "+str(reg_lambda))
                total_acc = 0
                for train_index, test_index in kf.split(features):
                    X_train, X_test = features[train_index], features[test_index]
                    y_train, y_test = targets[train_index],  targets[test_index]
                    # Train network
                    network = regularization_5.Network(hidden_size=hidden_size, alpha=alpha, iter=itera, reg_lambda=reg_lambda)
                    network.fit(X_train, y_train)
                    X_test_setted = network.set_data(X_test)
                    y_test_predict = network.predict(X_test_setted)
                    acc = np.abs(np.mean(y_test - y_test_predict))
                    total_acc += acc
                    #log.info("Accuracy: %f" % (acc,))
                    #network.save_weights('save/5_regularization')
                log.info("Total accuracy for hidden_size: "+str(hidden_size)+", alpha: "+str(alpha)+", itera: "+str(itera)+", reg_lambda: "+str(reg_lambda)+" -> "+str(total_acc/nb_folds))

log.info("END")
