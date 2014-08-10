# Open file
season <- read.csv(file.choose())
# Plots
plot(season$n_win, season$np1_win)
plot(season$n_draw, season$np1_draw)
plot(season$an_lose, season$np1_lose)
