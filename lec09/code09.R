getwd()
setwd("lec09")
rm(list = ls())
ls()

# simple regression
student <- c(2, 6, 8, 8, 12, 16, 20, 20, 22, 26)
sales <- c(58, 105, 88, 118, 117, 137, 157, 169, 149, 202)
result <- lm(sales ~ student)
summary(result)

names(result)

names(summary(result))

result$coefficients


# 残差 ei 分布散点图
png("img/ei.png", width = 1200, height = 500, res = 150)
op <- par(mfrow = c(1, 3))

# 残差 ei 的散点分布
plot(result$residuals, main = "Residuals, ei scatters plot")

# 检查残差 ei 是否与 xi 相关（残差是误差的估计）
plot(student, result$residuals, main = "Students v.s. Residuals, xi vs ei")

# 检查残差 ei 是否近似正态（残差是误差的估计）
qqnorm(result$residuals)
qqline(result$residuals)

dev.off()
par(op)

# 其他
png("img/others.png", width = 1200, height = 1200, res = 200)
op <- par(mfrow = c(2, 2))
plot(result, which = 1:4)
dev.off()
par(op)

# 预测
new <- data.frame(student = 10)
predict(result, new, interval = "prediction", level = 0.95)
new <- data.frame(student = 18)
predict(result, new, interval = "prediction", level = 0.95)

# 估计
new <- data.frame(student = 10)
predict(result, new, interval = "confidence", level = 0.95)
new <- data.frame(student = 18)
predict(result, new, interval = "confidence", level = 0.95)
