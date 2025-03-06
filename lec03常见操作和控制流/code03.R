# %%
age <- c(1, 2, 3, 4, 5, 6, 7, 8, 9)

age[1]
age[c(1, 2, 3)]
age[-1]
age[-c(1, 2, 3)]

# %%
age <- c(1, 2, 3, 4, 5, 6, 7, 8, 9)
weight <- c(1.1, 2.2, 3.3, 4.4, 5.5, 6.6, 7.7, 8.8, 9.9)
age > 4
weight[age > 4]

# %%
age <- c(1, 2, NA, 4)
weight <- c(NA, 2.2, 3.3, 4.4)
is.na(age)
is.na(weight)
index <- !is.na(age) & !is.na(weight)
age[index]
weight[index]

# %%
x <- matrix(1:9, 3, 3, byrow = TRUE)
x
x[8]
x[1, 2]
x[, 1]
x[1, ]
x[1, 1:2]
x[1, c(1, 3)]

# %% 练习：给出矩阵 mydata 中 age 大于 6 的 weight
age <- c(1, 3, 5, 2, 11, 9, 3, 9, 12, 3)
weight <- c(4.4, 5.3, 7.2, 5.2, 8.5, 7.3, 6.0, 10.4, 10.2, 6.1)
mydata <- cbind(age, weight)
mydata

mydata[age > 6, 2]

# %% 数据框
df <- data.frame(age = c(1, 2, 3), weight = c(1.1, 2.2, 3.3))
df

df$age
df$weight

attach(df)
age
weight
detach(df)

# %% 列表
x <- list(member = 3, name = c("Tom", "Jerry", "John"))
x

x$member
x$name

attach(x)
member
name
detach(x)

x[1] # 仍然是 list
x[[2]] # 得到向量
x[["name"]] # 等价于 x[[1]]

# %% 数值向量
x <- 1:4
y <- 6:9
x * y
x / y
x > 2
x + y

1:2 + 1:4
1:3 + 1:5

# %%
x <- c(1, 2, 3, 4)
max(x) # 求最大值
min(x) # 求最小值
range(x) # 求范围，即返回 (max, min)
sum(x) # 求和
diff(x) # 求差分
prod(x) # 求累积
mean(x) # 求平均值
abs(x) # 求绝对值，逐元素计算
sqrt(x) # 求平方根，逐元素计算

# %% 数值型矩阵
x <- matrix(1:4, 2, 2)
y <- matrix(rep(10, 4), 2, 2)
x
y

dist(x)
rowSums(x)
colMeans(x)
x %*% y

solve(x)

# %% apply
z <- matrix(1:4, 2, 2)
z

apply(z, 1, sum)
apply(z, 2, mean)

# %% 逻辑型
x <- c(TRUE, FALSE, TRUE, FALSE)
any(x)
all(x)
which(x)

# %% 字符型
paste("hello", "the", "world", "!") # 默认 sep 空格隔开
paste("file", "100", ".csv", sep = "") # 指定 sep 为空字符
paste("file", "100", ".csv", sep = " ")

paste(1:3, rep("th", 3), sep = "")
paste(1:3, rep("th", 3), sep = "-", collapse = ",")

paste(1:3, "th", sep = "")

x <- "hello the world"
y <- strsplit(x, split = " ")
strsplit(x, split = "")
y[[1]][1]

x <- "1234"
substr(x, 2, 3)

x <- c("123", "456", "789")
substr(x, 2, 2)

# %% if-else
x <- 3
if (x > 5) {
    print("x 大于 5")
} else {
    print("x 小于或等于 5")
}

score <- c(40, 50, 60, 70, 80, 90)
result <- ifelse(score >= 60, "Pass", "Fail")
result

# %% for
for (i in 1:10) {
    if (i %% 2 == 0) {
        string <- paste("i=", i)
        print(string)
    }
}

# %% while
i <- 0
while (i < 10) {
    print(i)
    i <- i + 1
}

# %% repeat
x <- 1
repeat {
    print(x)
    x <- x + 1
    if (x > 5) {
        break
    }
}
