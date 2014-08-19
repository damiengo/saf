# Open file
season <- read.csv(file.choose(), encoding="UTF-8")
season <- subset(season, season_n > 1993)
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
  file_name <- "n_np1_score/wins_teams_cor_from_1993.csv"
  if (file.exists(file_name)) file.remove(file_name)
  team_list <- unique(data$name)
  for(team in team_list) {
    print("=======================")
    team_seasons <- subset(data, name == team & season_n > 1993)
    team_cor <- cor(team_seasons$n_win,team_seasons$np1_win)
    team_lm  <- summary(lm(team_seasons$n_win ~ team_seasons$np1_win))$r.squared
    print(team)
    print(team_cor)
    print(team_lm)
    write.table(list(team, team_cor,team_lm), file = file_name, col.names=FALSE, sep=",", append=TRUE)
    print("=======================")
  }
  
  return(team_list)
}

list <- top_teams(season)