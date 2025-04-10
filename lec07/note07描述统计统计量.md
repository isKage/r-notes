# 描述统计：统计量

在描述行统计中，除了统计图表，统计量可以定量的描述数据。本章介绍常见的统计量：均值、方差、标准差、中位数、四分位数、变异系数、IQR、极差、偏度、峰度、Q-Q 图。以及分类汇总函数 aggregate 。

## 1 描述统计：统计量

**定性变量**：频数、比例

**定量变量**：集中信息、波动信息、形状信息

### 1.1 集中信息

#### 1.1.1 样本均值

对于数据 $x_1,\ x_2,\ \cdots,\ x_n$ 的**样本均值**为：
$$
\bar{x} = \frac{x_1 + x_2 + \cdots + x_n}{n} = \frac{1}{n}\sum\limits_{i = 1}^n\ x_i
$$
缺点：均值容易受到极端值影响。

```R
mean(x)
```

#### 1.1.2 中位数

**样本中位数**是对原始数据排序，位于数据中心的数据。
$$
x_{MED} = x_{(\frac{n+1}{2})}\quad or\quad (x_{(\frac{n}{2})} + x_{(\frac{n}{2} + 1)})/2
$$
假设有定量数据 $x_1,\ x_2,\ \cdots,\ x_n$ ，定义排序后的数据 $x_{(1)} \leq x_{(2)} \leq \cdots \leq x_{(n)}$ 。

优点：稳健，不容易受到极端值影响。

```R
median(x)
```

#### 1.1.3 示例

```R
finalgrades <- read.csv("finalgrades.csv")
mydata <- finalgrades[, c(6:9)]

## 均值
grade.mean <- apply(mydata, 2, mean)
grade.mean
#     政治     语文     数学     物理 
# 50.31056 81.64907 41.29503 24.76708 

## 中位数
grade.median <- apply(mydata, 2, median)
grade.median
# 政治 语文 数学 物理 
#   51   84   40   24 

## 左偏/右偏
grade.mean > grade.median
#  政治  语文  数学  物理 
# FALSE FALSE  TRUE  TRUE 
```

![](https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/grades.png)

### 1.2 波动信息

#### 1.2.1 方差/标准差

**样本方差**：反映了所有数据离中心的平均的平方距离
$$
s^2 = \frac{1}{n-1}\sum\limits_{i=1}^n\ (x_i - \bar{x})^2
$$


**样本标准差**：近似反映了所有数据离中心的平均距离
$$
s = \sqrt{s^2} = \sqrt{\frac{1}{n-1}\sum\limits_{i=1}^n\ (x_i - \bar{x})^2}
$$

```R
sd(x)
```

#### 1.2.2 变异系数

**变异系数 Coefficient of Variation** ($CV$) ：比较不同单位的数据的离散程度；比较单位相同而平均数相差较大的数据组资料的差异程度。
$$
CV = \frac{s}{\bar{x}} \times 100
$$

```R
100 * sd(x) / mean(x)
```

#### 1.2.3 四分位间距/极差

**四分位差** (Inter - Quartile Range, $IQR$) ：中间 $50\%$ 数据的范围。
$$
IQP = Q_3 - Q_1
$$

```R
IQR(x)
```

**极差** ：所有数据的范围
$$
range = x_{(n)} - x_{(1)}
$$

```R
range(x)
```

### 1.3 形状信息

#### 1.3.1 偏度

**总体偏度**的定义
$$
Skewness = E\ (\frac{X - \mu}{\sigma})^3
$$
**样本偏度**的定义
$$
g_1 = \frac{n}{(n-1)(n-2)\cdot s^3} \sum\limits_{i=1}^n\ (x_i - \bar{x})^3
$$
偏度判断：

- 对称：Skewness = 0
- 右偏：Skewness > 0
- 左偏：Skewness < 0

#### 1.3.2 峰度

**峰度**反应了峰部的尖度，总体峰度的定义：
$$
Kurtosis = E\ (\frac{X - \mu}{\sigma})^4 - 3
$$
**样本峰度**：
$$
g_2 = \frac{n(n+1)}{(n-1)(n-2)(n-3)\cdot s^4}\sum\limits_{i=1}^n\ (x_i - \bar{x})^4 - 3\cdot \frac{(n-1)^2}{(n-2)(n-3)}
$$
峰度判断：

- 正态分布：Kurtosis = 0
- 峰度越大，高峰分布：两端数据多（厚尾），中间数据少，且集中在均值附近。

- Kurtosis > 0 ，与正态分布相比是高峰

#### 1.3.3 R 语言实现

调用 `moments` 包：

```R
library("moments")
grade.skewness <- apply(mydata, 2, skewness)
grade.kurtosis <- apply(mydata, 2, kurtosis)

grade.skewness
#       政治       语文       数学       物理 
# -0.3105433 -0.6525492  0.5757198  0.5463615 

grade.kurtosis  # 没有减 3
#     政治     语文     数学     物理 
# 2.832892 3.416347 3.539414 3.308497 

grade.kurtosis <- apply(mydata, 2, kurtosis) - 3
grade.kurtosis
#       政治       语文       数学       物理 
# -0.1671077  0.4163471  0.5394144  0.3084971 
```

> 【注意】：R 语言的 `kurtosis()` 函数没有进行 `- 3` 操作。

```R
kurtosis(rnorm(10000))  # 没有减 3
# [1] 2.999622
```

#### 1.3.4 Q-Q 图

**Q-Q Plot** ：对于观测数据 $x_1,\ x_2,\ \cdots,\ x_n$ 对其排序后得到 $x_{(1)} \leq x_{(2)} \leq \cdots \leq x_{(n)}$ ，它们的概率为：
$$
P(X \leq x_{(j)}) = \frac{j}{n} \approx \frac{j - 0.375}{n + 0.25}
$$
然后取出标准正态分布的分位数点 $F^{-1}(\frac{j - 0.375}{n + 0.25})$ 。绘制散点图：
$$
(F^{-1}(\frac{j - 0.375}{n + 0.25}),\ x_{(j)})
$$
若大致为线性关系/直线，则可以认为 $x_i$ 满足近似正态。

**R 语言实现**：

```R
x <- mydata[, 1]
qqnorm(x, main = "Q-Q Plot")
qqline(x)
```

<img src="https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/qq.png" style="zoom:25%;" />

对于非正态的 Q-Q 图，有如下的例子：左边为右偏，右边为左偏

![](https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/QQ_1743665372563.png)

### 1.4 其他

```R
fivenum(x)  # 5 个分位数 min, q1, median, q3, max
summary(x)  # 5 个分位数 + mean
quantile(x) # 5 个分位数 0%  25%  50%  75% 100%
```

```R
> fivenum(x)
[1] 14 42 51 59 79

> summary(x)
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  14.00   42.00   51.00   50.31   59.00   79.00 

> quantile(x)
  0%  25%  50%  75% 100% 
  14   42   51   59   79 
```

## 2 描述统计：分类汇总

### 2.1 aggregate 函数

**格式**

```R
aggregate(x ~ by, FUN, na.rm = T, data)
```

**参数**

```R
x		: 列名，或是列序号，多个使用 cbind() 组合
by		: 分类依据的列名，多个使用 + 组合
FUN		: 表示整合的方式，传入函数
na.rm	: 如果为 NA 则直接删去行数据
data	: 操作的数据框
```

### 2.2 示例

例：按照 `city` 和 `R` 计算 `minimumpay, maximumpay, logmeanpay` 列的均值

```R
mydata <- read.csv("jobinfor201xE.csv", encoding = "utf-8")
head(mydata)
str(mydata)

aggregate(cbind(minimumpay, maximumpay, logmeanpay) ~ city + R, FUN = mean, na.rm = T, data = mydata)
```

结果：

```R
   city R minimumpay maximumpay logmeanpay
1  北京 0   8245.586  12548.425   9.035330
2  河北 0   4536.095   6748.496   8.521607
3  山西 0   6045.913   8798.888   8.678785
4  陕西 0   5225.994   7964.530   8.610160
5  上海 0   7733.406  11325.135   9.018670
6  深圳 0   7430.474  11419.152   9.001751
7  北京 1   9533.537  14261.561   9.245172
8  河北 1   4500.000   5999.000   8.565888
9  山西 1   3500.000   5499.500   8.301702
10 陕西 1   8318.182  11226.455   9.007055
11 上海 1  10665.874  16020.449   9.388033
12 深圳 1  10682.540  16854.706   9.418756
```





































