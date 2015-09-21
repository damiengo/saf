#!/usr/bin/python2.7

from pandas import *
import expg_model1

def main():
    print("==== START SUMMARY ====")

    sot = read_csv("../data/stats/2015/all_games_sot.tsv", sep="\t")
    pdo = read_csv("../data/stats/2015/all_games_pdo.tsv", sep="\t")
    tsr = read_csv("../data/stats/2015/all_games_tsr.tsv", sep="\t")

    sot.set_index('short_name', inplace=True)
    pdo.set_index('short_name', inplace=True)
    tsr.set_index('short_name', inplace=True)

    # ExpG
    expg_model = expg_model1.expg_model()
    teams_shots = DataFrame.from_csv('../data/stats/2015/all_games_shots_players.tsv', sep='\t', index_col=False)
    expg_features = teams_shots.loc[:,['degree', 'distance', 'shot_headed', 'corner']]
    predicted_probs = expg_model.predict_proba(expg_features)
    predicted_goals = DataFrame(predicted_probs[:,1], columns=['predict'])
    expg_result = concat([teams_shots, predicted_goals], axis=1)
    grouped_expg = expg_result.groupby(['start', 'team_name']).sum()

    grouped_expg.reset_index(inplace=True)
    grouped_expg.set_index('team_name', inplace=True)

    grouped = concat([sot, pdo, tsr, grouped_expg], axis=1)
    grouped["expg_ratio"] = grouped["predict"] / grouped["shots"]

    grouped.to_csv("../data/stats/2015/summary_l1.csv", header=True)

    print("==== END SUMMARY ====")

if __name__=="__main__":
    main()
