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
dataset = subset(results, subset=(results$t1_rank = 20 & results$t2_rank = 1))

second_leg_points = c(dataset$result_second_t1, dataset$result_second_t2)
first_leg_points = c(dataset$result_first_t1, dataset$result_first_t2)
first_leg_goals_for = c(dataset$first_t1, dataset$first_t2)
first_leg_goals_against = c(dataset$first_t2, dataset$first_t1)
second_leg_goals_for = c(dataset$second_t1, dataset$second_t2)
second_leg_goals_against = c(dataset$second_t2, dataset$second_t1)

reg_mul = lm(second_leg_points ~ first_leg_points + 
                                 first_leg_goals_for + 
                                 first_leg_goals_against + 
                                 second_leg_goals_for + 
                                 second_leg_goals_against)

summary(reg_mul)
help(summary.lm)
