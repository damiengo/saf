#!/usr/bin/python2.7

from pandas import *
from numpy import *
import matplotlib.pyplot as plt
import matplotlib

def main():
    print("==== START ELO ====")

    elo_histo = DataFrame.from_csv('../../data/stats/results_ligue1_elo.tsv', sep='\t', index_col=False)

    target = elo_histo.loc[:,'result_1']
    train  = elo_histo.loc[:,['home_elo', 'away_elo']]

    markers = {1: '+', 2: '*', 3: '_'}

    for x, y, c, m in zip(elo_histo['home_elo'], elo_histo['away_elo'], elo_histo['result'], elo_histo['result'].map(markers)):
      plt.scatter(x=x, y=y, c=c, marker=m)

    plt.show()

    print("==== END ELO ====")

if __name__=="__main__":
    main()
