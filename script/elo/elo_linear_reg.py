#!/usr/bin/python2.7
# -*- coding: utf-8 -*-

from pandas import *
from numpy import *
from sklearn import naive_bayes as nb
from sklearn import cross_validation
import matplotlib.pyplot as plt
import copy
import datetime

from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.lda import LDA
from sklearn.qda import QDA

"""
 Test multiple classifiers throught features and target.
 http://scikit-learn.org/stable/auto_examples/plot_classifier_comparison.html
"""
def classifersTest(X, y, data, columns):
    names = ["Nearest Neighbors", "Linear SVM", "RBF SVM", "Decision Tree",
         "Random Forest", "AdaBoost", "Naive Bayes", "LDA", "QDA"]
    classifiers = [
        KNeighborsClassifier(100),
        SVC(kernel="linear", C=0.025),
        SVC(gamma=2, C=1),
        DecisionTreeClassifier(max_depth=5),
        RandomForestClassifier(max_depth=5, n_estimators=10, max_features=1),
        AdaBoostClassifier(),
        GaussianNB(),
        LDA(),
        QDA()]

    # For tests
    elo_real = DataFrame.from_csv('../../data/stats/results_ligue1_elo_2015.tsv', sep='\t', index_col=False)
    elo_real['kickoff'] = to_datetime(elo_real.kickoff)
    elo_real['month'] = elo_real.kickoff.apply(lambda x: x.strftime('%w'))
    test_real = elo_real.loc[:,columns]

    X_train, X_test, y_train, y_test = cross_validation.train_test_split(X, y)
    # iterate over classifiers
    for name, clf in zip(names, classifiers):
        clf.fit(X_train, y_train)
        score = clf.score(X_test, y_test)

        print(" --> Classifier %s: mean %0.2f std %0.2f" % (name, score.mean(), score.std()))
        print("TRAIN ##")
        predictClf(clf, data, columns, False)
        print("NEW ##")
        predictClf(clf, elo_real, columns, True)

"""
Tests a classifier and displays the result.
"""
def predictClf(clf, datas, columns, summed):
    copied = copy.deepcopy(datas)
    predicted = clf.predict(datas.loc[:, columns])

    copied['predicted'] = predicted

    copied = copied.set_index(DatetimeIndex(copied['kickoff']), drop=False)

    predicted_ok = copied[copied['predicted'] == copied['result']].count()

    summed_ok  = copied[copied['predicted'] == copied['result']].groupby(TimeGrouper("M")).count()
    summed_all = copied.groupby(TimeGrouper("M")).count()

    summed_ok['all'] = summed_all['result']
    summed_ok['ratio'] = summed_ok['result'] / summed_ok['all']
    summed_ok['ratio'] = summed_ok.ratio.apply(lambda x: 100*round(x, 2))

    print("Predict %i/%i" % (predicted_ok['result'], datas['result'].count()))
    if(summed): print summed_ok[['result', 'all', 'ratio']]

"""
 Main launcher.
"""
def main():
    print("==== START ELO ====")

    elo_histo = DataFrame.from_csv('../../data/stats/results_ligue1_elo.tsv', sep='\t', index_col=False)
    elo_histo['kickoff'] = to_datetime(elo_histo.kickoff)
    elo_histo['month'] = elo_histo.kickoff.apply(lambda x: x.strftime('%w'))

    columns = ['home_elo', 'away_elo', 'home_1m_elo_diff', 'away_1m_elo_diff', 'month']
    target = elo_histo.loc[:,'result']
    train  = elo_histo.loc[:,columns]

    classifersTest(train, target, elo_histo, columns)

    print("==== END ELO ====")

if __name__=="__main__":
    main()
