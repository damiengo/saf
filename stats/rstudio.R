# Home avg
plot(season_avg$start, season_avg$homeavg)
lines(season_avg$start, season_avg$homeavg, type="l", col="blue")
# Away avg
plot(season_avg$start, season_avg$awayavg)
lines(season_avg$start, season_avg$awayavg, type="l", col="blue")
# Draw avg
plot(season_avg$start, season_avg$drawavg)
lines(season_avg$start, season_avg$drawavg, type="l", col="blue")