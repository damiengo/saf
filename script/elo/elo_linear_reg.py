#!/usr/bin/python2.7
# -*- coding: utf-8 -*-

from pandas import *
from numpy import *
from sklearn import naive_bayes as nb
from sklearn import cross_validation
import matplotlib.pyplot as plt

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
def classifersTest(X, y):
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
        clf.fit(X_train, y_train)
        score = clf.score(X_test, y_test)
        print("Classifier %s: mean %0.2f std %0.2f" % (name, score.mean(), score.std()))

"""
 Main launcher.
"""
def main():
    print("==== START ELO ====")

    elo_histo = DataFrame.from_csv('../../data/stats/results_ligue1_elo.tsv', sep='\t', index_col=False)

    team_names = Series(elo_histo['home_team']).unique()

    teams = DataFrame()
    for team_name in team_names:
        print "==============================="
        print team_name
        teams.set_value(team_name, team_name, elo_histo[(elo_histo.home_team == team_name) | (elo_histo.away_team == team_name)])

    # Reorder datas programmatically

    target = elo_histo.loc[:,'result']
    train  = elo_histo.loc[:,['home_elo', 'away_elo']]

    classifersTest(train, target)

    print("==== END ELO ====")

if __name__=="__main__":
    main()
