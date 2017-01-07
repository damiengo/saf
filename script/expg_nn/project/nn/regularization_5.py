# -*- coding: utf-8 -*-
#
# 2017/01/05
#
import numpy as np
from sklearn import preprocessing
import logging as log

import sys
import os

sys.path.append(os.path.abspath("/home/dam/www/saf/script/soccerfield"))
from soccerfield import *

# An object oriented neural network
# Regul: http://cs231n.github.io/neural-networks-2/#reg
#        http://www.wildml.com/2015/09/implementing-a-neural-network-from-scratch/
#        http://neuralnetworksanddeeplearning.com/chap3.html
class Network:
    def __init__(self, input, target):
        np.random.seed(8)
        np.set_printoptions(precision=5, suppress=True, threshold='nan')
        log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')
        self.set_data(input, target)
        self.hiddenSize = 2
        self.alpha      = 0.0001
        self.iter       = 2000
        self.reg_lambda = 0.001
        self.s1_weights = self.randomWeights(self.input.shape[1], self.hiddenSize)
        self.s2_weights = self.randomWeights(self.hiddenSize, 1)

    def set_data(self, input, target):
        self.input  = preprocessing.scale(input)
        # Add the bias unit for first layer
        self.input  = np.c_[self.input, np.ones(self.input.shape[0])]
        self.target = target

    # 2 layers network
    def fit(self, backward=True):
        for j in xrange(self.iter):
            # Forward
            layer1_out = self.sigmoid(np.dot(self.input, self.s1_weights))
            layer2_out = self.sigmoid(np.dot(layer1_out, self.s2_weights))

            # Backward
            if(backward):
                # Error is the difference between expected and calculated values
                layer2_error    = self.target - layer2_out.T
                # Gradient is the derivative of the layer2 out
                layer2_gradient = self.sigmoid_grad(layer2_out)
                # Delta is the derivate multiplicated by the error to get the force
                layer2_delta    = layer2_error.T * layer2_gradient

                layer1_error    = layer2_delta.dot(self.s2_weights.T)
                layer1_gradient = self.sigmoid_grad(layer1_out)
                layer1_delta    = layer1_error * layer1_gradient

                dW2 = np.dot(layer1_out.T, layer2_delta)
                dW1 = np.dot(self.input.T, layer1_delta)

                dW2 += self.reg_lambda * self.s2_weights
                dW1 += self.reg_lambda * self.s1_weights

                self.s2_weights += self.alpha * dW2
                self.s1_weights += self.alpha * dW1

                if (j% (self.iter/10)) == 0:
                    log.debug(str(j)+' : '+str(np.mean(np.abs(layer2_error))))

        return layer2_out

    """
    Print weights.
    """
    def print_weights(self):
        log.info("==== S1 weights ====")
        log.info(self.s1_weights)
        log.info("==== S2 weights ====")
        log.info(self.s2_weights)

    """
    Save the weights into files.
    """
    def save_weights(self, save_dir):
        self.s1_weights.dump(save_dir+'/s1_weights.dump')
        self.s2_weights.dump(save_dir+'/s2_weights.dump')

    """
    Load weights from files.
    """
    def load_weights(self, save_dir):
        self.s1_weights = np.load(save_dir+'/s1_weights.dump')
        self.s2_weights = np.load(save_dir+'/s2_weights.dump')

    # The sigmoid function
    def sigmoid(self, values):
        return 1/(1+np.exp(-values))

    # The gradient sigmoid function
    def sigmoid_grad(self, values):
        return values * (1 - values)

    # Generate random weights
    def randomWeights(self, inputSize, outputSize):
        return (np.random.random((inputSize, outputSize)) * 2) - 1
