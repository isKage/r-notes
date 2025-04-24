getwd()
setwd("lec10")
rm(list = ls())
ls()

# 多元线性回归
Y <- c(101.8, 44.4, 108.3, 85.1, 77.1, 158.7, 180.4, 64.2, 74.6, 143.4, 120.6, 69.7, 67.8, 106.7, 119.6) # nolint
X1 <- c(1.3, 0.7, 1.4, 0.5, 0.5, 1.9, 1.2, 0.4, 0.6, 1.3, 1.6, 1.0, 0.8, 0.6, 1.1) # nolint
X2 <- c(0.2, 0.2, 0.3, 0.4, 0.6, 0.4, 1.0, 0.4, 0.5, 0.6, 0.8, 0.3, 0.2, 0.5, 0.3) # nolint
X3 <- c(20.4, 30.5, 24.6, 19.6, 25.5, 21.7, 6.8, 12.6, 31.3, 18.6, 19.9, 25.6, 27.4, 24.3, 13.7) # nolint
CountryKitchen <- data.frame(Sales = Y, Advertisement = X1, Promotion = X2, Competitor = X3) # nolint

# 数据的相关性
cor(CountryKitchen)
png("img/cor_plot.png", width = 1200, height = 1200, res = 200)
plot(CountryKitchen) # 绘图
dev.off()

# 回归分析
## method 1
result1 <- lm(Y ~ X1 + X2 + X3)
summary(result1)

## method 2
X <- cbind(X1, X2, X3)
result2 <- lm(Y ~ X)
summary(result2)

## method 3
result3 <- lm(Sales ~ Advertisement + Promotion + Competitor, data = CountryKitchen) # nolint
summary(result3)

## method 4
result4 <- lm(Sales ~ ., data = CountryKitchen)
summary(result4)

# R^2 and Adj R^2
CountryKitchen$Snow <- c(24, 31, 31, 36, 18, 42, 50, 49, 60, 62, 42, 58, 55, 79, 88) # nolint
png("img/cor_pairs.png", width = 1200, height = 1200, res = 200)
pairs(CountryKitchen) # 绘图
dev.off()
cor(CountryKitchen)

result5 <- lm(Sales ~ ., data = CountryKitchen)
summary(result5)

# 多重共线性
salary <- c(
    100000, 100000, 77500, 77500, 75000,
    87500, 77500, 87500, 77500, 90000,
    95000, 65000, 72500, 82500, 100000,
    97500, 68500, 85000, 88500, 100000,
    77500, 92500, 92500, 97500, 95000
)
GPA <- c(
    3.9, 3.9, 3.1, 3.2, 3.0,
    3.5, 3.0, 3.5, 3.2, 3.6,
    3.7, 2.9, 3.4, 3.4, 4.0,
    3.8, 2.8, 3.5, 3.6, 3.9,
    3.1, 3.7, 3.7, 4.0, 3.8
)
GMAT <- c(
    640, 644, 557, 550, 547,
    589, 533, 600, 630, 633,
    642, 522, 628, 583, 650,
    641, 530, 596, 605, 656,
    574, 636, 635, 654, 633
)

result6 <- lm(salary ~ GPA + GMAT)
summary(result6)

cor(GPA, GMAT)

result7 <- lm(salary ~ GPA)
summary(result7)

X <- cbind(GPA, GMAT)
kappa(t(X) %*% X)

# 模型选择
cement <- data.frame(
    X1 = c(
        7, 1, 11, 11, 7, 11, 3, 1,
        2, 21, 1, 11, 10
    ),
    X2 = c(
        26, 29, 56, 31, 52, 55, 71,
        31, 54, 47, 40, 66, 68
    ),
    X3 = c(
        6, 15, 8, 8, 6, 9, 17, 22,
        18, 4, 23, 9, 8
    ),
    X4 = c(
        60, 52, 20, 47, 33, 22, 6,
        44, 22, 26, 34, 12, 12
    ),
    Y = c(
        78.5, 74.3, 104.3, 87.6,
        95.9, 109.2, 102.7, 72.5,
        93.1, 115.9, 83.8, 113.3,
        109.4
    )
)

result8 <- lm(Y ~ X1 + X2 + X3 + X4, data = cement)
summary(result8)

X.cement <- as.matrix(cement[, 1:4])
kappa(t(X.cement) %*% X.cement)

cor(X.cement)

result9 <- lm(Y ~ X1 + X2 + X4, data = cement)
summary(result9)

result10 <- lm(Y ~ X1 + X2, data = cement)
summary(result10)

# step
result8 <- lm(Y ~ X1 + X2 + X3 + X4, data = cement)
lm.step <- step(result8, direction = "back") # 向后选择
summary(lm.step)

step(result8, direction = "back")

drop1(lm.step)

# 预测
newdata <- data.frame(
    Advertisement = c(1.2, 1, 1.4),
    Promotion = c(0.5, 0.6, 0.7),
    Competitor = c(25, 10, 8)
)
predict(result3, new = newdata)
predict(result3, new = newdata, interval = "prediction")

# 诊断
png("img/ei.png", width = 1200, height = 1200, res = 200)
op <- par(mfrow = c(2, 2))
plot(result3, 1:4)
dev.off()
par(op)
