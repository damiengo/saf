# -*- coding: utf-8 -*-
import numpy as np
from sklearn import preprocessing
import logging as log

def forward(features, weights):
    n1_in = np.dot(features, weights)
    log.debug('dotted: '+str(n1_in))
    return 1/(1+np.exp(-n1_in))

# Main function
if __name__=="__main__":
    log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')

    log.info("START")
    all_shots = np.genfromtxt('../../data/stats/expg/shots_2014_2016.csv', delimiter=';', skip_header=1)
    sample = all_shots

    target = sample[:, 0]
    log.debug('target '+str(target))

    features = sample[:, 1:4]
    log.debug('features '+str(features))

    features_scaled = preprocessing.scale(features)
    log.debug('features scaled '+str(features_scaled))

    features = features_scaled

    # 0 - Features normalization

    # 1 - Forward propagation
    np.random.seed(8)
    weights = (np.random.random(3) * 2) - 1
    log.debug('weights '+str(weights))
    #biases

    max_iter = 1000
    alpha = 0.0001 # best 0.001

    for j in xrange(max_iter):
        n1_out = forward(features, weights)
        log.debug('out: '+str(n1_out))

        # Error (test RMSE)
        error = target - n1_out

        # 2 - Backpropagation
        gradient = error * (n1_out * (1 - n1_out))
        weights += alpha * np.dot(features.T, gradient)

        if (j% (max_iter/10)) == 0:
            log.debug(str(j)+'/'+str(max_iter))
            log.debug('n1 output '+str(n1_out))
            log.debug('error '+str(error))
            log.debug('error sum '+str(np.mean(np.abs(error))))
            log.debug('gradient '+str(gradient))

    log.debug(n1_out)

    log.info('Test Rennes 2016')
    rennes_shots = np.genfromtxt('../../data/stats/expg/shots_2016_rennes.csv', delimiter=';', skip_header=1)

    features_rennes = preprocessing.scale(rennes_shots[:, 5:8])
    rennes_target = rennes_shots[:, 2]
    rennes_out = forward(features_rennes, weights)
    rennes_result = np.c_[rennes_target, rennes_out]
    log.debug('Rennes out '+str(rennes_result))

    log.info("END")
