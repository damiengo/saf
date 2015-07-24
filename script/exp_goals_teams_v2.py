#!/usr/bin/python2.7

from sklearn import cross_validation
from sklearn.linear_model import LogisticRegression, LinearRegression
from numpy import genfromtxt, loadtxt, asarray, savetxt, c_, newaxis
from pandas import DataFrame, read_csv, concat

def main():
    print("==== START ====")

    # start	short_name	goal	start_x	start_y	headed
    #dataset = loadtxt('../data/stats/shots_position_head_teams_2012_2014.tsv',
    dataset = genfromtxt('../data/stats/shots_teams_2013_2014.tsv',
                      delimiter='\t',
                      usecols=(2,3,4,5,6,7,8,9,10),
                      dtype='f8',
                      #dtype={'names':   ('start', 'short_name', 'goal', 'start_x', 'start_y', 'headed'),
                      #'formats': ('i4', 'S30', 'i4', 'f8', 'f8', 'i4')},
                      skip_header=1)
    dataset = DataFrame.from_csv('../data/stats/shots_teams_2013_2014.tsv', sep='\t', index_col=False)

    target = [x[2] for x in dataset]
    train = [x[3:] for x in dataset]

    target = dataset.loc[:,'goal']
    train = dataset.loc[:,['degree', 'distance', 'shot_headed', 'crosses', 'corner', 'pass_throw_in', 'pass_long_ball', 'pass_through_ball', 'pass_headed']]

    test = genfromtxt(open('../data/stats/shots_teams_2013_2014.tsv','r'), delimiter='\t', dtype='f8', skip_header=1)

    model = LogisticRegression()
    model = model.fit(train, target)

    kf_total = cross_validation.KFold(len(train), n_folds=2)
    scores = cross_validation.cross_val_score(model, asarray(train), asarray(target), cv=kf_total, n_jobs=1)

    print("Accuracy: %0.2f (+/- %0.2f)" % (scores.mean(), scores.std() * 2))

    predicted_probs = model.predict_proba(train)
    predicted_goals = DataFrame(predicted_probs[:,1], columns=['predict'])

    results = concat([dataset, predicted_goals], axis=1)
    grouped_results = results.groupby(['start', 'short_name']).sum()

    grouped_results.to_csv('../data/stats/exp_goals_v2_by_teams.tsv', sep='\t', encoding='utf-8')

    lr = LinearRegression()
    goals = grouped_results.ix[:, 'goal'].tolist()
    predicts = grouped_results.ix[:,'predict'].tolist()
    goals = asarray(goals).round()
    predicts = asarray(predicts).round()
    print goals
    print predicts
    reg = lr.fit(predicts[:,newaxis], goals)
    print "R2: "+"%.9f" % reg.score(predicts[:,newaxis], goals)
    print reg.predict(predicts[:,newaxis])

    #savetxt('../data/stats/exp_goals.tsv', results, delimiter='\t', fmt='%f', header="x\ty\thead\tpredict")

    print("==== END ====")

if __name__=="__main__":
    main()
