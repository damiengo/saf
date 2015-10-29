#!/usr/bin/python2.7

from pandas import *
from numpy import *
from sklearn import linear_model
import sklearn
#from sklearn.cross_validation import cross_val_predict

def main():
    print("==== START ELO ====")
    print sklearn.__verion__

    elo_histo = DataFrame.from_csv('../../data/stats/results_ligue1_elo.tsv', sep='\t', index_col=False)

    target = elo_histo.loc[:,'result_1']
    train  = elo_histo.loc[:,['home_elo', 'away_elo', 'elo_diff']]

    model = linear_model.LinearRegression()
    predicted = cross_val_predict(model, train, target, cv=10)

    print("==== END ELO ====")

if __name__=="__main__":
    main()
