#!/usr/bin/python2.7

from sklearn import cross_validation
from sklearn.linear_model import LogisticRegression
from pandas import *
from numpy import *
import matplotlib.pyplot as plt
import matplotlib

def main():
    print("==== START ELO ====")

    elo_histo = DataFrame.from_csv('../data/stats/results_ligue1_elo.tsv', sep='\t', index_col=False)

    target = elo_histo.loc[:,'result_1']
    train  = elo_histo.loc[:,['home_elo', 'away_elo']]

    # For using the model
    train_target   = target
    train_features = train

    model = LogisticRegression()
    model = model.fit(train_features, train_target)

    plt.scatter(x=elo_histo['home_elo'], y=elo_histo['away_elo'], c=elo_histo['result'])
    plt.show()

    kf_total = cross_validation.KFold(len(train_features), n_folds=2)
    scores = cross_validation.cross_val_score(model, asarray(train_features), asarray(train_target), cv=kf_total, n_jobs=1)

    print("Accuracy: %0.2f (+/- %0.2f)" % (scores.mean(), scores.std() * 2))

    print("==== END ELO ====")

if __name__=="__main__":
    main()
