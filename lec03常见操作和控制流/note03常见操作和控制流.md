# R 语言初步 (2) 基本运输、常见操作和控制流

本章介绍了 R 语言中常见的运算和操作（例如索引），以及针对不同数据类型的不同操作函数（例如 apply 函数）。同时介绍了 R 语言控制流（if-else 条件执行、for while repeat 循环结构）的实现。

## 1 基本运算和操作

### 1.1 向量的下标运算

```R
age <- c(1, 2, 3, 4, 5, 6, 7, 8, 9)

age[1]
age[c(1, 2, 3)]
age[-1]
age[-c(1, 2, 3)]
```

- `a[i]` 表示取第 `i` 个元素
- `a[c(1, 2, 3)]` 表示取第 `1 , 2, 3` 个元素
- `a[-1]` 表示输出 `a` 删去第 `1` 个元素的结果
- `a[-c(1, 2, 3)]` 表示输出 `a` 删去第 `1, 2, 3` 个元素的结果
- 特别地，索引支持逻辑运算

```R
> weight <- c(1.1, 2.2, 3.3, 4.4, 5.5, 6.6, 7.7, 8.8, 9.9)

> age > 4
[1] FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE

> weight[age > 4]
[1] 5.5 6.6 7.7 8.8 9.9
```

可以配合逻辑运算符

```R
> age <- c(1, 2, NA, 4)
> weight <- c(NA, 2.2, 3.3, 4.4)

> is.na(age)
[1] FALSE FALSE  TRUE FALSE
> is.na(weight)
[1]  TRUE FALSE FALSE FALSE
> index <- !is.na(age) & !is.na(weight)

> age[index]
[1] 2 4
> weight[index]
[1] 2.2 4.4
```

- `is.na()` 检查每个元素是否为空，返回一个向量
- `!` 表示非运算；`&` 表示与运算

### 1.2 矩阵的下标运算

```R
> x <- matrix(1:9, 3, 3, byrow = TRUE)
> x
     [,1] [,2] [,3]
[1,]    1    2    3
[2,]    4    5    6
[3,]    7    8    9
```

```R
> x[8]
[1] 6           	# 按列检索 1, 4, 7, 2, 5, 8, 3, 6, 9 的 第 8 个为 6

> x[1, 2]
[1] 2				# 第 1 行 第 2 列

> x[, 1]
[1] 1 4 7			# 行全取，列取第 1 列

> x[1, ]
[1] 1 2 3			# 列全取，行取第 1 行

> x[1, 1:2]			# 指定读取 第 1 行 第 1 到 2 列 的数据
[1] 1 2

> x[1, c(1, 3)] 	# 指定读取 第 1 行 第 1 和 3 列 的数据
[1] 1 3
```

### 1.3 数据框：列向量的访问

#### 1.3.1 使用 $ 访问列

使用 `$` 访问数据库中的列

```R
# %% 数据框
> df <- data.frame(age = c(1, 2, 3), weight = c(1.1, 2.2, 3.3))
df
> df
  age weight
1   1    1.1
2   2    2.2
3   3    3.3
```

```R
> df$age
[1] 1 2 3

> df$weight
[1] 1.1 2.2 3.3
```

#### 1.3.2 使用 attach 和 detach 函数

也可以使用 `attach(df)` 进入数据框，然后就可以直接使用列名调用数据，使用 `detach(df)` 退出数据框

```R
> attach(df)
The following objects are masked from df (pos = 3):

    age, weight

age
weight
> age
[1] 1 2 3
> weight
[1] 1.1 2.2 3.3
> detach(df)
```

> `attach` 和 `detach` 也使用与 list 类型

### 1.4 列表的索引

```R
> x <- list(member = 3, name=c("Tom", "Jerry", "John"))
> x
$member
[1] 3

$name
[1] "Tom"   "Jerry" "John" 
```

- 使用 `$` 索引

```R
> x$member
[1] 3

x$name
> x$name
[1] "Tom"   "Jerry" "John" 
```

- 可以使用 `attach` 和 `detach`

```R
> attach(x)

> member
[1] 3
> name
[1] "Tom"   "Jerry" "John" 

> detach(x)
```

- 取一次 `[]` 得到的还是列表，需要取 `[[]]` 得到向量

```R
> x[1]
$member
[1] 3        					# 仍然是 list

> x[[2]]  
[1] "Tom"   "Jerry" "John"		# 得到向量

> x[["name"]]
[1] "Tom"   "Jerry" "John"		# 等价于 x[[1]]
```

## 2 常用操作符和函数

### 2.1 数值型向量

#### 2.1.1 逐元素计算

| 算术运算符  | 描述                         |
| ----------- | ---------------------------- |
| `+`         | 加                           |
| `-`         | 减                           |
| `*`         | 乘                           |
| `/`         | 除                           |
| `^` 或 `**` | 幂次                         |
| `x %% y`    | 取余数，等价于 x mod y       |
| `x %/% y`   | 除法求商，例如 `9 %/% 4 = 2` |

- 比较符号返回逻辑运算结果
- 其他运算采用逐元素计算的方式

```R
> x <- 1:4
> y <- 6:9

> x * y
[1]  6 14 24 36

> x / y
[1] 0.1666667 0.2857143 0.3750000 0.4444444

> x > 2
[1] FALSE FALSE  TRUE  TRUE

> x + y
[1]  7  9 11 13
```

> 特别地，R 语言的向量运算中存在**循环法则**

当向量长度不同时，会循环复制短的向量，直到长度相等后再运算：

```R
> 1:2 + 1:4
[1] 2 4 4 6

> 1:3 + 1:5
[1] 2 4 6 5 7
警告信息:
In 1:3 + 1:5 : 长的对象长度不是短的对象长度的整倍数
```

例如：`(1, 2) + (1, 2, 3, 4)` 等价于 `(1, 2, 1, 2) + (1, 2, 3, 4)` 

例如：`(1, 2, 3) + (1, 2, 3, 4, 5)` 等价于 `(1, 2, 3, 1, 2) + (1, 2, 3, 4, 5)`

#### 2.1.2 一些常见的函数

例如：`sin, cos, tan, asin, acos, atan, atan2, 10g, 10g10, exp`

```R
> x <- c(1, 2, 3, 4)

> max(x) 				# 求最大值
[1] 4

> min(x) 				# 求最小值
[1] 1

> range(x)			 	# 求范围，即返回 (max, min)
[1] 1 4

> sum(x) 				# 求和
[1] 10

> diff(x) 				# 求差分
[1] 1 1 1

> prod(x) 				# 求累积
[1] 24

> mean(x) 				# 求平均值
[1] 2.5

> abs(x) 				# 求绝对值，逐元素计算
[1] 1 2 3 4

> sqrt(x) 				# 求平方根，逐元素计算
[1] 1.000000 1.414214 1.732051 2.000000
```

### 2.2 数值型矩阵

#### 2.2.1 常见操作

- `t(x)` ：转置
- `diag(X)`  ：对角阵
- `%*%` ：矩阵乘法
- `solve(a, b)` ：求解 `a %*% X = b` 的解 `X`
- `solve(a)` ：矩阵的逆
- `rowSums(x)` ：行方向加和
- `colSums(x)` ：列方向加和
- `rowMeans(x)` ：行平均
- `colMeans(x)` ：列平均
- `dist(x)` ：计算矩阵x行间的距离

> 简单的 `+, -, *, /` 仅仅是逐元素计算

```R
> x <- matrix(1:4, 2, 2)
> y <- matrix(rep(10, 4), 2, 2)
> x
     [,1] [,2]
[1,]    1    3
[2,]    2    4
> y
     [,1] [,2]
[1,]   10   10
[2,]   10   10
```

```R
> rowSums(x)
[1] 4 6
> colMeans(x)
[1] 1.5 3.5

> x %*% y
     [,1] [,2]
[1,]   40   40
[2,]   60   60

> solve(x)
     [,1] [,2]
[1,]   -2  1.5
[2,]    1 -0.5

> dist(x)
         1
2 1.414214
```

#### 2.2.2 apply 函数

**格式**

```R
apply(x, margin, fun)

# x			: 矩阵对象
# margin	: 1 表示对行操作，2 表示对列操作
# fun		: 操作函数
```

```R
> z <- matrix(1:4, 2, 2)
z
> z
     [,1] [,2]
[1,]    1    3
[2,]    2    4

> apply(z, 1, sum)
[1] 4 6

> apply(z, 2, mean)
[1] 1.5 3.5
```

### 2.3 逻辑型向量

- `any()` 函数 ：只要有一个逻辑值为 `TRUE`，返回 `TRUE`
- `all()` 函数 ：所有逻辑值均为 `TRUE` 时，返回 `TRUE`
- `which()` 函数 ： 返回 `TRUE` 的位置

```R
> x <- c(TRUE, FALSE, TRUE, FALSE)

> any(x)
[1] TRUE

> all(x)
[1] FALSE

> which(x)
[1] 1 3
```

### 2.4 字符型向量

![针对字符型的操作函数](https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/QQ_1741246687101.png)

#### 2.4.1 paste 函数

- `paste()` 函数可以将多个字符串连接成一个字符串

`paste(str1, str2, ..., sep = " ")` 默认以空格隔开，此时合并的是各个元素 `str`

```R
> paste("hello", "the", "world", "!") # 默认 sep 空格隔开
[1] "hello the world !"

> paste("file", "100", ".csv", sep = "") # 指定 sep 为空
[1] "file100.csv"

> paste("file", "100", ".csv", sep = " ")
[1] "file 100 .csv"
```

`paste(vector1, vector2, ..., sep = " ", collapse = NULL)` 连接向量时，默认空格分割各个元素，但默认 `collapse` 为空，即不连接最后的字符型向量。

```R
> paste(1:3, rep("th", 3), sep = "")  # collapse = NULL 返回字符类型向量
[1] "1th" "2th" "3th"

> paste(1:3, rep("th", 3), sep = "-", collapse = ",")  # 指定 collapse 返回一个字符串
[1] "1-th,2-th,3-th"
```

`sep` 代表每个元素内的连接方式，`collapse` 代表每个元素间是否连接和连接方式。

> 第一个等价于 `paste(1:3, "th", sep = "")` ：只要有一个向量就会返回字符类型向量

#### 2.4.2  strsplit 函数

`strsplit` 函数用来分割字符串

**格式**

```R
strsplit(x, split = "")

# x		: 字符串
# split : 分割符，按照 split 分割
# 返回一个字符串列表
```

```R
> x <- "hello the world"

> strsplit(x, split = " ")
[[1]]
[1] "hello" "the"   "world"

strsplit(x, split = "")
> strsplit(x, split = "")
[[1]]
 [1] "h" "e" "l" "l" "o" " " "t" "h" "e" " " "w" "o" "r" "l" "d"
```

```R
> y <- strsplit(x, split = " ")
> y[[1]][1]
[1] "hello"
```

> 返回的是列表，先取 `[[1]]` 把向量取出，然后 `[1]` 取出向量的第一个元素。

#### 2.4.3 substr 函数

`substr` 函数提取子字符串

**格式**

```R
substr(x, from, stop)

# x 	: 字符串
# from 	: 从 from 开始提取
# stop 	: 直到 stop 停止
# 返回一个字符串
```

```R
> x <- "1234"

> substr(x, 2, 3)
[1] "23"
```

也可对向量进行操作：

```R
> x <- c("123", "456", "789")
> substr(x, 2, 2)
[1] "2" "5" "8"
```



## 3 控制流

### 3.1 if-else 条件执行

在R语言中，`if-else` 语句用于根据条件执行不同的代码块。它是一种控制流语句，允许程序根据条件的真假选择执行不同的操作。

**格式**

```R
if (condition) {
  # 如果条件为真，执行此代码块
} else {
  # 如果条件为假，执行此代码块
}
```

例如：

```R
> x <- 3

> if (x > 5) {
+     print("x 大于 5")
+ } else {
+     print("x 小于或等于 5")
+ }

[1] "x 小于或等于 5"
```

- 同样也具有 `if-else if -else` 语句结构

```R
if (condition1) {
  	# 如果 condition1 条件为真，执行此代码块
} else if (condition2) {
    # 如果 condition2 条件为真，执行此代码块
} else {
    # 否则，执行此代码块
}
```

### 3.2 ifelse 函数

`ifelse()` 对向量中的每个元素进行条件判断并返回结果，得到一个向量。

**格式**

```R
ifelse(condition, statement1, statement2)

# condition 条件为 TRUE 则返回 statement1
# condition 条件为 FALSE 则返回 statement2
```

例如：

```R
> score <- c(40, 50, 60, 70, 80, 90)

> result <- ifelse(score >= 60, "Pass", "Fail")

> result
[1] "Fail" "Fail" "Pass" "Pass" "Pass" "Pass"
```

### 3.3 for 循环

`for` 循环 ：重复地执行一个语句，直到某个变量 `var` 的值不再包含在序列 `seq` 中为止。

**格式**

```R
for (var in seq) statement

for (var in seq) {
    statement
}
```

例如：

```R
for (i in 1:10) {
    if (i %% 2 == 0) {
        string <- paste("i=", i)
        print(string)
    }
}

# 输出偶数
```

### 3.4 while 循环

`while` 循环 ：重复地执行一个语句，直到条件不为真为止。

**格式**

```R
while (condition) {
    statement
}
```

例如：

```R
i <- 0
while (i < 10) {
    print(i)
    i <- i + 1
}

# 输出 0 - 9
```

### 3.5 repeat 循环

`repeat` 循环是一种无限循环结构，它会重复执行代码块，直到显式地使用 `break` 语句退出循环。

**格式**

```R
repeat {
  # 代码块
  if (condition) {
    break
  }
}
```

例如：

```R
x <- 1
repeat {
    print(x)
    x <- x + 1
    if (x > 5) {
        break
    }
}

# 不断递增，直到大于 5
```

> 在R语言中，循环的效率可能较低。尤其是在处理大规模数据时。为了提高代码效率，R提供了许多内建函数和`apply`族函数，它们通常是基于C语言实现的，执行速度更快。R 语言提高效率的方法大多来自向量计算，使用循环会破坏这种高效的计算方式。





































