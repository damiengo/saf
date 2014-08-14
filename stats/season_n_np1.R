# Open file
season <- read.csv(file.choose(), encoding="UTF-8")
# Plots
plot(season$n_win, season$np1_win)
wins <- lm(season$n_win ~ season$np1_win)
abline(wins)
# Correlation
cor(season$n_win, season$np1_win)
# Determination
summary(wins)$r.squared

plot(season$n_draw, season$np1_draw)
draws <- lm(season$n_draw ~ season$np1_draw)
abline(draws)
# Correlation
cor(season$n_draw, season$np1_draw)
# Determination
summary(draws)$r.squared

plot(season$an_lose, season$np1_lose)
losts <- lm(season$an_lose ~ season$np1_lose)
abline(losts)
# Correlation
cor(season$an_lose, season$np1_lose)
# Determination
summary(losts)$r.squared

# Function
top_teams <- function(data) {
  team_list <- unique(data$name)
  for(team in team_list) {
    print("=======================")
    team_seasons <- subset(data, name == team)
    team_cor <- cor(team_seasons$n_win,team_seasons$np1_win)
    print(team)
    print(team_cor)
    team_wins <- lm(team_seasons$n_win ~ team_seasons$np1_win)
    print("=======================")
  }
  
  return(team_list)
}

list <- top_teams(season)

