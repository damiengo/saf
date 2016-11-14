#!/usr/bin/python2.7
# -*- coding: utf-8 -*-

from pandas import *
from numpy import *

from sklearn.ensemble import RandomForestClassifier

import xgboost as xgb

"""
 Main launcher.
"""
def main():
    print("==== START EURO 2016 ====")

    # Loading teams
    teams = DataFrame.from_csv('teams.csv', sep=',', index_col=False)

    # Loading results
    results = DataFrame()
    for year in xrange(1996, 2016, 4):
        current = DataFrame.from_csv('results_'+`year`+'.csv', sep=',', index_col=False)
        current['year'] = str(year)
        results = concat([results, current])

    # http://chrisalbon.com/python/pandas_join_merge_dataframe.html
    # Merging team1
    merged = merge(results, teams, how='left', left_on=['team1', 'year'], right_on=['abbr', 'euro'])
    merged.columns = [
                      'team1',
                      'team2',
                      'goals1',
                      'goals2',
                      'year',
                      'abbr_team1',
                      'name_team1',
                      'euro_team1',
                      'fifa_rank_team1',
                      'pop_team1',
                      'gdp_team1',
                      'prev_team1'
                     ]

    # Merging team2
    merged = merge(merged, teams, how='left', left_on=['team2', 'year'], right_on=['abbr', 'euro'])
    merged.columns = [
                      'team1',
                      'team2',
                      'goals1',
                      'goals2',
                      'year',
                      'abbr_team1',
                      'name_team1',
                      'euro_team1',
                      'fifa_rank_team1',
                      'pop_team1',
                      'gdp_team1',
                      'prev_team1',
                      'abbr_team2',
                      'name_team2',
                      'euro_team2',
                      'fifa_rank_team2',
                      'pop_team2',
                      'gdp_team2',
                      'prev_team2'
                     ]

    # Results
    merged['home_win'] = merged['goals1'] > merged['goals2']
    merged['draw']     = merged['goals1'] == merged['goals2']
    merged['away_win'] = merged['goals1'] < merged['goals2']

    merged['home_win'] = merged.home_win.apply(lambda x: 1 if x else 0)
    merged['draw']     = merged.draw.apply(lambda x: 1 if x else 0)
    merged['away_win'] = merged.away_win.apply(lambda x: 1 if x else 0)

    merged['numeric_result'] = (merged.home_win + 2 * merged.draw + 3 * merged.away_win) - 1

    merged = merged.fillna(-1)

    # Reverse team1 and team2
    merged_reversed = merged.copy()
    merged_reversed.columns = [
                      'team2',
                      'team1',
                      'goals2',
                      'goals1',
                      'year',
                      'abbr_team2',
                      'name_team2',
                      'euro_team2',
                      'fifa_rank_team2',
                      'pop_team2',
                      'gdp_team2',
                      'prev_team2',
                      'abbr_team1',
                      'name_team1',
                      'euro_team1',
                      'fifa_rank_team1',
                      'pop_team1',
                      'gdp_team1',
                      'prev_team1',
                      'away_win',
                      'draw',
                      'home_win',
                      'numeric_result'
                     ]
    merged_reversed['numeric_result'] = 2 - merged_reversed.numeric_result
    merged = merged.append(merged_reversed)

    # 2016 datas
    euro_2016 = DataFrame.from_csv('results_2016.csv', sep=',', index_col=False)
    euro_2016['year'] = '2016'
    # Merging team1
    euro_2016_m = merge(euro_2016, teams, how='left', left_on=['team1', 'year'], right_on=['abbr', 'euro'])
    euro_2016_m.columns = [
                      'team1',
                      'team2',
                      'year',
                      'abbr_team1',
                      'name_team1',
                      'euro_team1',
                      'fifa_rank_team1',
                      'pop_team1',
                      'gdp_team1',
                      'prev_team1'
                     ]

    # Merging team2
    euro_2016_m = merge(euro_2016_m, teams, how='left', left_on=['team2', 'year'], right_on=['abbr', 'euro'])
    euro_2016_m.columns = [
                      'team1',
                      'team2',
                      'year',
                      'abbr_team1',
                      'name_team1',
                      'euro_team1',
                      'fifa_rank_team1',
                      'pop_team1',
                      'gdp_team1',
                      'prev_team1',
                      'abbr_team2',
                      'name_team2',
                      'euro_team2',
                      'fifa_rank_team2',
                      'pop_team2',
                      'gdp_team2',
                      'prev_team2'
                     ]

    euro_2016_m = euro_2016_m.fillna(-1)

    # Classification
    features_columns = ['fifa_rank_team1', 'pop_team1', 'gdp_team1', 'prev_team1',
                        'fifa_rank_team2', 'pop_team2', 'gdp_team2', 'prev_team2']
    features = merged.loc[:, features_columns]
    #target   = merged.loc[:,['home_win', 'draw', 'away_win']]
    target   = merged.numeric_result



    features['fifa_rank_team1'] = features['fifa_rank_team1'].apply(lambda x: int(x))
    features['fifa_rank_team2'] = features['fifa_rank_team2'].apply(lambda x: int(x))
    features['pop_team1'] = features['pop_team1'].apply(lambda x: float(x))
    features['pop_team2'] = features['pop_team2'].apply(lambda x: float(x))
    features['gdp_team1'] = features['gdp_team1'].apply(lambda x: float(x))
    features['gdp_team2'] = features['gdp_team2'].apply(lambda x: float(x))
    features['prev_team1'] = features['prev_team1'].apply(lambda x: int(x))
    features['prev_team2'] = features['prev_team2'].apply(lambda x: int(x))

    euro_2016_m['fifa_rank_team1'] = euro_2016_m['fifa_rank_team1'].apply(lambda x: int(x))
    euro_2016_m['fifa_rank_team2'] = euro_2016_m['fifa_rank_team2'].apply(lambda x: int(x))
    euro_2016_m['pop_team1'] = euro_2016_m['pop_team1'].apply(lambda x: float(x))
    euro_2016_m['pop_team2'] = euro_2016_m['pop_team2'].apply(lambda x: float(x))
    euro_2016_m['gdp_team1'] = euro_2016_m['gdp_team1'].apply(lambda x: float(x))
    euro_2016_m['gdp_team2'] = euro_2016_m['gdp_team2'].apply(lambda x: float(x))
    euro_2016_m['prev_team1'] = euro_2016_m['prev_team1'].apply(lambda x: int(x))
    euro_2016_m['prev_team2'] = euro_2016_m['prev_team2'].apply(lambda x: int(x))

    proba_2016 = boosted(features, target, features_columns, euro_2016_m)
    #proba_2016 = rfclassifier(features, target, features_columns, euro_2016_m)

    euro_2016_result = concat([euro_2016_m, DataFrame(proba_2016, columns=['home_win', 'draw', 'away_win'])], axis=1)

    results = euro_2016_result.loc[:, ['name_team1', 'name_team2', 'home_win', 'draw', 'away_win']]

    results.to_csv("result_xgboost.csv", sep=';', encoding='utf-8')
    #results.to_csv("result_randomforest.csv", sep=';', encoding='utf-8')
    print results

    print("==== END EURO 2016 ====")

# xgboost
def boosted(features, target, features_columns, euro_2016_m):
    print "  --> xgboost"
    train_xgb = xgb.DMatrix(features, target)
    test_xgb = xgb.DMatrix(euro_2016_m.loc[:, features_columns])
    params = {"max_depth": 30, "objective": "multi:softprob", "num_class": 3}
    gbm = xgb.train(params, train_xgb, 100)
    return gbm.predict(test_xgb)

# Random Forest Classifier
def rfclassifier(features, target, features_columns, euro_2016_m):
    print "  --> RandomForestClassifier"
    results = 0
    maxi = 1000
    for i in range(1, maxi):
        clf = RandomForestClassifier(n_estimators=100)
        clf.fit(features, target)
        predicted = clf.predict_proba(euro_2016_m.loc[:, features_columns])
        results = results + predicted

    return results/maxi

if __name__=="__main__":
    main()
