# 回归分析：简单线性回归

本章介绍回顾分析的原理，从单变量的简单线性回归为入门，介绍相关理论。利用 R 语言实现线性回归模型的分析。

## 1 模型搭建

**简单线性回归模型：**
$$
y_i = \beta_0 + \beta_1 \cdot x_i + \epsilon_i,\quad i = 1,\ 2,\ \cdots,\ n
$$

- 模型中核心部分 $\beta_0 + \beta_1 \cdot x_i$ 称为系统性因素，指的是本质的，重要的，不可忽略的那些因素。

- 模型中非系统性因素 $\epsilon_i$ 称为非系统性因素，指的是相对来说非本质的，不重要的，可忽略的那些因素。

因为自变量只有一个，且模型是线性的，因此我们把该模型称为**简单线性回归模型**。

**随机误差：**
$$
\epsilon_i \sim N(0,\ \sigma^2)
$$
这里 $\epsilon_i $ 代表了系统性因素以外的影响，即非系统性因素，同时它们之间相互独立，且与 $x_i$ 无关。注意：一般假设 $\epsilon_i$ 服从正态分布。

**系统因素：**
$$
E(Y_i\ |\ x_i) = \beta_0 + \beta_1 \cdot x_i
$$
这是因为 $\epsilon_i \sim N(0,\ \sigma^2)$ 故 $E(\epsilon_i) = 0$ ，我们关心的是给定 x 之后对应的 Y 的期望，即这里的 $E(Y_i\ |\ x_i)$ 。特别地，由于 $\beta_0,\ \beta_1,\ x_i$ 为常数，所以 $var(y_i) = 0 + var(\epsilon_i) = \sigma^2$ 称为信噪比。

## 2 参数估计

### 2.1 参数估计

首先，明确需要估计的参数：
$$
\beta_0 \quad \beta_1 \quad \sigma^2
$$
目标：找到一条直线，使得所有观测值到直线的距离平方和最短，即误差最小
$$
\hat{y_i} = \hat{\beta_0} + \hat{\beta_1} \cdot x_i
$$

$$
\min_{\beta_0,\ \beta_1}\ \sum\limits_{i = 1}^n \ (y_i - \hat{y_i})^2 = \sum\limits_{i=1}^n \ (y_i - (\beta_0 + \beta_1 \cdot x_i))^2
$$

使用**最小二乘法**可以得到参数的估计值为：
$$
\hat{\beta_1} = \frac{\sum\limits_{i=1}^n\ (x_i - \bar{x})(y_i - \bar{y})}{\sum\limits_{i=1}^n \ (x_i - \bar{x})^2}
$$

$$
\hat{\beta_0} = \bar{y} - \bar{x} \cdot \hat{\beta_1}
$$

其他估计值：

- **拟合值估计：** $\hat{y} = \hat{\beta_0} + \hat{\beta_1} \cdot x_i$
- **方差估计：** $\hat{\sigma^2} = s^2 = \frac{1}{n-2}\sum_{i=1}^n (y_i - \hat{y_i})^2$
- **误差的估计（残差）：** $e_i = y_i - \hat{y_i}$

### 2.3 R 语言实现：lm 函数

使用 `lm()` 函数直接实现简单线性回归：

```R
# simple regression
student <- c(2, 6, 8, 8, 12, 16, 20, 20, 22, 26)
sales <- c(58, 105, 88, 118, 117, 137, 157, 169, 149, 202)

result <- lm(sales ~ student)  # sales 是 yi 因变量；而 student 是 xi 自变量

summary(result)
```

结果为：

```R
> summary(result)

Call:
lm(formula = sales ~ student)

Residuals:
   Min     1Q Median     3Q    Max 
-21.00  -9.75  -3.00  11.25  18.00 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  60.0000     9.2260   6.503 0.000187 ***
student       5.0000     0.5803   8.617 2.55e-05 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 13.83 on 8 degrees of freedom
Multiple R-squared:  0.9027,    Adjusted R-squared:  0.8906 
F-statistic: 74.25 on 1 and 8 DF,  p-value: 2.549e-05
```

**1. $\beta$ 的估计值：** `Intercept` 的第一列表示 $\hat{\beta_0}$ 为 `60.0000` 。而下一个即为 $\hat{\beta_1}$ 为 `5.0000` 。

```R
Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  60.0000     9.2260   6.503 0.000187 ***
student       5.0000     0.5803   8.617 2.55e-05 ***
```

**2. 方差 $\hat{\sigma} = s$ 的估计：** `Residual standard error` 展示了方差的估计 `s = 13.83` 。

```R
Residual standard error: 13.83 on 8 degrees of freedom
```

**3. 查看相关变量：**可以使用 `names()` 函数查看结果的变量名，然后使用 `result$xx` 的方式取得 `result` 的 `xx` 变量数据。

```R
> names(result)
 [1] "coefficients"  "residuals"     "effects"       "rank"         
 [5] "fitted.values" "assign"        "qr"            "df.residual"  
 [9] "xlevels"       "call"          "terms"         "model"        
> names(summary(result))
 [1] "call"          "terms"         "residuals"     "coefficients" 
 [5] "aliased"       "sigma"         "df"            "r.squared"    
 [9] "adj.r.squared" "fstatistic"    "cov.unscaled" 
```

```R
> result$coefficients
(Intercept)     student 
         60           5 
```

## 3 模型评估

### 3.1 模型总体评估

**总平方误差（Total Sum of Squares，SST）：**
$$
SST = \sum\limits_{i=1}^n (y_i - \bar{y})^2
$$
**残差平方和（Sum of Squares due to Error，SSE）：**
$$
SSE = \sum\limits_{i=1}^n (y_i - \hat{y_i})^2
$$
**回归平方和（Sum of Squares due to Regression，SSR）：**
$$
SSR = \sum\limits_{i=1}^n (\hat{y_i} - \bar{y})^2
$$
这三个指标满足下面的等式：
$$
SST = SSR + SSE
$$
**模型总体评估：$R^2$**
$$
R^2 = \frac{SSR}{SST}
$$
从直觉上判断，当 $R^2$ 越大（越接近 1），说明模型的误差对真实误差的占比更高，模型解释性更强。即，我们希望模型的 $R^2$ 尽可能的接近 1 。

**从 R 语言结果中查看：**可见 `R-squared = 0.9027` 代表了 $R^2$ ，后面的 `Adjusted R-squared = 0.8906` 代表了调整 $R^2$ ，调整之后更多的反应了综合水平，加入考虑了模型过于复杂的情况（例如：当自变量 xi 过多；模型过于复杂，过拟合也是不佳的）。

```R
Multiple R-squared:  0.9027,    Adjusted R-squared:  0.8906 
```

### 3.2 模型参数的评估

进一步观察 $\hat{\beta_0},\ \hat{\beta_1}$ 的统计推断：

```R
Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  60.0000     9.2260   6.503 0.000187 ***
student       5.0000     0.5803   8.617 2.55e-05 ***
```

- `Std. Error` 代表了参数 $\beta$ 的标准差估计
- `t value` 和 `Pr(>|t|)` 代表了对与 $H_0: \beta_i = 0$ 的假设检验（特别的，这里的 p 值均小于 0.05 故大致可以认为自变量 `student` 确实对因变量 `sales` 存在线性关系）

特别地，当误差 $\epsilon_i$ 满足正态分布时，参数也满足分布：
$$
\hat{\beta_i} \sim N(\beta_i,\ \sigma_i^2)
$$
其中 $\sigma_i^2$ 未知，只能通过样本方差估计。故有：
$$
\frac{\hat{\beta_i} - \beta_i}{s_i} \sim t(n-2)
$$
特别地，简单线性回归模型是单一变量，故模型整体的假设检验也等价于 $H_0: \beta_1 = 0$ 的检验：

```R
F-statistic: 74.25 on 1 and 8 DF,  p-value: 2.549e-05
```

这里的 p 值为 `2.549e-05 < 0.05` 故拒绝原假设。

## 4 模型假设的检验

**模型假设一：** $\epsilon_i,\ i=1,\ 2,\ \cdots,\ n$ 相互独立，均值为 0 ，方差相同，且与 $x_i$ 无关。

**模型假设二：**一般假设 $\epsilon_i$ 服从正态分布

检查误差/残差的正态性和相关性：

```R
png("img/ei.png", width = 1200, height = 500, res = 150)
op <- par(mfrow = c(1, 3))

# 残差 ei 的散点分布
plot(result$residuals, main = "Residuals, ei scatters plot")

# 检查残差 ei 是否与 xi 相关（残差是误差的估计）
plot(student, result$residuals, main = "Students v.s. Residuals, xi vs ei")

# 检查残差 ei 是否近似正态（残差是误差的估计）
qqnorm(result$residuals)
qqline(result$residuals)

dev.off()
par(op)
```

![](https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/ei.png)

其他：

- A plot of residuals versus fitted (predicted) values ：类似 resid vs x 。希望没有任何趋势。

- A normal quantile-quantile plot of the standardized residuals 。希望基本成一直线。
- A scale-location plot ：类似 resid vs x 。希望没有任何趋势。
- A Cook's distance plot 库克距离：如果某一条数据被排除在外，那么由此造成的回归系数变化有多大。如果 Cook 距离过大，那么就表明这条数据对回归系数的计算产生了明显的影响，这条数据就有可能是是异常数据。如果 Cook 距离大于 0.5 ， 那么这个点就有可能是强影响点；如果 Cook 距离大于 1 ，那么这个点就非常有可能是强影响点，必须得到关注。

```R
# 其他
png("img/others.png", width = 1200, height = 1200, res = 200)
op <- par(mfrow = c(2, 2))
plot(result, which = 1:4)
dev.off()
par(op)
```

<img src="https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/others.png" style="zoom:50%;" />

## 5 拟合和预测

### 5.1 R 语言实现

`predict()` 函数实现预测，格式：

```R
predict(
    object,
    newdata,
    interval = c("none", "confidence", "prediction"), 
    level = 0.95
)
```

参数：

```R
- object: 某个线性模型，lm() 的结果。如 result1 = lm(sales ~ student)
- newdata: 某个变量名跟原来线性模型中自变量一致的数据框。如 new = data.frame(student = 10)
```

例如：

**1. 预测问题：**选择 `interval = "prediction"` 点估计相同为 `fit = 110` ，但此时给出的置信区间为预测区间 `Prediction Interval, PI` 给出的是对预测值的置信区间 `lwr, upr` 。

```R
> # 预测
> new <- data.frame(student = 10)
> predict(result, new, interval = "prediction", level = 0.95)
  fit      lwr      upr
1 110 76.12745 143.8725

> new <- data.frame(student = 18)
> predict(result, new, interval = "prediction", level = 0.95)
  fit      lwr      upr
1 150 116.1275 183.8725
```

**2. 估计问题：**选择 `interval = "confidence"` 点估计相同为 `fit = 110` ，但此时给出的置信区间为对期望 $E(y)$ 的置信区间 `Confidence Interval, CI` 是因变量期望的置信区间 `lwr, upr`  。

```R
> # 估计/拟合
> new <- data.frame(student = 10)
> predict(result, new, interval = "confidence", level = 0.95)
  fit      lwr     upr
1 110 98.58299 121.417

> new <- data.frame(student = 18)
> predict(result, new, interval = "confidence", level = 0.95)
  fit     lwr     upr
1 150 138.583 161.417
```

### 5.2 理论分析

**拟合值：**对原来的数据中 $x_0$ ，给出拟合值，包括估计水平为 0.95 的置信区间

- 真值：$E(y_0) = \beta_0 + \beta_1 \cdot x_0$
- 置信区间：$P(L \leq E(y_0) = \beta_0 + \beta_1 \cdot x_0 \leq U) = 1 - \alpha$

根据如下结论：
$$
var(\hat{y_0}) = var(\hat{\beta_0} + \hat{\beta_1}\cdot x_0) = \sigma^2(\frac{1}{n} + \frac{(x_0 - \bar{x})^2}{s_{xx}}) = sd(\hat{y})
$$

$$
(n-2)\hat{\sigma^2} \sim \sigma^2 \cdot \chi^2(n-2)
$$

$$
\frac{\hat{y_0} - (\beta_0 + \beta_1 \cdot x_0)}{\sqrt{var(\hat{y_0})}} \sim t(n-2)
$$

于是，置信区间为：
$$
CI = \left[\quad \hat{\beta_0} + \hat{\beta_1}\cdot x_0 \pm t_{\alpha/2}(n-2)\cdot\hat{\sigma}\sqrt{\frac{1}{n} + \frac{(x_0 - \bar{x})^2}{s_{xx}}}\quad \right]
$$
**预测值：**对一个新的观测值 $x' \notin \{x_i\}_{i=1,\, 2,\ \cdots,\ n}$，给出预测值，包括水平为 0.95 的预测区间

- 真实值（随机变量）：$y' = \beta_0 + \beta_1\cdot x' + \epsilon$
- 点预测：$\hat{y'} = \hat{\beta_0} + \hat{\beta_1}\cdot x'$
- 预测区间：$P(L \leq y' = \beta_0 + \beta_1\cdot x' + \epsilon \leq U) = 1 - \alpha$

根据如下结论：
$$
y' \ \bot \ y
$$

$$
y' - \hat{y'} \sim N(\beta_0 + \beta_1 \cdot x',\ \sigma^2(1 + \frac{1}{n} + \frac{(x'- \bar{x})^2}{s_{xx}}))
$$

$$
\frac{\hat{\beta_0} + \hat{\beta_1}\cdot x' - (\beta_0 + \beta_1\cdot x' + \epsilon)}{\hat{\sigma}\sqrt{1 + \frac{1}{n} + \frac{(x'- \bar{x})^2}{s_{xx}}}} \sim t(n-2)
$$

于是，预测区间为：
$$
PI = \left[\quad \hat{\beta_0} + \hat{\beta_1}\cdot x' \pm t_{\alpha/2}(n-2)\cdot \hat{\sigma}\sqrt{1 + \frac{1}{n} + \frac{(x'- \bar{x})^2}{s_{xx}}} \quad \right]
$$
**总结：**

- 拟合值的置信区间：给定自变量 x 的值时，响应变量的期望可能落入的范围，这是一个估计问题。

- 预测值的预测区间：给定自变量 x 的值时，单个响应变量可能落入的范围，这是一个预测问题。
-  预测区间 `PI` 总是要比对应的置信区间 `CI` 大。

































