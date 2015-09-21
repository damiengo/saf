#!/usr/bin/python2.7

from sklearn import cross_validation
from sklearn.linear_model import LogisticRegression, LinearRegression
from sklearn.ensemble import RandomForestClassifier
from numpy import genfromtxt, loadtxt, asarray, savetxt, c_, newaxis
from pandas import DataFrame, read_csv, concat

def main():
    print("==== START ====")

    dataset = DataFrame.from_csv('../data/stats/shots_teams_2013_2014.tsv', sep='\t', index_col=False)
    current_day = DataFrame.from_csv('../data/stats/shots_players_2015.tsv', sep='\t', index_col=False)

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
    model = model.fit(train_features, train_target)

    predicted_probs = model.predict_proba(test_features)
    predicted_goals = DataFrame(predicted_probs[:,1], columns=['predict'])

    results = concat([dataset_test, predicted_goals], axis=1)
    grouped_results = results.groupby(['start', 'name']).sum()
    grouped_results["count"] = results.groupby(['start', 'name']).size()
    grouped_results["ratio"] = grouped_results["predict"]/grouped_results["count"]

    DataFrame(grouped_results).to_csv('../data/stats/exp_goals_players_2015.tsv', sep='\t', encoding='utf-8')

    print("==== END ====")

if __name__=="__main__":
    main()
