results = read.csv("first_second_leg.csv", sep=";", encoding="UTF-8")

first_results = results$first_t1 - results$first_t2
second_results = results$second_t1 - results$second_t2

goals_diff = lm(first_results ~ second_results)

summary(goals_diff)

plot(jitter(first_results) ~ jitter(second_results))

abline(goals_diff)
