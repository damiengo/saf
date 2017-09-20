#!/bin/bash
#
# Run all updates.
#

# Ligue 1
bundle exec rake saf:parse_sqw[24,2017]
bundle exec rake saf:analyse_sqw[0,2017]
# Premier League
bundle exec rake saf:parse_sqw[8,2017]
bundle exec rake saf:analyse_sqw[1,2017]
# Bundesliga
bundle exec rake saf:parse_sqw[22,2017]
bundle exec rake saf:analyse_sqw[3,2017]
# Seria A
bundle exec rake saf:parse_sqw[21,2017]
bundle exec rake saf:analyse_sqw[2,2017]
# Liga
bundle exec rake saf:parse_sqw[23,2017]
bundle exec rake saf:analyse_sqw[4,2017]
# Elo
bundle exec rake saf:update_elo
