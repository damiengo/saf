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
    def __init__(self, hidden_size=2, alpha=0.0001, iter=2000, reg_lambda=0.001):
        np.random.seed(8)
        np.set_printoptions(precision=5, suppress=True, threshold='nan')
        log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')
        self.hiddenSize = hidden_size
        self.alpha      = alpha
        self.iter       = iter
        self.reg_lambda = reg_lambda

    def set_data(self, input):
        input  = preprocessing.scale(input)
        # Add the bias unit for first layer
        input  = np.c_[input, np.ones(input.shape[0])]

        return input

    # 2 layers network
    def fit(self, input, target, backward=True):
        input = self.set_data(input)
        self.s1_weights = self.randomWeights(input.shape[1], self.hiddenSize)
        self.s2_weights = self.randomWeights(self.hiddenSize, 1)
        for j in xrange(self.iter):
            # Forward
            layer1_out, layer2_out = self.predict(input, True)

            # Backward
            if(backward):
                # Reshape target to make each element as an array
                target = target.reshape((target.shape[0], 1))
                # Error is the difference between expected and calculated values
                layer2_error    = self.cost_function(target, layer2_out)
                # Gradient is the derivative of the layer2 out
                #layer2_gradient = self.activation_grad(layer2_out)
                layer2_gradient = layer2_out - target
                # Delta is the derivate multiplicated by the error to get the force
                layer2_delta    = layer2_error * layer2_gradient

                # How much layer 1 weights contributes to layer 2 error?
                layer1_error    = layer2_delta.dot(self.s2_weights.T)
                layer1_gradient = self.activation_grad(layer1_out)
                layer1_delta    = layer1_error * layer1_gradient

                dW2 = np.dot(layer1_out.T, layer2_delta)
                dW1 = np.dot(input.T, layer1_delta)

                dW2 += self.reg_lambda * self.s2_weights
                dW1 += self.reg_lambda * self.s1_weights

                self.s2_weights -= self.alpha * dW2
                self.s1_weights -= self.alpha * dW1

        return layer2_out

    """
    Predictions.
    """
    def predict(self, input, all_layers = False):
        layer1_out = self.activation(np.dot(input,      self.s1_weights))
        layer2_out = self.activation(np.dot(layer1_out, self.s2_weights))

        if(all_layers):
            return [layer1_out, layer2_out]
        else:
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

    """
    Activation function.
    """
    def activation(self, values):
        return self.sigmoid(values)

    def activation_grad(self, values):
        return self.sigmoid_grad(values)

    # The sigmoid function
    def sigmoid(self, values):
        return 1/(1+np.exp(-values))

    # The gradient sigmoid function
    def sigmoid_grad(self, values):
        return values * (1 - values)

    # The identity function
    def identity(self, values):
        return values

    # The gradient identity function
    def identity_grad(self, values):
        return 1

    # Softmax
    def softmax(self, values):
        return np.exp(values) / np.sum(np.exp(values))

    # The softmax derivative
    def softmax_grad(self, values):
        print 1

    # The cost function used
    def cost_function(self, target, predicted):
        return self.cross_entropy(target, predicted)

    # The cross-entropy cost function
    # http://neuralnetworksanddeeplearning.com/chap3.html#the_cross-entropy_cost_function
    # https://github.com/mnielsen/neural-networks-and-deep-learning/blob/master/src/network2.py
    def cross_entropy(self, target, predicted):
        return np.sum(np.nan_to_num(target*np.log(predicted)+(1-target)*np.log(1-predicted)))/len(target)

    # Generate random weights
    def randomWeights(self, inputSize, outputSize):
        return (np.random.random((inputSize, outputSize)) * 2) - 1
