# Open file
season <- read.csv(file.choose(), encoding="UTF-8")
season <- subset(season, start > 1993)
# Plots
plot(season$home_avg, season$away_avg)
lmed <- lm(season$home_avg ~ season$away_avg)
abline(lmed)
# Correlation
cor(season$home_avg, season$away_avg)
# Determination
summary(lmed)

season_agg <- aggregate(season, by = list(season$start), mean)

# Chart
plot(season_agg$start, season_agg$home_avg, type="n", xlab="Saisons", ylab="Moyenne")
points(season_agg$start, season_agg$home_avg, col = "blue")
points(season_agg$start, season_agg$away_avg, col = "red")
