install.packages("devtools")
devtools::install_github("twitter/BreakoutDetection")
library(BreakoutDetection)

help(breakout)
help(data)
data(Scribe)

dt <- read.csv(file.choose(), encoding="UTF-8")
res = breakout(as.vector(t(dt)), min.size=2, method='amoc', beta=.008, degree=1, plot=TRUE)
res$plot
