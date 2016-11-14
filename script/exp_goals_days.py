#!/usr/bin/python2.7

from sklearn import cross_validation
from sklearn.linear_model import LogisticRegression, LinearRegression
from sklearn.ensemble import RandomForestClassifier
from numpy import genfromtxt, loadtxt, asarray, savetxt, c_, newaxis
from pandas import DataFrame, read_csv, concat

def main():
    print("==== START ====")

    dataset = DataFrame.from_csv('../data/stats/shots_teams_2013_2014.tsv', sep='\t', index_col=False)
    current_day = DataFrame.from_csv('../data/stats/shots_games_2015_J13.tsv', sep='\t', index_col=False)

    target = dataset.loc[:,'goal']
    train = dataset.loc[:,['degree', 'distance', 'shot_headed', 'corner']]

    # For using the model
    train_target   = target
    train_features = train

    dataset_test = current_day
    test_target = dataset_test.loc[:,'goal']
    test_features = dataset_test.loc[:,['degree', 'distance', 'shot_headed', 'corner']]

    dataset_test = dataset_test.reset_index(drop=True)
    test_target = test_target.reset_index(drop=True)
    test_features = test_features.reset_index(drop=True)

    model = LogisticRegression()
    #model = RandomForestClassifier(n_estimators = 100)
    model = model.fit(train_features, train_target)

    #kf_total = cross_validation.KFold(len(test_features), n_folds=2)
    #scores = cross_validation.cross_val_score(model, asarray(test_features), asarray(test_target), cv=kf_total, n_jobs=1)

    #print("Accuracy: %0.2f (+/- %0.2f)" % (scores.mean(), scores.std() * 2))

    predicted_probs = model.predict_proba(test_features)
    predicted_goals = DataFrame(predicted_probs[:,1], columns=['predict'])

    results = concat([dataset_test, predicted_goals], axis=1)
    grouped_results = results.groupby(['game_id'])

    results.to_csv('../data/stats/exp_goals_days_J13.tsv', sep='\t', encoding='utf-8')

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
    print "Intercept: %.9f" % reg.intercept_

    #savetxt('../data/stats/exp_goals.tsv', results, delimiter='\t', fmt='%f', header="x\ty\thead\tpredict")

    print("==== END ====")

if __name__=="__main__":
    main()
