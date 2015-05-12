results = read.csv("tsr.csv", sep=";", encoding="UTF-8")

# TSR on points
lm_tsr_points = lm(results$points_for ~ results$tsr_for)
summary(lm_tsr_points)
plot(results$tsr_for, results$points_for)
abline(lm_tsr_points)

# TSR on goals
lm_tsr_goals = lm(results$goals_for ~ results$tsr_for)
summary(lm_tsr_goals)
plot(results$tsr_for, results$goals_for)
abline(lm_tsr_goals)
