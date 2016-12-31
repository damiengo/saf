import sqlite3 as sq
import pandas as pd

def extract_matches(db_path, csv_path):
    query = " \
             SELECT \
               l.name AS league, \
               m.season, \
               m.stage, \
               m.date, \
               ht.team_long_name AS home_team, \
               at.team_long_name AS away_team, \
               m.home_team_goal, \
               m.away_team_goal, \
               CASE \
                 WHEN m.home_team_goal > m.away_team_goal THEN '1' \
                 WHEN m.home_team_goal = m.away_team_goal THEN '2' \
                 WHEN m.home_team_goal < m.away_team_goal THEN '3' \
                 ELSE NULL \
               END AS 'result', \
               m.B365H, \
               m.B365D, \
               m.B365A, \
               1/(m.B365H*1.0) AS home_proba, \
               1/(m.B365D*1.0) AS draw_proba, \
               1/(m.B365A*1.0) AS away_proba, \
               1/(m.B365H*1.0)+1/(m.B365D*1.0)+1/(m.B365A*1.0) AS sum_proba_b365, \
             "
    for i in range(1, 11):
        query += "CASE \
                    WHEN hmm"+str(i)+".home_team_api_id = m.home_team_api_id THEN \
                      CASE \
                        WHEN hmm"+str(i)+".home_team_goal > hmm"+str(i)+".away_team_goal THEN '1' \
                        WHEN hmm"+str(i)+".home_team_goal = hmm"+str(i)+".away_team_goal THEN '2' \
                        WHEN hmm"+str(i)+".home_team_goal < hmm"+str(i)+".away_team_goal THEN '3' \
                        ELSE NULL \
                      END \
                    ELSE \
                      CASE \
                        WHEN hmm"+str(i)+".home_team_goal < hmm"+str(i)+".away_team_goal THEN '1' \
                        WHEN hmm"+str(i)+".home_team_goal = hmm"+str(i)+".away_team_goal THEN '2' \
                        WHEN hmm"+str(i)+".home_team_goal > hmm"+str(i)+".away_team_goal THEN '3' \
                        ELSE NULL \
                      END \
                  END AS mm"+str(i)+"_home_result, \
                  CASE \
                    WHEN amm"+str(i)+".home_team_api_id = m.away_team_api_id THEN \
                      CASE \
                        WHEN amm"+str(i)+".home_team_goal > amm"+str(i)+".away_team_goal THEN '1' \
                        WHEN amm"+str(i)+".home_team_goal = amm"+str(i)+".away_team_goal THEN '2' \
                        WHEN amm"+str(i)+".home_team_goal < amm"+str(i)+".away_team_goal THEN '3' \
                        ELSE NULL \
                      END \
                    ELSE \
                      CASE \
                        WHEN amm"+str(i)+".home_team_goal < amm"+str(i)+".away_team_goal THEN '1' \
                        WHEN amm"+str(i)+".home_team_goal = amm"+str(i)+".away_team_goal THEN '2' \
                        WHEN amm"+str(i)+".home_team_goal > amm"+str(i)+".away_team_goal THEN '3' \
                        ELSE NULL \
                    END \
                  END AS mm"+str(i)+"_away_result, \
                 "
    query += "m.date \
             FROM \
               Match m \
             INNER JOIN \
               Team ht ON m.home_team_api_id = ht.team_api_id \
             INNER JOIN \
               Team at ON m.away_team_api_id = at.team_api_id \
             INNER JOIN \
               League l ON m.league_id = l.id \
             "
    for i in range(1, 11):
        query +="LEFT JOIN \
                   Match hmm"+str(i)+" ON (m.home_team_api_id = hmm"+str(i)+".home_team_api_id OR m.home_team_api_id = hmm"+str(i)+".away_team_api_id) \
                   AND m.season = hmm"+str(i)+".season \
                   AND m.stage = hmm"+str(i)+".stage+"+str(i)+" \
                LEFT JOIN \
                   Match amm"+str(i)+" ON (m.away_team_api_id = amm"+str(i)+".home_team_api_id OR m.away_team_api_id = amm"+str(i)+".away_team_api_id) \
                   AND m.season = amm"+str(i)+".season \
                   AND m.stage = amm"+str(i)+".stage+"+str(i)+" \
                 "
    query +="ORDER BY \
               m.season ASC, \
               m.stage ASC \
            "

    conn = sq.connect(db_path)
    df = pd.read_sql(query, conn)
    df.to_csv(csv_path, sep=',', encoding='utf-8')
    conn.close()


