# -*- coding: utf-8 -*-
import logging as log

class TargetFeatures:

    def __init__(self):
        log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')

    def run(self, df):
        y = df['goal'].as_matrix()
        X = df.drop('goal', axis=1, inplace=False).as_matrix()

        return X, y
