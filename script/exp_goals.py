#!/usr/bin/python2.7

from sklearn import cross_validation
from sklearn.linear_model import LogisticRegression

def main():
    print("==== START ====")
    
    dataset = loadtxt('../data/stats/shots_position_bead.tsv', delimiter='\t', dtype='f8', skiprows=1)
    target = [x[0] for x in dataset]
    train = [x[1:] for x in dataset]
    test = genfromtxt(open('../data/stats/shots_position_head.tsv','r'), delimiter='\t', dtype='f8', skiprows=1)
    
    model = LogisticRegression()
    model = model.fit(train, target)
    
    kf_total = cross_validation.KFold(len(train), n_folds=2)
    scores = cross_validation.cross_val_score(model, asarray(train), asarray(target), cv=kf_total, n_jobs=1)

    print("Accuracy of %i: %0.2f (+/- %0.2f)" % (nb_train, scores.mean(), scores.std() * 2))
    
    print("==== END ====")