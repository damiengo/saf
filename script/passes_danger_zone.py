#!/usr/bin/python2.7

from pandas import *

def main():
    print("==== START PASSES DANGER ZONE ====")

    dz_origin = read_csv("../data/stats/passes_danger_zone/origin.tsv", sep="\t")

    grouped_teams = dz_origin.groupby(['pass_team']).count()

    print(grouped_teams)

    grouped_teams.to_csv("../data/stats/passes_danger_zone/teams.csv", header=True)

    print("==== END PASSES DANGER ZONE ====")

if __name__=="__main__":
    main()
