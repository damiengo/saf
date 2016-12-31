"""
Generate a file with matches series.
"""

import pandas as pd

def transform_matches_series(csv_path):
    df = pd.read_csv(csv_path)
    df['home_win']  = df['home_team_goal'] >  df['away_team_goal']
    df['home_draw'] = df['home_team_goal'] == df['away_team_goal']
    df['home_lose'] = df['home_team_goal'] <  df['away_team_goal']
    df['away_win']  = df['away_team_goal'] >  df['home_team_goal']
    df['away_draw'] = df['away_team_goal'] == df['home_team_goal']
    df['away_lose'] = df['away_team_goal'] <  df['home_team_goal']
    df['stage']     = df.stage.astype(int)
    for index, row in df.iterrows():
        print df.loc[index, 'home_team']
        print row.home_team
        print row.away_team
        home_s_m1 = df[  (df.stage < row.stage)
                 & (df.season == row.season)
                 & (df.stage > 1)
                 & (
                    (df.home_team == row.home_team)
                  #  | (df.home_team == row.away_team)
                   )
                ]
        print home_s_m1
        df.loc[index, 'home_s_m1'] = home_s_m1

    print df.tail()
