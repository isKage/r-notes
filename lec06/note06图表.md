# 统计软件 R 语言笔记 (6)：统计图表

本章介绍了常见的统计图表和其 R 语言实现方法：频数频率图表、条形/柱状图、列联表、饼图；直方图、箱线图、散点图。同时介绍了 R 语言绘图的范式：高级&低级绘图函数、常见参数设置、子图、保存图片的方法。

## 1 定性变量的统计图表

### 1.1 频率/频数表（Frequency Table）
**定义**：统计各分类出现的次数或比例。

**R实现**  

- 简单频数表：`table()` 函数  
```r
> # 示例：性别频数表
> gender <- c("男", "女", "男", "男", "女")
> freq_table <- table(gender)
> print(freq_table)
gender
男 女 
 3  2 
```

- **频率表（百分比）**：`prop.table()` 函数
```r
> prop_table <- prop.table(freq_table) * 100
> print(prop_table)
gender
男 女 
60 40 
```

**注意事项**：若数据为数值型但需按分类统计，需先转换为因子：`factor(data)`。

### 1.2 条形图/柱状图（Bar Chart）
**用途**：展示分类变量的频数分布，支持横向/纵向排列。

**R实现**

- 基础绘图：`barplot()`  
```r
barplot(freq_table,
    main = "gender bar plot",  		# 标题
    xlab = "gender",				# x 轴
    ylab = "freq",					# y 轴
    col = c("skyblue", "pink"),		# 颜色
    horiz = TRUE					# 是否横向
)
```

- 堆叠条形图：`barplot(height)` 当 `height` 为矩阵时

```R
# 示例数据
data <- matrix(c(20, 30, 25, 35, 15, 40), nrow = 2, byrow = TRUE)
rownames(data) <- c("Male", "Female")
colnames(data) <- c("A", "B", "C")

# 绘制堆叠条形图
barplot(data,
    main = "Gender Distribution by Category",
    beside = FALSE,  # 默认 FALSE ，为 TRUE 则不是堆叠而是并列
    xlab = "Category",
    ylab = "Frequency",
    col = c("skyblue", "pink"),
    legend.text = rownames(data), # 添加图例
    args.legend = list(x = "topright") # 图例位置
)

```

![并列和堆叠](https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/stacked_and_grouped_barplot.png)

- `ggplot2` 库 
```r
library(ggplot2)
ggplot(data.frame(gender), aes(x = gender)) +
    geom_bar(fill = c("skyblue", "pink")) +
    labs(title = "gender bar plot", x = "gender", y = "freq")
```

### 1.3 列联表（Contingency Table）
**定义**：分析两个或多个分类变量的交叉分布。

**R实现**  

- 基础方法：`table(var1, var2)` 或 `xtabs(~var1 + var2, data)`  
  
```r
> # 示例：性别与血型列联表
> blood_type <- c("A", "B", "O", "A", "B")
> cross_table <- table(gender, blood_type)
> print(cross_table)
      blood_type
gender A B O
    男 2 0 1
    女 0 2 0
```

- 添加边际和：`addmargins()`  
```r
> addmargins(cross_table)
      blood_type
gender A B O Sum
   男  2 0 1   3
   女  0 2 0   2
   Sum 2 2 1   5
```

- 比例表：  
```r
> prop.table(cross_table, margin = 1)  # 按行计算比例
      blood_type
gender         A         B         O
    男 0.6666667 0.0000000 0.3333333
    女 0.0000000 1.0000000 0.0000000
```

### 1.4 饼图（Pie Chart）
**用途**：展示各类别占比（适用于少量分类）。

**R实现**  

- 基础绘图：`pie()`  
```r
gender <- c("Male", "Female", "Male", "Male", "Female")
freq_table <- table(gender)
pie(freq_table,
    labels = names(freq_table), # 每一块扇形标签 字符型向量
    main = "Pie of gender", # 表头
    col = c("skyblue", "pink") # 颜色
)

# 也可以展示占比
prop_table <- prop.table(freq_table) * 100
gender <- c("Male", "Female", "Male", "Male", "Female")
freq_table <- table(gender)
pie(freq_table,
    labels = paste(prop_table, "%", sep = ""), # 每一块扇形标签 字符型向量
    main = "Pie of gender", # 表头
    col = c("skyblue", "pink") # 颜色
)
```

![](https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/pie.png)

- `ggplot2` 库
  
```r
ggplot(data.frame(gender), aes(x = "", fill = gender)) +
    geom_bar(width = 1) +
    coord_polar(theta = "y") +
    labs(title = "Pie of gender") +
    theme_void()
```



## 2 定量变量的统计图表

### 2.1 直方图（Histogram）
**用途**：展示连续变量的分布与频数，通过分箱（bin）统计。直方图中，矩形的高度表示每一组的频数或频率，宽度则表示各组的组距，因此其高度与宽度均有意义。

**格式**

```R
hist(x, breaks = "Sturges",
     freq = NULL, probability = !freq,
     include.lowest = TRUE, right = TRUE, fuzz = 1e-7,
     density = NULL, angle = 45, col = "lightgray", border = NULL,
     main = paste("Histogram of" , xname),
     xlim = range(breaks), ylim = NULL,
     xlab = xname, ylab,
     axes = TRUE, plot = TRUE, labels = FALSE,
     nclass = NULL, warn.unused = TRUE, ...)
```

| **参数**         | **说明**                                                     | **默认值**                     |
| :--------------- | :----------------------------------------------------------- | :----------------------------- |
| `x`              | 输入数据，通常为数值型向量。                                 | 无                             |
| `breaks`         | 定义直方图的区间划分方式。可以是区间数（如 10）、区间向量（如 `c(0, 10, 20)`）或字符串（如 "Sturges"）。 | `"Sturges"`                    |
| `freq`           | 是否显示频数（TRUE）或概率密度（FALSE）。                    | `NULL`                         |
| `probability`    | 是否绘制概率密度图（TRUE）或频数直方图（FALSE）。            | `!freq`                        |
| `include.lowest` | 是否包含区间的最小值。                                       | `TRUE`                         |
| `right`          | 区间是否右闭合（TRUE）或左闭合（FALSE）。                    | `TRUE`                         |
| `col`            | 填充颜色。                                                   | `"lightgray"`                  |
| `main`           | 图形标题。                                                   | `paste("Histogram of", xname)` |
| `xlim`           | x轴范围。                                                    | `range(breaks)`                |
| `ylim`           | y轴范围。                                                    | `NULL`                         |
| `xlab`           | x轴标签。                                                    | `xname`                        |
| `ylab`           | y轴标签。                                                    | 自动生成                       |
| `axes`           | 是否绘制坐标轴。                                             | `TRUE`                         |
| `plot`           | 是否绘制图形（TRUE）或仅返回计算结果（FALSE）。              | `TRUE`                         |
| `labels`         | 是否在条形上方显示标签。                                     | `FALSE`                        |
| `nclass`         | 区间数的替代参数。                                           | `NULL`                         |

**示例**

- 基础绘图：`hist()`  
  
```r
data <- rnorm(1000, mean = 50, sd = 10)
hist(data,
    breaks = 20, # 分箱数
    main = "Histogram",
    xlab = "values",
    col = "skyblue"
)
```

```R
# 添加趋势线
xfit <- seq(min(data), max(data), length = 40)
yfit <- dnorm(xfit, mean = mean(data), sd = sd(data))
lines(xfit, yfit, col = "blue", lwd = 2)
```

<img src="https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/hist.png" alt="hist" style="zoom:67%;" />

### 2.2 箱线图（Boxplot）
**用途**： 展示数据的中位数、四分位数、离群点，支持分组比较。

**格式**  

|   **参数**   |                        **说明**                        |                     **默认值**                      |
| :----------: | :----------------------------------------------------: | :-------------------------------------------------: |
|     `x`      |  输入数据，可以是向量、列表或公式（如 `y ~ group`）。  |                         无                          |
|    `...`     |     其他图形参数（如 `main`, `xlab`, `ylab` 等）。     |                         无                          |
|   `range`    |     定义异常值的范围（默认为 1.5 倍的四分位距）。      |                        `1.5`                        |
|   `width`    |                     箱线图的宽度。                     |                       `NULL`                        |
|  `varwidth`  |             是否根据样本量调整箱线图宽度。             |                       `FALSE`                       |
|   `notch`    |           是否绘制缺口以比较中位数的显著性。           |                       `FALSE`                       |
|  `outline`   |                    是否显示异常值。                    |                       `TRUE`                        |
|   `names`    |                   箱线图的组别标签。                   |                      自动生成                       |
|    `col`     |                   箱线图的填充颜色。                   |                    `"lightgray"`                    |
|    `log`     |                  是否对坐标轴取对数。                  |                        `""`                         |
|    `pars`    | 图形参数的列表（如 `boxwex`, `staplewex`, `outwex`）。 | `list(boxwex = 0.8, staplewex = 0.5, outwex = 0.5)` |
|    `ann`     |               是否绘制坐标轴标签和标题。               |                       `!add`                        |
| `horizontal` |                  是否绘制水平箱线图。                  |                       `FALSE`                       |
|    `add`     |             是否将箱线图添加到现有图形中。             |                       `FALSE`                       |
|     `at`     |            箱线图的位置（用于并排箱线图）。            |                       `NULL`                        |

**示例**

- 单组箱线图

```R
data <- rnorm(100)
boxplot(data, main = "Boxplot of Normal Data", col = "skyblue")
```

- 并排箱线图

```R
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
```

- 带缺口的箱线图（只是为了突出中位数）

```R

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
```

![boxplots](https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/boxplots.png)

- `~` 分组绘制

```R
# 使用内置数据集 mtcars
boxplot(mpg ~ cyl, # mpg 按照 cyl 分组画出 boxplot
    data = mtcars, # mpg, cyl 都是数据框 mtcars 的列
    main = "MPG by Cylinder",
    xlab = "Number of Cylinders",
    ylab = "Miles per Gallon",
    col = c("skyblue", "pink", "lightgreen")
)
```

![分组绘制：mpg 按照 cyl 分组画出 boxplot，而 cyl 有三组](https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/grouped_boxplots.png)

### 2.3 散点图（Scatter Plot）两个定量变量

**用途**：分析两个定量变量的相关性或分布模式。

**基础使用**

```R
plot(women$height, women$weight)
```

下面，借由这个例子，介绍 R 语言绘图的范式。



## 3 R 语言绘图

### 3.1 高级 & 低级绘图函数

在R中有两种绘图函数：

- **高级绘图函数**：创建一个新的图形，如 `hist` `plot` 。
- **低级绘图函数**：在现有的图形上添加元素，对原有图进行补充，如 `lines` 。

#### 3.1.1 高级绘图函数

| **函数名**   | **功能描述**                              |
| ------------ | ----------------------------------------- |
| `plot(x)`    | 以 x 的元素值为纵坐标、以序号为横坐标绘图 |
| `plot(x,y)`  | x 与 y 的二元作图                         |
| `pie(x)`     | 饼图                                      |
| `boxplot(x)` | 盒形图（也称箱线图）                      |
| `hist(x)`    | x 的频率直方图                            |
| `barplot(x)` | x 的值的条形图                            |
| `qqnorm(x)`  | 正态分位数-分位数图                       |

#### 3.1.2 低级绘图函数

| **函数名**                | **功能描述**                                   |
| ------------------------- | ---------------------------------------------- |
| `points(x, y)`            | 添加点                                         |
| `lines(X, Y)`             | 添加线                                         |
| `text(x, y, labels, ...)` | 加标记，在 (x, y) 处添加用 labels 指定的文字   |
| `abline(a, b)`            | 加直线，绘制斜率为 b 和截距为 a 的直线         |
| `abline(h = y)`           | 加直线，在纵坐标 y 处画水平线                  |
| `abline(v = x)`           | 加直线，在横坐标 x 处画垂直线                  |
| `abline(lm.obj)`          | 加直线，画出 lm.obj 确定的回归线               |
| `legend(x, y, legend)`    | 加注释，在点 (x, y) 处，说明内容由 legend 给定 |
| `title()`                 | 加标题，也可添加一个副标题                     |
| `axis(side, vect)`        | 加坐标轴                                       |

### 3.2 参数

#### 3.2.1 共同参数选项

| **选项**       | **功能**                     |
| -------------- | ---------------------------- |
| `axes=TRUE`    | 如果是 FALSE，不绘制轴与边框 |
| `type="p"`     | 指定图形的类型               |
| `xlim=, ylim=` | 指定轴的显示范围             |
| `xlab=, ylab=` | 坐标轴的标签                 |
| `main=`        | 主标题                       |
| `sub=`         | 副标题                       |

> `"p"`：点
>
> `"l"`：线
>
> `"b"`：点连线
>
> `"o"`：同上，但是线在点上
>
> `"h"`：垂直线
>
> `"s"`：阶梯式，垂直线顶端显示数据
>
> `"S"`：同上，但是垂直线底端显示数据

示例：一些常见参数的用法

![共同参数的指代](https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/QQ_1742892621595.png)

示例：不同的点类型 `type`

![不同点类型，参数 type](https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/QQ_1742892676179.png)

#### 3.2.2 其他常用绘图参数

| **选项**      | **功能**                                                     |
| ------------- | ------------------------------------------------------------ |
| `adj`         | 控制关于文字对齐方式（0-左对齐，0.5-居中对齐，1-右对齐）     |
| `cex`         | 符号和文字大小：`cex.axis`, `cex.main`, `cex.axis`, `cex.main` |
| `col`         | 颜色： `col.axis`, `col.lab`, `col.main`, `col.axis`, `col.lab`, `col.main` |
| `font`        | 文字字体（1-正常，2-粗体，3-斜体，4-粗斜体）：`font.axis`, `font.lab`, `font.main`, `font.axis`, `font.lab`, `font.main` |
| `lwd`         | 线的宽度                                                     |
| `lty`         | 连线的线型（1-实线，2-虚线，3-点线，4-点虚线，5-长虚线，6-双虚线） |
| `pch`         | 绘图符号的类型（1到25的整数）                                |
| `pty`         | 绘图区域类型                                                 |
| `xaxt` `yaxt` | 如果 `xaxt="n"`，设置 x 轴不显示；如果 `yaxt="n"`，设置 y 轴不显示 |
| `srt`         | 文字旋转角度                                                 |

<img src="https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/QQ_1742893115596.png" alt="pch 不同数字对应的图案" style="zoom:100%;" />

特别地，`pch` 可以传入一个字符串向量，当作图案：

```R
pch_type <- c("*", "a", "A", "?", "1")
X <- 1:5
Y <- rep(6, 5)
plot(X, Y, col = 1, pch = pch_type, cex = 2, main = "pch:*aA?1", font.lab = 2)
```

> `pch = pch_type` ：图案可以自定义 `pch_type`

### 3.3 画图面板分割：子图

`mfrow` 参数：

- 按**行顺序**填充子面板。

- 语法：`par(mfrow = c(nrow, ncol))`，其中 `nrow` 是行数，`ncol` 是列数。
- 示例：`par(mfrow = c(2, 2))` 将绘图窗口分割为 2 行 2 列，共 4 个子面板。

`mfcol` 参数：

- 按**列顺序**填充子面板。
- 语法：`par(mfcol = c(nrow, ncol))`。

示例：

```R
# 设置绘图面板为 2 行 2 列
op <- par(mfrow = c(2, 2))

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

par(op)
```

> 用 `op` 对象存储 `par()` 函数的子图设置，再次使用 `par(op)` 即可重置默认设置。否则，之后的绘图会一直按照 最开始 `par()` 的设置放置。

### 3.4 保存图片

#### 3.4.1 png() 保存为 PNG 图片
```R
# 打开 PNG 设备，设置文件名和尺寸
png("my_plot.png", width = 800, height = 600)

# 绘制图形
plot(X, Y, main = "My Plot", col = "blue")

# 关闭设备，保存图片
dev.off()
```
**参数说明**

- `"my_plot.png"`：保存的文件名。  
- `width` 和 `height`：图片的宽度和高度（单位：像素）。  
- `dev.off()`：关闭图形设备，保存图片。  

#### 3.4.2 pdf() 保存为 PDF 文件 

```R
# 打开 PDF 设备，设置文件名和尺寸
pdf("my_plot.pdf", width = 8, height = 6)

# 绘制图形
plot(X, Y, main = "My Plot", col = "blue")

# 关闭设备，保存文件
dev.off()
```
**参数说明**

- `"my_plot.pdf"`：保存的文件名。  
- `width` 和 `height`：图片的宽度和高度（单位：英寸）。  

---

#### 3.4.3 jpeg() 保存为 JPEG 图片
```R
# 打开 JPEG 设备，设置文件名和尺寸
jpeg("my_plot.jpg", width = 800, height = 600, quality = 100)

# 绘制图形
plot(X, Y, main = "My Plot", col = "blue")

# 关闭设备，保存图片
dev.off()
```
**参数说明**  

- `quality`：图片质量（0-100），值越大质量越高。  

#### 3.4.4 dev.copy() 保存当前图片
```R
# 绘制图形
plot(X, Y, main = "My Plot", col = "blue")

# 复制当前图形并保存为 PNG
dev.copy(png, "my_plot.png", width = 800, height = 600)
dev.off()
```
**适用场景**：在已经绘制图形的情况下，直接保存当前图形。  

#### 3.4.5 保存多子图面板
如果使用 `par(mfrow = c(nrow, ncol))` 绘制了多子图面板，可以直接保存整个面板：  
```R
# 打开 PNG 设备
png("multi_panel_plot.png", width = 1200, height = 800)

# 设置面板布局
par(mfrow = c(2, 2))

# 绘制多个子图
plot(X, Y, main = "Default")
plot(X, Y, main = "Blue Point", col = "blue")
plot(X, Y, main = "Red Point", col = "red")
plot(X, Y, main = "Green Point", col = "green")

# 关闭设备，保存图片
dev.off()
```





