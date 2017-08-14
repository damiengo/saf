# -*- coding: utf-8 -*-
import logging as log

class CleanData:

    def __init__(self):
        log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')

    def run(self, df):
        # No penalties and own goals
        df = df[df.penalty == False]
        df = df[df.own_goal == False]

        # Normalize values
        df['distance']      = self.normalize(df, 'distance')
        df['degree']        = self.normalize(df, 'degree')
        df['pass_distance'] = self.normalize(df, 'pass_distance')
        df['minsec_diff']   = self.normalize(df, 'minsec_diff')

        return df

    def normalize(self, df, column):
        return (df[column] - df[column].min())/(df[column].max() - df[column].min())
