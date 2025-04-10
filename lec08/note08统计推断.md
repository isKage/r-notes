# 统计推断：估计与假设检验 t.test 与 cor.test

利用观测样本对总体参数的：点估计、区间估计与假设检验。

## 1 统计推断的基本概念

### 1.1 点估计

#### 1.1.1 估计

用于估计的统计量称为**估计量（estimator）**；如果样本已经得到，把数据带入之后，估计量就有了一个数值，称为该估计量的一个**实现（realization）或取值**，也称为一个**估计值（estimate）**。

#### 1.1.2 抽样分布

由于一个统计量对于不同的样本取值不同。所以，估计量也是随机变量，并有其分布，称为：**抽样分布（sampling distribution）**—— 从总体中选取的固定样本量所对应的样本统计量（例如样本均值）的可能值的分布，该分布来源于不同的样本。

#### 1.1.3 无偏估计

**无偏估计** ：来自不同样本的平均估计量等于真实参数
$$
E(\hat{\theta}) = \theta
$$
其中 $\hat{\theta}$ 为总体参数 $\theta$ 的估计。

样本均值和样本方差的无偏性：

- 样本均值对于总体均值是无偏的：$E(\bar{X}) = \mu$
- 样本方差对于总体方差是无偏的：$E(S^2) = \sigma^2,\quad S^2 = \frac{1}{n-1}\sum\limits_{i=1}^n\ (X_i - \bar{X})^2$ 

#### 1.1.4 标准误差

点估计的标准误差：该抽样分布的标准差。
$$
SD(\hat{\theta}) = \sqrt{S^2}
$$
样本均值的标准误差：

- 它衡量了点估计量在不同样本之间的变动程度。样本均值的标准差为：$SD(\bar{X}) = \frac{\sigma}{\sqrt{n}} \approx \frac{s}{\sqrt{n}}$

- 样本量 n 越大，标准误差越小。这意味着增大样本量 n 可能会提高样本均值的稳定性。

### 1.2 区间估计

#### 1.2.1 概念

对于 $1 - \alpha$ 置信区间 $[c_1,\ c_2]$ 代表了真值 $\theta$ 落入区间的概率为 $1 - \alpha$ 。

例如常见的区间估计：对于样本均值的置信区间
$$
[\bar{x} - t_{\alpha/2}(n-1)\cdot \frac{s}{\sqrt{n}},\ \bar{x} + t_{\alpha/2}(n-1)\cdot \frac{s}{\sqrt{n}}]
$$
其中 $t_{\alpha/2}(n-1)$ 为自由度为 n - 1 的 t 分布的 $\alpha/2$ 分位数点。

#### 1.2.2 R 语言模拟

对于一个 $95\%$ 的置信区间，代表不断重复抽取（样本量相同的）样本时，产生的大量区间估计，这些区间大约有 $95\%$ 会覆盖真正的参数。

**求解置信区间：**求解对样本均值的区间估计的函数 `takeCI`

```R
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
```

**模拟一次：**例如从标准正态中抽样，然后对均值进行区间估计

```R
> x <- rnorm(n = 20, mean = 0, sd = 1)  # 抽样 20 个
> takeCI(x)
       left       right 
-0.69806027  0.09131091 
```

> 【注意】根据单独一个样本集合估计的到的区间不一定包含真实值。

**模拟多次：**重复模拟，并记录包含真实总体均值的频率，注意到大致等于 $95\%$

```R
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

coverage_rate <- auc / N  # 0.961
```

### 1.3 假设检验

#### 1.3.1 概念

对于参数 $\theta$ 的估计为 $\hat{\theta}$ 的参数空间为 $\Theta$ ，而原假设为 $\theta \in \Theta_0$ 于是假设检验为：
$$
H_0: \theta \in \Theta_0,\quad H_1: \theta \notin \Theta_0
$$
通过检验统计量判断是否异常，若满足拒绝域，则拒绝原假设 $H_0$ 。

例如：对于样本均值的估计为 $\bar{X}$ ，原假设为认为总体均值 $\mu \geq \mu_0$ ，其中 $\mu_0$ 为常数。
$$
H_0: \mu \geq \mu_0,\quad H_1:  \mu < \mu_0
$$
更简单的方式，直接查看 p 值，当
$$
p \leq \alpha
$$
即 p 值小于显著性水平，则拒绝原假设。

#### 1.3.2 R 语言模拟

假设检验：
$$
H_0: \mu \geq \mu_0,\quad H_1:  \mu < \mu_0
$$
的拒绝域为：
$$
W_c = \{ (x_1,\ x_2,\ \cdots,\ x_n): \bar{x} = \frac{1}{n}\sum\limits_{i=1}^n\ x_i \geq c \}
$$
势函数为：
$$
G_W(F) = P\{ (X_1,\ X_2,\ \cdots,\ X_n) \in W \}
$$
对于这个例子：
$$
G_c(\mu) = P_{\mu}\{ (X_1,\ X_2,\ \cdots,\ X_n) \in W_c \} = P_{\mu}(\bar{X}\geq c) = P_{\mu}(\frac{\bar{X} - \mu_0}{s/\sqrt{n}} \geq \frac{c - \mu_0}{s/\sqrt{n}} )
$$

```R
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
sum(t_list <= c) / N  # N 个样本拒绝的次数 / 总模拟次数
# 0.948
```

对于第 `I` 类错误，控制在 $\alpha$ 的 R 语言模拟验证：

```R
# 控制第 I 类错误：H0 对但拒绝
alpha <- 0.05
n <- 100
N <- 1000
p_t_list <- NULL

for (i in 1:N) {
    y <- rnorm(n, 0, 1)
    t <- (mean(y) - 0) / (sd(y) / sqrt(n)) # t 检验量
    p_t <- pt(t, df = n - 1) # P(X < t) = p_t, X ~ t(n-1) 这个问题的 p 值
    p_t_list <- c(p_t_list, p_t) # t 检验量分位数对应的 t(n-1) 分布概率加入 t_list
}
sum(p_t_list <= alpha) / N # 犯第 I 类错误
# 0.058
```

> p 值是统计量，且满足均匀分布 $U[0,1)$ 。



## 2 常见的统计推断

### 2.1 正态总体均值

第一步验证模型假设，例如使用 Q-Q 图验证是否近似正态。

#### 2.1.1 t.test() 检验函数

**t-检验：** `t.test()` 提供了正态总体均值的 t。检验方法。

```R
t.test(x, y = NULL,
       alternative = c("two.sided", "less", "greater"),
       mu = 0, paired = FALSE, var.equal = FALSE,
       conf.level = 0.95, ...)
```

```R
x, y				: 可以单样本也可以两样本
alternative			: 方向，单侧 "less", "greater" 或是双侧 "two.sided" 与备择假设同向
mu = 0				: 检验均值的 mu_0 ，默认 0
conf.level = 0.95	: 置信水平
```

例如：

```R
X <- c(159, 280, 101, 212, 224, 379, 179, 264, 222, 362, 168, 250, 149, 260, 485, 170)
t.test(X, alternative = "greater", mu = 225)
```

```R

        One Sample t-test

data:  X
t = 0.66852, df = 15, p-value = 0.257
alternative hypothesis: true mean is greater than 225
95 percent confidence interval:
 198.2321      Inf
sample estimates:
mean of x 
    241.5 
```

T 检验量的值 `t = 0.66852`

df 自由度 `n - 1 = 15`

p-value `p-value = 0.257` 所以拒绝 `true mean is greater than 225`

`95%` 置信区间 `[198.2321, Inf]`

#### 2.1.2 两样本均值差的推断

对于两个独立同分布的样本
$$
X_1,\ X_2,\ \cdots,\ X_n \sim N(\mu_1, \sigma_1^2)
$$

$$
Y_1,\ Y_2,\ \cdots,\ Y_n \sim N(\mu_2, \sigma_2^2)
$$

若方差相等 $\sigma_1 = \sigma_2$ 。

**使用 `t.test()` 函数**

```R
t.test(formula, data, subset, na.action = na.pass, ...)
```

```R
formula: df~class 前者 df 为定量变量，后者 class 为定类变量。
data: 数据框
```

例如：

```R
df <- read.csv("./Score.csv")

t.test(score ~ Gender, data = df) # 数据库 df 的 score 列按照 Gender 分类
```

```R

        Welch Two Sample t-test

data:  score by Gender
t = 1.9163, df = 97.963, p-value = 0.05824  # df = m + n - 2
alternative hypothesis: true difference in means between group Female and group Male is not equal to 0
95 percent confidence interval:
 -0.1422661  8.1422661
sample estimates:
mean in group Female   mean in group Male 
               73.12                69.12 
```

**检验模型近似正态：**

```R
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
```

![qq-plot](https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/qq_score.png)

**检验方差：**经验直观的方法，比较 IQR

```R
boxplot(score ~ Gender, data = df)
```

或者使用 `vat.test()` 

```R
## Default S3 method:
var.test(x, y, ratio = 1,
         alternative = c("two.sided", "less", "greater"),
         conf.level = 0.95, ...)

## S3 method for class 'formula'
var.test(formula, data, subset, na.action, ...)
```

例如：

```R
var.test(score ~ Gender, data = df)
```

```R

        F test to compare two variances

data:  score by Gender
F = 1.0397, num df = 49, denom df = 49, p-value = 0.892
alternative hypothesis: true ratio of variances is not equal to 1
95 percent confidence interval:
 0.5900309 1.8322278
sample estimates:
ratio of variances 
          1.039746 
```

注意到方差不相等，则

```R
t.test(score ~ Gender, data = df, var.equal = FALSE)
```

```R

        Welch Two Sample t-test

data:  score by Gender
t = 1.9163, df = 97.963, p-value = 0.05824
alternative hypothesis: true difference in means between group Female and group Male is not equal to 0
95 percent confidence interval:
 -0.1422661  8.1422661
sample estimates:
mean in group Female   mean in group Male 
               73.12                69.12 
```

#### 2.1.3 成对正态样本均值差的检验

```R
t.test(X - Y)
t.test(X, Y, paired = TURE)
```

#### 2.1.4 正态性检验 shapiro.test()

可以采用直观的 Q-Q 图和直方图检验，更严谨地采用 `shapiro.test()` 检验。

- p 值小于 0.05 ，总体不是正态
- p 值大于 0.05 ，仅仅不能否认“总体是正态”

```R
x <- rnorm(n = 100, mean = 0, sd = 1)

shapiro.test(x)
```

```R

        Shapiro-Wilk normality test

data:  x
W = 0.98887, p-value = 0.5745  # 不能否认 x 是正态
```

### 2.2 相关系数推断 cor.test()

相关系数：描述了两变量 X, Y 之间数据的相关性。

三种相关系数：`Pearson` `Spearman` `Kendall` 。使用函数 `cor.test()` 进行检验：

```R
## Default S3 method:
cor.test(x, y,
         alternative = c("two.sided", "less", "greater"),
         method = c("pearson", "kendall", "spearman"),
         exact = NULL, conf.level = 0.95, continuity = FALSE, ...)

## S3 method for class 'formula'
cor.test(formula, data, subset, na.action, ...)
```

- `alternative` ：单侧或是双侧
- `method` ：选择三个相关系数之一
- `conf.level` ：置信水平

有关 `alternative` （与备择假设同方向）：

- $H_1:\rho \neq 0$  对应 `alternative = c("two.sided")`
- $H_1:\rho > 0$ 对应 `alternative = c("greater")`
- $H_1:\rho < 0$ 对应 `alternative = c("less")`

计算相关系数的函数 `cor()`

```R
cor(x, y = NULL, use = "everything",
    method = c("pearson", "kendall", "spearman"))
```

- `method` ：选择三个相关系数之一
- `use` ：可选 `"everything"`, `"all.obs"`, `"complete.obs"`, `"na.or.complete"`, or `"pairwise.complete.obs"`

例如：

```R
X <- c(7.7, 8.2, 7.8, 6.9, 8.4, 8.1, 7.1, 7.5, 7.6, 7.6, 7.9, 7.6, 7.5, 7.6, 7.6)
Y <- c(7.2, 6.7, 5.7, 4.0, 5.7, 6.4, 4.5, 5.5, NA, 5.4, 6.1, 6.9, 3.9, 5.7, 3.7)

cor(X, Y, use = "na.or.complete", method = "pearson")  # 0.5801752

cor.test(X, Y, method = "pearson")
```

```R

        Pearson's product-moment correlation

data:  X and Y
t = 2.4675, df = 12, p-value = 0.02963
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 0.07165242 0.84931184
sample estimates:
      cor 
0.5801752 
```

> X, Y 存在相同数字，考虑次序的 "kendall", "spearman" 无法给出精确值。



























