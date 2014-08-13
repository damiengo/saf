# Open file
season <- read.csv(file.choose())
# Plots
plot(season$n_win, season$np1_win)
wins <- lm(season$n_win ~ season$np1_win)
abline(wins)
summary(wins)

plot(season$n_draw, season$np1_draw)
draws <- lm(season$n_draw ~ season$np1_draw)
abline(draws)
summary(draws)

plot(season$an_lose, season$np1_lose)
losts <- lm(season$an_lose ~ season$np1_lose)
abline(losts)
summary(losts)

# Function
topTeams <- function(data) {
  team_list <- unique(data$name)
  return team_list
}

list <- topTeams(season)

