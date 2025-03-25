getwd()
setwd("./lec06")
rm(list = ls())

# 示例：性别频数表
gender <- c("男", "女", "男", "男", "女")
freq_table <- table(gender)
print(freq_table)

prop_table <- prop.table(freq_table) * 100
print(prop_table)

barplot(freq_table,
    main = "gender bar plot",
    xlab = "gender",
    ylab = "freq",
    col = c("skyblue", "pink"),
    horiz = TRUE
)

# 示例数据
data <- matrix(c(20, 30, 25, 35, 15, 40), nrow = 2, byrow = TRUE)
rownames(data) <- c("Male", "Female")
colnames(data) <- c("A", "B", "C")

# 绘制堆叠条形图
barplot(data,
    main = "Gender Distribution by Category",
    beside = TRUE,
    xlab = "Category",
    ylab = "Frequency",
    col = c("skyblue", "pink"),
    legend.text = rownames(data), # 添加图例
    args.legend = list(x = "topright") # 图例位置
)


library(ggplot2)
ggplot(data.frame(gender), aes(x = gender)) +
    geom_bar(fill = c("skyblue", "pink")) +
    labs(title = "gender bar plot", x = "gender", y = "freq")

# 示例：性别与血型列联表
blood_type <- c("A", "B", "O", "A", "B")
cross_table <- table(gender, blood_type)
print(cross_table)

addmargins(cross_table)

prop.table(cross_table, margin = 1) # 按行计算比例

pie(freq_table,
    labels = paste0(round(prop_table), "%"), # 每一块别名
    main = "Pie of gender", # 表头
    col = c("skyblue", "pink") # 颜色
)

gender <- c("Male", "Female", "Male", "Male", "Female")
freq_table <- table(gender)
pie(freq_table,
    labels = names(freq_table), # 每一块扇形标签 字符型向量
    main = "Pie of gender", # 表头
    col = c("skyblue", "pink") # 颜色
)

gender <- c("Male", "Female", "Male", "Male", "Female")
freq_table <- table(gender)
pie(freq_table,
    labels = names(freq_table), # 每一块扇形标签 字符型向量
    main = "Pie of gender", # 表头
    col = c("skyblue", "pink") # 颜色
)
prop_table <- prop.table(freq_table) * 100
gender <- c("Male", "Female", "Male", "Male", "Female")
freq_table <- table(gender)
pie(freq_table,
    labels = paste(prop_table, "%", sep = ""), # 每一块扇形标签 字符型向量
    main = "Pie of gender", # 表头
    col = c("skyblue", "pink") # 颜色
)

ggplot(data.frame(gender), aes(x = "", fill = gender)) +
    geom_bar(width = 1) +
    coord_polar(theta = "y") +
    labs(title = "Pie of gender") +
    theme_void()

##
?hist
data <- rnorm(1000, mean = 0, sd = 1)
hist(data,
    breaks = 20, # 分箱数
    main = "Histogram",
    xlab = "values",
    col = "skyblue",
    freq = FALSE
)

xfit <- seq(min(data), max(data), length = 40)
yfit <- dnorm(xfit, mean = mean(data), sd = sd(data))
lines(xfit, yfit, col = "blue", lwd = 2)

##
?boxplot

# 单组箱线图
data <- rnorm(100)
boxplot(data, main = "Boxplot of Normal Data", col = "skyblue")

# 并排箱线图
group1 <- rnorm(100, mean = 0)
group2 <- rnorm(100, mean = 2)
boxplot(
    group1,
    group2,
    names = c("Group 1", "Group 2"),
    main = "Side-by-Side Boxplot",
    col = c("skyblue", "pink")
)

# 带缺口的箱线图
group1 <- rnorm(100, mean = 0)
group2 <- rnorm(100, mean = 2)
boxplot(
    group1,
    group2,
    notch = TRUE,
    names = c("Group 1", "Group 2"),
    main = "Notched Boxplot",
    col = c("skyblue", "pink")
)

# 使用内置数据集 mtcars
boxplot(mpg ~ cyl, # mpg 按照 cyl 分组画出 boxplot
    data = mtcars, # mpg, cyl 都是数据框 mtcars 的列
    main = "MPG by Cylinder",
    xlab = "Number of Cylinders",
    ylab = "Miles per Gallon",
    col = c("skyblue", "pink", "lightgreen")
)


plot(women$height, women$weight)


pch_type <- 1:25
X <- 1:25
Y <- rep(6, 25)
plot(X, Y, col = 1, pch = pch_type, cex = 2, main = "pch:1-25", font.lab = 2, horiz = TRUE)
text(X, Y - 0.5, adj = 0.5, labels = paste(pch_type))

pch_type <- c("*", "a", "A", "?", "1")
X <- 1:5
Y <- rep(6, 5)
plot(X, Y, col = 1, pch = pch_type, cex = 2, main = "pch:*aA?1", font.lab = 2)


# 设置绘图面板为 2 行 2 列
par(mfrow = c(2, 2))

# 定义数据
X <- 1:10
Y <- 1:10

# 绘制默认点图
plot(X, Y, main = "Default")

# 绘制蓝色点图
plot(X, Y, main = "Blue Point", col = "blue")

# 绘制红色点图
plot(X, Y, main = "Red Point", col = "red")

# 绘制绿色点图
plot(X, Y, main = "Green Point", col = "green")
