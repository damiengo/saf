# Open file
season_avg <- read.csv(file.choose())
# Home avg
plot(season_avg$start, season_avg$homeavg)
lines(season_avg$start, season_avg$homeavg, type="l", col="blue")
# Away avg
plot(season_avg$start, season_avg$awayavg)
lines(season_avg$start, season_avg$awayavg, type="l", col="blue")
# Draw avg
plot(season_avg$start, season_avg$drawavg)
lines(season_avg$start, season_avg$drawavg, type="l", col="blue")
# Open goal avg file
goals_avg <- read.csv(file.choose())
# Goal diff avg
plot(goals_avg$start, goals_avg$diff_avg)
lines(goals_avg$start, goals_avg$diff_avg, type="l", col="blue")
