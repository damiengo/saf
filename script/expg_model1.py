
from sklearn.linear_model import LogisticRegression
from pandas import DataFrame

#
# Generate ExpG model
#
# @return model
#
def expg_model():
    dataset = DataFrame.from_csv('../data/stats/shots_teams_2013_2014.tsv', sep='\t', index_col=False)
    target = dataset.loc[:,'goal']
    train = dataset.loc[:,['degree', 'distance', 'shot_headed', 'corner']]
    model = LogisticRegression()
    model = model.fit(train, target)

    return model
