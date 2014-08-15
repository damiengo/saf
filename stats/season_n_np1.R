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
  file_name <- "n_np1_score/losts_teams_cor_from_1993.csv"
  if (file.exists(file_name)) file.remove(file_name)
  team_list <- unique(data$name)
  for(team in team_list) {
    print("=======================")
    team_seasons <- subset(data, name == team & season_n > 1993)
    team_cor <- cor(team_seasons$an_lose,team_seasons$np1_lose)
    print(team)
    print(team_cor)
    write.table(list(team, team_cor), file = file_name, col.names=FALSE, sep=",", append=TRUE)
    print("=======================")
  }
  
  return(team_list)
}

list <- top_teams(season)

