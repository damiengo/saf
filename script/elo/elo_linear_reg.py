#!/usr/bin/python2.7
# -*- coding: utf-8 -*-

from pandas import *
from numpy import *
from sklearn import naive_bayes as nb
from sklearn import cross_validation
import matplotlib.pyplot as plt
import copy

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
def classifersTest(X, y, data):
    names = ["Nearest Neighbors", "Linear SVM", "RBF SVM", "Decision Tree",
         "Random Forest", "AdaBoost", "Naive Bayes", "LDA", "QDA"]
    classifiers = [
        KNeighborsClassifier(3),
        SVC(kernel="linear", C=0.025),
        SVC(gamma=2, C=1),
        DecisionTreeClassifier(max_depth=5),
        RandomForestClassifier(max_depth=5, n_estimators=10, max_features=1),
        AdaBoostClassifier(),
        GaussianNB(),
        LDA(),
        QDA()]

    X_train, X_test, y_train, y_test = cross_validation.train_test_split(X, y)
    # iterate over classifiers
    for name, clf in zip(names, classifiers):
        X_graph = copy.deepcopy(X)
        clf.fit(X_train, y_train)
        score = clf.score(X_test, y_test)
        predicted = clf.predict(X)

        X_graph['predicted'] = predicted
        X_graph['result'] = y
        X_graph['kickoff'] = data['kickoff']

        X_graph = X_graph.set_index(DatetimeIndex(X_graph['kickoff']), drop=False)

        summed_ok  = X_graph[X_graph['predicted'] == X_graph['result']].groupby(TimeGrouper("M")).count()
        summed_all = X_graph.groupby(TimeGrouper("M")).count()

        summed_ok['all'] = summed_all['result']
        summed_ok['ratio'] = summed_ok['result'] / summed_ok['all']


        print("Classifier %s: mean %0.2f std %0.2f" % (name, score.mean(), score.std()))
        print("%i/%i" % ((predicted == y).sum(), y.sum()))
        print summed_ok[['result', 'all', 'ratio']]

"""
 Main launcher.
"""
def main():
    print("==== START ELO ====")

    elo_histo = DataFrame.from_csv('../../data/stats/results_ligue1_elo.tsv', sep='\t', index_col=False)

    target = elo_histo.loc[:,'result']
    train  = elo_histo.loc[:,['home_elo', 'away_elo', 'home_1m_elo_diff', 'away_1m_elo_diff']]

    classifersTest(train, target, elo_histo)

    print("==== END ELO ====")

if __name__=="__main__":
    main()
