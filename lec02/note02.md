# R 语言入门 (1)

## 1 常见对象

### 1.1 向量 vector

最简单的数据结构就是由一串相同类型的元素等构成的向量 `vector`

- 标量为长度是 `1` 的向量

#### 1.1.1 `c()` 函数

```R
x <- c(0.3, 0.6)
x <- c(TRUE, FALSE)
x <- c(T, F)  # T is TRUE, F is FALSE
x <- c("M", "F")
x <- 1:4
```

> 【注意】R 语言只有 `TRUE` 和 `T` 以及 `FALSE` 和 `F`

#### 1.1.2 `rep()` 函数

**格式**

```R
rep(x, times = 1, length.out = NA, each = 1)
# x 表示数据元素
# times 表示重复次数，可以是向量
# length.out 表示总长度，运行截断
# each 每个元素重复次数，不能为向量
```

> 先执行 `each` 复制单个元素，后执行 `times` 复制整个向量

```R
rep(1:4, 2) # times = 2
rep(1:4, each = 2)
rep(1:4, c(1, 2, 3, 4)) # times = (1, 2, 3, 4)
rep(1:4, times = 2, len = 10)
rep(1:4, times = 2, each = 2)
rep("hello", times = 3)
```

> 【注意】`each = x` 等价于 `times = c(x, x, ...)`

#### 1.1.3 `seq()` 函数

**格式**

```R
seq(from = 0, to = 1, by = ((to - from) / (length.out - 1)), length.out = NULL, ...)
# from 起始数字
# to 终止数字
# by 步长，默认均匀分布
# len 长度
```

例如：

```R
seq(0, 1, length.out = 11)
seq(1, 9, by = 2)
seq(17)
```

<img src="https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/QQ_1740635933658.png" alt="QQ_1740635933658" style="zoom:50%;" />



### 1.2 矩阵 matrix

R 语言的矩阵是

- 有维度（dimension）属性的向量

- 所有元素属于相同类型

#### 1.2.1 `matrix()` 函数

**格式**

```R
matrix(NA, nrow = 1, ncol = 1, byrow = FALSE)
# NA 第一个参数为传入的数据
# nrow 行数
# ncol 列数
# byrow 是否按照行排列
```

例如：

```R
matrix(1:6, nrow = 2, ncol = 3)
matrix(1:6, nrow = 2, ncol = 3, byrow = TRUE)
```

<img src="https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/QQ_1740636318797.png" style="zoom:50%;" />

#### 1.2.2 `cbind()` `rbind()` 函数

将向量按行/列组合成矩阵

```R
x <- c(1, 2, 3)
y <- c(4, 5, 6)
cbind(x, y)
rbind(x, y)
```

<img src="https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/QQ_1740636694142.png" style="zoom:50%;" />



### 1.3 数据框 data frame

- 矩阵 `Matrix` 中只能是**同一种类型**的元素，一般是数值型

- 数据框 `Data Frame` 不同列可以是**不同数据类型**

```R
age <- c(1, 3, 5, 2, 11, 9, 3, 9, 12, 3)
weight <- c(4.4, 5.3, 7.2, 5.2, 8.5, 7.3, 6.0, 10.4, 10.2, 6.1)
gender <- c("F", "F", "F", "F", "F", "M", "M", "M", "M", "M")

df <- data.frame(age, weight, gender)
dim(df)
nrow(df)
ncol(df)
```

<img src="https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/QQ_1740636915047.png" style="zoom:50%;" />

> `dim` `nrow` `ncol` 函数也可用于矩阵 `matrix` 类型



### 1.4 列表 list

- `List` 是一个广义的 “向量” 
- 每个位置上是任意的R对象，甚至是一个列表

```R
x <- list(member = 3, names = c("Tom", "Jerry", "Lily"))
x
```

<img src="https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/QQ_1740637915471.png" style="zoom:50%;" />

```R
names(x)  # x 列表元素的别名
x$member  # 取 x 列表的 member
length(x)  # 取列表长
```

<img src="https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/QQ_1740638021720.png" style="zoom:50%;" />

> 使用 `$` 取列表的某一位置的数据



### 1.5 因子 factors

因子是一种特殊的向量：映射到整数编码，并记录所有可能的类别（称为**水平，levels**）。

使用 `factor()` 函数创建因子：

```R
# 示例：性别数据
gender <- c("男", "女", "男", "女", "男")
gender_factor <- factor(gender)
gender_factor

levels(gender_factor) <- c("male", "female")

gender_factor
```

<img src="https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/QQ_1740639382068.png" style="zoom:50%;" />



### 1.6 对象的判断和转换

#### 1.6.1 强制转换

把 R 对象从一种类型强制转化成另一个类型

```R
x <- 1:6
as.logical(x)
as.character(x)
```

<img src="https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/QQ_1740639618782.png" style="zoom:50%;" />

- 如果转换失败，则返回 `NA`

```R
x <- c("a", "b", "c")
as.logical(x)
as.numeric(x)
```

<img src="https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/QQ_1740639731257.png" style="zoom:50%;" />

#### 1.6.2 判断

- `NA` ：缺失数据 not available
- `NaN` ：无意义的数 not a number

**格式**：使用函数判断

```R
# 每个元素分别判断
is.na()
is.nan()
```

例如：

```R
x <- c(4, -1, NA)
is.na(x)
is.nan(x)

sqrt(x)
```

<img src="https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/QQ_1740640084551.png" style="zoom:50%;" />

> 特殊的数字计算 `Inf` 无穷的计算

```R
Inf + (-Inf)  # NaN
```



## 2 数据的输入

### 2.1 外部数据类型

- 文本文件

例如 `.txt` `.csv` `.dat` 文件

- 其他文件

例如 `.xls` `.xlsx` (Excel) 、 `.sas7bdat` (SAS)、 `.sav` (SPSS)、`.dta` (Stata)、`.RData` (R) 和 `.dat` 文件

> 先进行转化再读取，或用专门的程序包

### 2.2 文本数据读取

读取文本数据常见的函数

```R
read.table()
read.csv()
```

例如：

```R
read.table("example.txt")
read.csv("example.csv")
```

### 2.3 `read.table()` 函数

**参数**

```R
read.table(file, header = FALSE, sep = "", quote = "\"'",
           dec = ".", numerals = c("allow.loss", "warn.loss", "no.loss"),
           row.names, col.names, as.is = !stringsAsFactors, tryLogical = TRUE,
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 0, check.names = TRUE, fill = !blank.lines.skip,
           strip.white = FALSE, blank.lines.skip = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           stringsAsFactors = FALSE,
           fileEncoding = "", encoding = "unknown", text, skipNul = FALSE)
```

```TEXT
- file: 文件名路径, 字符串形式
- header: 表示文件第一行是否含有列名
- sep: 分隔符, 字符串, 表示各列按照 sep 指定的符号分隔
- nrows: 表示读取数据部分的最大行数
- skip: 表示跳过一定的行数后开始读取
- comment.char: 注释标记, 此符号右边的所有内容都会被忽略
- row.names: 将某一列设置为行名
- col.names: 将某一行设置为列名
```

例如：读取下面的 `grade.txt` 文件

```TEXT
--------------------------------------------
%%% grade of class A, year 2020
Name ID Grade GPA Gender
"Xiao Ming" 133001 100 4 F
"Xiao Hong" 133023 90 3.7 M
"Xiao Wan" 133099 85 3.2 M
"Song Hui" 133020 80 3.5 M
"Song Yi" 133019 100 4 M
"Donald Trump" 133012 88 3.7 M
"Clinton Hilary" 133014 90 3.7 F%%% retake
"Obama BH" 133010 "" "" M%%% Fail
------------------------------------------
```

```R
t <- read.table(
    file = "./grade.txt", # 文件路径
    header = TRUE, # 第一行为列名
    sep = " ", # 按照空格分割
    comment.char = "%", # % 为注释
    skip = 1, # 跳过一行
    nrows = 8, # 跳过一行后读 8 行
    row.names = 2 # 第 2 列设为行名
)
```

```R
> t
                 Name Grade GPA Gender
133001      Xiao Ming   100 4.0      F
133023      Xiao Hong    90 3.7      M
133099       Xiao Wan    85 3.2      M
133020       Song Hui    80 3.5      M
133019        Song Yi   100 4.0      M
133012   Donald Trump    88 3.7      M
133014 Clinton Hilary    90 3.7      F
133010       Obama BH    NA  NA      M
```

> 其他读取函数类似，只是参数默认值不同，可以相互替代

```R
read.csv(file, header = TRUE, sep = ",", ...)
read.delim(file, header = TRUE, sep = "\t", ...)
```

对于一些常规的文本文件，可直接使用默认参数。例如：

- 标准的 `.txt` 数据文件

```text
"A", 1, 10.1
"B", 2, 20.5
"C", 4, 1031.1
```

- 标准的 `.csv` 文件

```text
a,b,c
1,2,3
4,5,6
7,8,9
```

可以直接使用

```R
read.table("example.txt")
read.csv("example.csv")
```

### 2.4 `scan()` 函数

`scan()` 函数更灵活，可以读进不规则的数值文档，得到一个向量或者列表

- 需要 `what` 参数指定变量类型，得到一个`列表`

例如：针对下面的 `.txt` 文件

```TEXT
M 65 168
M 70 172
F 54 156
F 58 163
```

```R
# 指定第一列字符，第二、三列为数值
scan("example.txt", what = list("", numeric(), numeric()))

# 指定每一列的名称
scan("example.txt", what = list("gender" = "", "weight" = numeric(), "height" = numeric()))
```

<img src="https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/QQ_1740646352843.png" style="zoom:50%;" />

- `scan()` 函数还可以读取不规则长度的数值文档，得到一个`向量`

例如：对于数值文档 `example2.txt`

```txt
1
2 3 4
5 6 7 8 9
```

```R
> scan("example2.txt")

Read 9 items
[1] 1 2 3 4 5 6 7 8 9
```

### 2.5 `read.fwf()` 函数

读取文件中一些固定宽度数据，例如可以指定每一列的宽度为几，函数便会按照提前设置的宽度读取数据

```R
# M65168
# M70172
# F54156
# F58163

t <- read.fwf(
    file = "example3.txt",
    widths = c(1, 2, 3),
    col.names = c("gender", "weight", "height"),
) # 指定每一列宽度分别为 1, 2, 3

> t
  gender weight height
1      M     65    168
2      M     70    172
3      F     54    156
4      F     58    163
```

### 2.6 读取 excel 数据

- 转换为 `csv` 文件读取
- 复制后使用 `read.delim("clipboard")` 从`剪切板`中读取
- 使用程序包读取

常用程序包 `readxl`

```R
install.packages("readxl")
library("readxl")
t <- read_excel("example.xlsx")
```

### 2.7 读取网页 `url()` 和 `readLines()` 函数

```R
con <- url("https://www.baidu.com/")
x <- readLines(con)
head(x)
```



## 3 数据的输出

### 3.1 `write.table()` 函数

**参数**

```R
write.table(x, file = "", append = FALSE, quote = TRUE, sep = " ",
            eol = "\n", na = "NA", dec = ".", row.names = TRUE,
            col.names = TRUE, qmethod = c("escape", "double"),
            fileEncoding = "")
```

```R
"""将 x 写入文件 file 中"""
# sep: 各列分割符号
# quote = TRUE: 字符和因子列就会被 "" 所包裹
# eol: 尾行分隔符
# na: 缺失值字符串
```

例如：

```R
# 创建数据框 d
d <- data.frame(obs = c(1, 2, 3), treat = c("A", "B", "A"), weight = c(2.3, NA, 9))

# 保存为简单文本 txt
write.table(d, file = "./lec02/foo.txt", row.names = FALSE)
# 保存为 , 分割文本
write.csv(d, file = "./lec02/foo.csv", row.names = FALSE)
# 保存为 .RData 格式文件
save(d, file = "./lec02/foo.RData")
```



















