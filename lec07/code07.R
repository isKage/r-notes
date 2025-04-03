getwd()
setwd("./lec07")
rm(list = ls())
ls()

## mean and median
finalgrades <- read.csv("finalgrades.csv")
head(finalgrades)
mydata <- finalgrades[, c(6:9)]

png("img/grades.png", width = 1600, height = 1200, res = 300)
op <- par(mfrow = c(2, 2))
apply(mydata, 2, hist)
par(op)
dev.off()

grade.median <- apply(mydata, 2, median)
grade.median

grade.mean <- apply(mydata, 2, mean)
grade.mean

grade.mean > grade.median


## skewness and kurtosis
library("moments")
grade.skewness <- apply(mydata, 2, skewness)
grade.kurtosis <- apply(mydata, 2, kurtosis)

grade.skewness
grade.kurtosis

kurtosis(rnorm(10000))

grade.kurtosis <- apply(mydata, 2, kurtosis) - 3
grade.kurtosis

## qq plot
png("img/qq.png", width = 1600, height = 1200, res = 300)
x <- mydata[, 1]
qqnorm(x, main = "Q-Q Plot")
qqline(x)
dev.off()

fivenum(x) # 5 个分位数 min, q1, median, q3, max
summary(x) # 5 个分位数 + mean
quantile(x) # 5 个分位数 0%  25%  50%  75% 100%

# aggregate
mydata <- read.csv("jobinfor201xE.csv", encoding = "utf-8")
head(mydata)
str(mydata)

aggregate(cbind(minimumpay, maximumpay, logmeanpay) ~ city + R, FUN = mean, na.rm = T, data = mydata)
