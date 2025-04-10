getwd()
rm(list = ls())
setwd("./lec08")
ls()

# CI
takeCI <- function(x, beta = 0.95) {
    n <- length(x)
    alpha <- 1 - beta

    c <- qt(p = alpha / 2, lower.tail = FALSE, df = n - 1)

    xbar <- mean(x)
    l <- c * sd(x) / sqrt(n)

    left <- xbar - l
    right <- xbar + l

    res <- c(left = left, right = right)
    return(res)
}
# 模拟 1 次
x <- rnorm(n = 20, mean = 0, sd = 1)
takeCI(x)

# 模拟 N 次
auc <- 0
N <- 1000
sample_size <- 20

for (i in 1:N) {
    x <- rnorm(n = sample_size, mean = 0, sd = 1)
    ci <- takeCI(x)
    if (ci[1] < 0 && ci[2] > 0) {
        auc <- auc + 1
    }
}
coverage_rate <- auc / N
coverage_rate


# 单侧 t 检验
alpha <- 0.05
n <- 100
N <- 1000
t_list <- NULL

for (i in 1:N) {
    y <- rnorm(n, 0, 1)
    t <- (mean(y) - 0) / (sd(y) / sqrt(n)) # t 检验量
    t_list <- c(t_list, t) # t 检验量加入 t_list
}
c <- qt(alpha, lower.tail = FALSE, df = n - 1)
sum(t_list <= c) / N # N 个样本拒绝的次数 / 总模拟次数
# 0.948

# 控制第 I 类错误：H0 对但拒绝
alpha <- 0.05
n <- 100
N <- 1000
p_t_list <- NULL

for (i in 1:N) {
    y <- rnorm(n, 0, 1)
    t <- (mean(y) - 0) / (sd(y) / sqrt(n)) # t 检验量
    p_t <- pt(t, df = n - 1) # P(X < t) = p_t, X ~ t(n-1)
    p_t_list <- c(p_t_list, p_t) # t 检验量分位数对应的 t(n-1) 分布概率加入 t_list
}
sum(p_t_list <= alpha) / N # 犯第 I 类错误

# 检验正态总体
X <- c(159, 280, 101, 212, 224, 379, 179, 264, 222, 362, 168, 250, 149, 260, 485, 170)
t.test(X, alternative = "greater", mu = 225)

df <- read.csv("./Score.csv")
head(df)
t.test(score ~ Gender, data = df)

# 模型检验
x <- df$score[df$Gender == "Female"]
y <- df$score[df$Gender == "Male"]
png("./img/qq_score.png", width = 2400, height = 1200, res = 200)
op <- par(mfrow = c(1, 2))
qqnorm(x, main = "Female")
qqline(x)
qqnorm(y, main = "Male")
qqline(y)
dev.off()
par(op)

boxplot(score ~ Gender, data = df)

var.test(score ~ Gender, data = df)

t.test(score ~ Gender, data = df, var.equal = FALSE)

# 正态性检验
x <- rnorm(n = 100, mean = 0, sd = 1)
shapiro.test(x)

# 相关系数
X <- c(7.7, 8.2, 7.8, 6.9, 8.4, 8.1, 7.1, 7.5, 7.6, 7.6, 7.9, 7.6, 7.5, 7.6, 7.6)
Y <- c(7.2, 6.7, 5.7, 4.0, 5.7, 6.4, 4.5, 5.5, NA, 5.4, 6.1, 6.9, 3.9, 5.7, 3.7)

cor(X, Y, use = "na.or.complete", method = "pearson")

cor.test(X, Y, method = "pearson")
