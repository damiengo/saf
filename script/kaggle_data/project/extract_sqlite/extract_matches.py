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
               1/(m.B365H*1.0) AS home_proba_b365, \
               1/(m.B365D*1.0) AS draw_proba_b365, \
               1/(m.B365A*1.0) AS away_proba_b365, \
               1/(m.B365H*1.0)+1/(m.B365D*1.0)+1/(m.B365A*1.0) AS sum_proba_b365, \
               m.BWH, \
               m.BWD, \
               m.BWA, \
               1/(m.BWH*1.0) AS home_proba_bw, \
               1/(m.BWD*1.0) AS draw_proba_bw, \
               1/(m.BWA*1.0) AS away_proba_bw, \
               1/(m.BWH*1.0)+1/(m.BWD*1.0)+1/(m.BWA*1.0) AS sum_proba_bw, \
               m.IWH, \
               m.IWD, \
               m.IWA, \
               1/(m.IWH*1.0) AS home_proba_iw, \
               1/(m.IWD*1.0) AS draw_proba_iw, \
               1/(m.IWA*1.0) AS away_proba_iw, \
               1/(m.IWH*1.0)+1/(m.IWD*1.0)+1/(m.IWA*1.0) AS sum_proba_iw, \
               m.LBH, \
               m.LBD, \
               m.LBA, \
               1/(m.LBH*1.0) AS home_proba_lb, \
               1/(m.LBD*1.0) AS draw_proba_lb, \
               1/(m.LBA*1.0) AS away_proba_lb, \
               1/(m.LBH*1.0)+1/(m.LBD*1.0)+1/(m.LBA*1.0) AS sum_proba_lb, \
               m.PSH, \
               m.PSD, \
               m.PSA, \
               1/(m.PSH*1.0) AS home_proba_ps, \
               1/(m.PSD*1.0) AS draw_proba_ps, \
               1/(m.PSA*1.0) AS away_proba_ps, \
               1/(m.PSH*1.0)+1/(m.PSD*1.0)+1/(m.PSA*1.0) AS sum_proba_ps, \
               m.WHH, \
               m.WHD, \
               m.WHA, \
               1/(m.WHH*1.0) AS home_proba_wh, \
               1/(m.WHD*1.0) AS draw_proba_wh, \
               1/(m.WHA*1.0) AS away_proba_wh, \
               1/(m.WHH*1.0)+1/(m.WHD*1.0)+1/(m.WHA*1.0) AS sum_proba_wh, \
               m.SJH, \
               m.SJD, \
               m.SJA, \
               1/(m.SJH*1.0) AS home_proba_sj, \
               1/(m.SJD*1.0) AS draw_proba_sj, \
               1/(m.SJA*1.0) AS away_proba_sj, \
               1/(m.SJH*1.0)+1/(m.SJD*1.0)+1/(m.SJA*1.0) AS sum_proba_sj, \
               m.VCH, \
               m.VCD, \
               m.VCA, \
               1/(m.VCH*1.0) AS home_proba_vc, \
               1/(m.VCD*1.0) AS draw_proba_vc, \
               1/(m.VCA*1.0) AS away_proba_vc, \
               1/(m.VCH*1.0)+1/(m.VCD*1.0)+1/(m.VCA*1.0) AS sum_proba_vc, \
               m.GBH, \
               m.GBD, \
               m.GBA, \
               1/(m.GBH*1.0) AS home_proba_gb, \
               1/(m.GBD*1.0) AS draw_proba_gb, \
               1/(m.GBA*1.0) AS away_proba_gb, \
               1/(m.GBH*1.0)+1/(m.GBD*1.0)+1/(m.GBA*1.0) AS sum_proba_gb, \
               m.BSH, \
               m.BSD, \
               m.BSA, \
               1/(m.BSH*1.0) AS home_proba_bs, \
               1/(m.BSD*1.0) AS draw_proba_bs, \
               1/(m.BSA*1.0) AS away_proba_bs, \
               1/(m.BSH*1.0)+1/(m.BSD*1.0)+1/(m.BSA*1.0) AS sum_proba_bs, \
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
