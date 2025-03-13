rm(list = ls())
getwd()
working_root <- paste(getwd(), "/lec04函数与简单模拟", sep = "")
setwd(working_root)
getwd()

# %%
my.data.ana <- function(x) {
    y <- list(mean = mean(x), max = max(x), min = min(x))
    return(y)
}

x <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
y <- my.data.ana(x)
y

# %% norm
x <- rnorm(10, mean = 0, sd = 1) # 返回 10 个服从标准正态分布 N(0, 1) 随机数
x

pnorm(2) - pnorm(-2) # P(-2 < X < 2)

# %% 查看帮助文档
?rnorm
?rpois
?rgamma
?rbinom

# %%
?sample
sample(5, 3) # 等价于从 1:5 中无放回抽3个数（如 2,4,1）
sample(c(5), 3) # 从单元素向量 5 中有放回抽3次（需设置 replace=TRUE）

sample(c("A", "B"), size = 5, replace = TRUE, prob = c(3, 1)) # "A"出现概率为 3/(3+1)=75%

sample(1:10, size = 15, replace = TRUE) # 允许（有放回）
# sample(1:10, size = 15, replace = FALSE) # 报错

# %% 随机种子
rnorm(3)
rnorm(3)

set.seed(1)
rnorm(3) # [1]  0.6328626  0.4042683 -0.1061245
rnorm(4) # [1]  1.5952808  0.3295078 -0.8204684  0.4874291
set.seed(1)
rnorm(3) # [1]  0.6328626  0.4042683 -0.1061245
rnorm(4) # [1]  1.5952808  0.3295078 -0.8204684  0.4874291

# %% 模拟证明
# X_n ~ B(n, p) 当 n 充分大时 X_n ~ N(np, sqrt(np(1-p)))
N <- 1000 # 抽样 1000 个
p <- 0.8
n <- 10
x <- rbinom(N, n, p)
length(x)
hist(x)

N <- 100000
x <- rbinom(N, n, p)
length(x)
hist(x)

# %% 数据清洗
manager <- c(1, 2, 3, 4, 5)
date0 <- c("10/24/08", "10/28/08", "10/1/08", "10/12/08", "5/1/09")
nationality <- rep(c("US", "UK"), c(2, 3))
gender <- c("M", "F", "F", "M", "F")
age <- c(32, 45, 25, 39, 99)
q1 <- c(5, 3, 3, 3, 2)
q2 <- c(4, 5, 5, 3, 2)
q3 <- c(5, 2, 5, 4, 1)
q4 <- c(5, 5, 5, NA, 2)
q5 <- c(5, 5, 2, NA, 1)

leadership <- data.frame(manager, date0, nationality, gender, age, q1, q2, q3, q4, q5)
leadership
str(leadership)
leadership0 <- leadership

is.na(leadership)

newdata <- na.omit(leadership)
newdata

mean(leadership$age)

sort(leadership$age)
order(leadership$age)

newdata <- leadership[order(leadership$age), ]
newdata

subset(leadership, subset = age > 30 & gender == "M", select = -2)


leadership <- within(leadership, {
    qsum <- q1 + q2 + q3 + q4 + q5 # 计算总和
    qmean <- qsum / 5 # 计算平均值
})

# %%
df1 <- data.frame(ID = 1:3, Name = c("A", "B", "C"))
df2 <- data.frame(Age = c(20, 25, 30), Score = c(85, 90, 88))
combined_col <- cbind(df1, df2) # 合并后列数为 df1 列数 + df2 列数

df3 <- data.frame(ID = 4:5, Name = c("D", "E"), Age = c(22, 28), Score = c(92, 80))
combined_row <- rbind(combined_col, df3) # 合并后行数为原两数据框行数之和

# %%
orders <- data.frame(OrderID = c(101, 102, 103), CustomerID = c(1, 2, 4))
customers <- data.frame(CustomerID = 1:3, Name = c("A", "B", "C"))

# 内连接（默认）取交集，[1，2，4] 和 [1, 2, 3] 只有 [1, 2] 相交
inner_join <- merge(orders, customers, by = "CustomerID")

# 左外连接，左表的 [1, 2, 4] 都保留，则多出来的无法匹配的留空
left_join <- merge(orders, customers, by = "CustomerID", all.x = TRUE)
