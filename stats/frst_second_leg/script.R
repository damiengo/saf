results = read.csv("first_second_leg.csv", sep=";", encoding="UTF-8")

# Goals diff
first_results = results$first_t1 - results$first_t2
second_results = results$second_t1 - results$second_t2
cor(first_results, second_results)
goals_diff = lm(first_results ~ second_results)
summary(goals_diff)
plot(jitter(first_results) ~ jitter(second_results))
abline(goals_diff)

# Points diff all
first_points = c(results$result_first_t1, results$result_first_t2)
second_points = c(results$result_second_t1, results$result_second_t2)
cor(second_points, first_points)
points_diff = lm(second_points ~ first_points)
summary(points_diff)
plot(jitter(second_points) ~ jitter(first_points))
abline(points_diff)

# Points diff home first
first_points = results$result_first_t1
second_points = results$result_second_t1
cor(second_points, first_points)
points_diff = lm(second_points ~ first_points)
summary(points_diff)
plot(jitter(second_points) ~ jitter(first_points))
abline(points_diff)

ls.str(results)

# Points diff away first
first_points = results$result_first_t2
second_points = results$result_second_t2
cor(second_points, first_points)
points_diff = lm(second_points ~ first_points)
summary(points_diff)
plot(jitter(second_points) ~ jitter(first_points))
abline(points_diff)

summary(results$result_first_t2)

# Rank diff/points
rank_diff   = results$t1_rank - results$t2_rank
points_diff = results$result_second_t1 - results$result_second_t2
rank_point_diff = lm(points_diff ~ rank_diff)
summary(rank_point_diff)
plot(jitter(points_diff) ~ jitter(rank_diff))
abline(rank_point_diff)

# Second leg points / multiple regression
dataset = results
#dataset = subset(results, subset=(results$t1_rank = 20 & results$t2_rank = 1))

second_leg_points = c(dataset$result_second_t1, dataset$result_second_t2)
first_leg_points = c(dataset$result_first_t1, dataset$result_first_t2)
first_leg_goals_for = c(dataset$first_t1, dataset$first_t2)
first_leg_goals_against = c(dataset$first_t2, dataset$first_t1)
second_leg_goals_for = c(dataset$second_t1, dataset$second_t2)
second_leg_goals_against = c(dataset$second_t2, dataset$second_t1)

reg_mul_points = lm(second_leg_points ~ first_leg_points + 
                                 first_leg_goals_for + 
                                 first_leg_goals_against)

summary(reg_mul_points)

reg_mul_goals = lm(second_leg_goals_for ~ first_leg_points + 
                      first_leg_goals_for + 
                      first_leg_goals_against)

summary(reg_mul_goals)

reg_mul_goals_ag = lm(second_leg_goals_against ~ first_leg_points + 
                     first_leg_goals_for + 
                     first_leg_goals_against)

summary(reg_mul_goals_ag)

plot(jitter(second_leg_points), jitter(first_leg_points))

# ---- Points percentage
# Home 0 points
first0 = subset(results, subset=(results$result_first_t1 == 0))
mean_first0_second_points = mean(first0$result_second_t1)
mean_first0_second_points
mean_first0_second_goals = mean(first0$second_t1)
mean_first0_second_goals

first0_nrow = nrow(first0)
table(first0$result_second_t1) / first0_nrow

# Home 1 points
first1 = subset(results, subset=(results$result_first_t1 == 1))
mean_first1_second_points = mean(first1$result_second_t1)
mean_first1_second_points
mean_first1_second_goals = mean(first1$second_t1)
mean_first1_second_goals

first1_nrow = nrow(first1)
table(first1$result_second_t1) / first1_nrow

# Home 3 points
first3 = subset(results, subset=(results$result_first_t1 == 3))
mean_first3_second_points = mean(first3$result_second_t1)
mean_first3_second_points
mean_first3_second_goals = mean(first3$second_t1)
mean_first3_second_goals

first3_nrow = nrow(first3)
table(first3$result_second_t1) / first3_nrow

# Home nb point dom
first_nrow = nrow(results)
table(results$result_first_t1) / first_nrow

# Away nb point dom
first_nrow = nrow(results)
table(results$result_first_t2) / first_nrow

# Away 0 points
first_away_0 = subset(results, subset=(results$result_first_t2 == 0))
mean_first_away_0_second_points = mean(first_away_0$result_second_t2)
mean_first_away_0_second_points
mean_first_away_0_second_goals = mean(first_away_0$second_t2)
mean_first_away_0_second_goals

first_away_0_nrow = nrow(first_away_0)
table(first_away_0$result_second_t2) / first_away_0_nrow

# Away 1 points
first_away_1 = subset(results, subset=(results$result_first_t2 == 1))
mean_first_away_1_second_points = mean(first_away_1$result_second_t2)
mean_first_away_1_second_points
mean_first_away_1_second_goals = mean(first_away_1$second_t2)
mean_first_away_1_second_goals

first_away_1_nrow = nrow(first_away_1)
table(first_away_1$result_second_t2) / first_away_1_nrow

# Away 3 points
first_away_3 = subset(results, subset=(results$result_first_t2 == 3))
mean_first_away_3_second_points = mean(first_away_3$result_second_t2)
mean_first_away_3_second_points
mean_first_away_3_second_goals = mean(first_away_3$second_t2)
mean_first_away_3_second_goals

first_away_3_nrow = nrow(first_away_3)
table(first_away_3$result_second_t2) / first_away_3_nrow

plot(jitter(first_leg_goals_for), jitter(second_leg_goals_for))
plot(jitter(first_leg_goals_against), jitter(second_leg_goals_against))

require(plyr)

# Second leg real
second_leg_t1 = aggregate(results$result_second_t1, list(season=results$start, team=results$home), sum)
second_leg_t2 = aggregate(results$result_second_t2, list(season=results$start, team=results$away), sum)

second_leg_tot = ddply(rbind(second_leg_t1, second_leg_t2), .(season, team), summarize, points = sum(x))
second_leg_tot

# Second leg Projection
second_leg_projections_t1 = aggregate(results$result_projection_second_t1, list(season=results$start, team=results$home), sum)
second_leg_projections_t2 = aggregate(results$result_projection_second_t2, list(season=results$start, team=results$away), sum)

second_leg_projections_tot = ddply(rbind(second_leg_projections_t1, second_leg_projections_t2), .(season, team), summarize, points = sum(x))
second_leg_projections_tot

# Second leg regression
second_leg_reg = lm(second_leg_projections_tot$points ~ second_leg_tot$points)
summary(second_leg_reg)

plot(second_leg_projections_tot$points, second_leg_tot$points)
abline(second_leg_reg)
