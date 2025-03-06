getwd()
# setwd();
rm(list = ls())

x <- c(0.3, 0.6)
x <- c(TRUE, FALSE)
x <- c(T, F)
x <- c("M", "F")
x <- 1:4

rep(1:4, 2) # times = 2
rep(1:4, each = 2)
rep(1:4, c(1, 2, 3, 4)) # times = (1, 2, 3, 4)
rep(1:4, times = 2, len = 10)
rep(1:4, times = 2, each = 2)
rep("hello", times = 3)

seq(0, 1, length.out = 11)
seq(1, 9, by = 2)
seq(17)

matrix(1:6, nrow = 2, ncol = 3)
matrix(1:6, nrow = 2, ncol = 3, byrow = TRUE)

x <- c(1, 2, 3)
y <- c(4, 5, 6)
cbind(x, y)
rbind(x, y)

x <- list(member = 3, names = c("Tom", "Jerry", "Lily"))
x
names(x) # x 列表元素的别名
x$member # 取 x 列表的 member
length(x) # 取列表长

# 示例：性别数据
gender <- c("男", "女", "男", "女", "男")
gender_factor <- factor(gender)
gender_factor

levels(gender_factor) <- c("male", "female")

gender_factor

x <- 1:6
as.logical(x)
as.character(x)

x <- c("a", "b", "c")
as.logical(x)
as.numeric(x)

x <- c(4, -1, NA)
is.na(x)
is.nan(x)

sqrt(x)

Inf + (-Inf) # NaN

t <- read.table(
    file = "./grade.txt", # 文件路径
    header = TRUE, # 第一行为列名
    sep = " ", # 按照空格分割
    comment.char = "%", # % 为注释
    skip = 1, # 跳过一行
    nrows = 8, # 跳过一行后读 8 行
    row.names = 2 # 第 2 列设为行名
)
t

scan("example.txt", what = list("", numeric(), numeric()))
scan("example.txt", what = list("gender" = "", "weight" = numeric(), "height" = numeric()))

scan("example2.txt")

t <- read.fwf(
    file = "example3.txt",
    widths = c(1, 2, 3),
    col.names = c("gender", "weight", "height"),
) # 指定每一列宽度分别为 1, 2, 3
t

install.packages("readxl")
library("readxl")
t <- read_excel("example.xlsx")



con <- url("https://www.baidu.com/")
x <- readLines(con)
head(x)

# 创建数据框 d
d <- data.frame(obs = c(1, 2, 3), treat = c("A", "B", "A"), weight = c(2.3, NA, 9))

# 保存为简单文本 txt
write.table(d, file = "./lec02/foo.txt", row.names = FALSE)
# 保存为 , 分割文本
write.csv(d, file = "./lec02/foo.csv", row.names = FALSE)
# 保存为 .RData 格式文件
save(d, file = "./lec02/foo.RData")
