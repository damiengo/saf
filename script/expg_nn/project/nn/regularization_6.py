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

"""
RESULTS:

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
