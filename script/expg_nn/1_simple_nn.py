# -*- coding: utf-8 -*-
import numpy as np

# Main function
if __name__=="__main__":
    print("START")
    all_shots = np.genfromtxt('../../data/stats/expg/shots_2014_2016.csv', delimiter=';', dtype=None , names=True)
    sample = all_shots

    target = sample['goal']

    features_columns = ['degree', 'distance', 'shot_headed']
    features = sample[features_columns]

    # 1- Forward propagation
    np.random.seed(8)
    weights = (np.random.random(len(features_columns)) * 2) - 1
    print weights
    #biases

    print("END")
