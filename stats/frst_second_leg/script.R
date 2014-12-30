results = read.csv("first_second_leg.csv", sep=";", encoding="UTF-8")

# Goals diff
first_results = results$first_t1 - results$first_t2
second_results = results$second_t1 - results$second_t2
cor(first_results, second_results)
goals_diff = lm(first_results ~ second_results)
summary(goals_diff)
plot(jitter(first_results) ~ jitter(second_results))
abline(goals_diff)

# Rank diff/points
rank_diff   = results$t1_rank - results$t2_rank
points_diff = (results$result_first_t1+results$result_second_t1) - (results$result_first_t2+results$result_second_t2)
rank_point_diff = lm(points_diff ~ rank_diff)
summary(rank_point_diff)
plot(points_diff ~ rank_diff)
abline(rank_point_diff)
