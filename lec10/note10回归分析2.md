# 回归分析：多元线性回归

本章介绍多元线性回归的 R 语言实现，包括模型搭建、变量选择、多重共线性和模型预测和诊断。

## 1 多元线性回归模型

### 1.1 模型

**模型：**
$$
y_i = \beta_0 + \beta_1\cdot x_{i1} + \cdots + \beta_p \cdot x_{ip} + \epsilon_i,\quad i = 1,\ 2,\ \cdots,\ n
$$
**误差项的假设：**
$$
\epsilon_i \sim_{i.i.d} N(0,\ \sigma^2)
$$
**拟合值：**
$$
\hat{y_i} = \hat{\beta_0} + \hat{\beta_1}\cdot x_{i1} + \cdots + \hat{\beta_p} \cdot x_{ip},\quad i = 1,\ 2,\ \cdots,\ n
$$
使用**最小二乘法：**
$$
\min_{\beta_j}\ \sum\limits_{i=1}^n\ (y_i - \hat{y_i})^2,\quad j = 0,\ 1,\ \cdots,\ p
$$

### 1.2 R 语言实现

数据准备：

```R
Y <- c(101.8, 44.4, 108.3, 85.1, 77.1, 158.7, 180.4, 64.2, 74.6, 143.4, 120.6, 69.7, 67.8, 106.7, 119.6) # nolint
X1 <- c(1.3, 0.7, 1.4, 0.5, 0.5, 1.9, 1.2, 0.4, 0.6, 1.3, 1.6, 1.0, 0.8, 0.6, 1.1) # nolint
X2 <- c(0.2, 0.2, 0.3, 0.4, 0.6, 0.4, 1.0, 0.4, 0.5, 0.6, 0.8, 0.3, 0.2, 0.5, 0.3) # nolint
X3 <- c(20.4, 30.5, 24.6, 19.6, 25.5, 21.7, 6.8, 12.6, 31.3, 18.6, 19.9, 25.6, 27.4, 24.3, 13.7) # nolint
CountryKitchen <- data.frame(Sales = Y, Advertisement = X1, Promotion = X2, Competitor = X3) # nolint
```

```R
> # 数据的相关性
> cor(CountryKitchen)
> plot(CountryKitchen) # 绘图
                   Sales Advertisement  Promotion Competitor
Sales          1.0000000     0.7076926  0.6123033 -0.6248346
Advertisement  0.7076926     1.0000000  0.1613351 -0.2131088
Promotion      0.6123033     0.1613351  1.0000000 -0.4939321
Competitor    -0.6248346    -0.2131088 -0.4939321  1.0000000
```

![](https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/cor_plot.png)

回归分析：（4 种方法）

```R
# 回归分析
## method 1
result1 <- lm(Y ~ X1 + X2 + X3)
summary(result1)

## method 2
X <- cbind(X1, X2, X3)
result2 <- lm(Y ~ X)
summary(result2)

## method 3
result3 <- lm(Sales ~ Advertisement + Promotion + Competitor, data = CountryKitchen) # nolint
summary(result3)

## method 4
result4 <- lm(Sales ~ ., data = CountryKitchen)
summary(result4)
```

最终结果：

```R

Call:
lm(formula = Sales ~ Advertisement + Promotion + Competitor, 
    data = CountryKitchen)

Residuals:
    Min      1Q  Median      3Q     Max 
-34.625  -6.750   1.335   8.030  26.435 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)    65.7046    27.7311   2.369 0.037195 *  
Advertisement  48.9788    10.6579   4.596 0.000771 ***
Promotion      59.6543    23.6247   2.525 0.028219 *  
Competitor     -1.8376     0.8138  -2.258 0.045233 *  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 17.6 on 11 degrees of freedom
Multiple R-squared:  0.833,     Adjusted R-squared:  0.7875 
F-statistic: 18.29 on 3 and 11 DF,  p-value: 0.0001388
```

### 1.3 R 结果分析

**参数估计：** `Residual standard error: 17.6` 代表了
$$
\hat{\sigma} = 17.6
$$
**参数估计：** `Estimate` 代表了
$$
\begin{align}
\hat{\beta_0} &= 65.7046 \\
\hat{\beta_1} &= 48.9788 \\
\hat{\beta_2} &= 59.6543 \\
\hat{\beta_3} &= -1.8376 \\
\end{align}
$$
**显著性检验：** `Signif. codes` 和 `Pr(>|t|)`
$$
\frac{\hat{\beta_j} - \beta_j}{\hat{\sigma}_j} \sim t\ (n-p-1)
$$

```R
Advertisement: Pr(>|t|) = 0.000771 *** 显著
```

针对的假设检验：
$$
H_0: \beta_j = 0\quad vs\quad H_1: \beta_j \neq 0
$$
**模型显著性检查：** 

```R
F-statistic: 18.29 on 3 and 11 DF,  p-value: 0.0001388
# =====
所以 p-value: 0.0001388 < 0.05 拒绝原假设，模型显著
```

针对的假设检验：
$$
H_0: \beta_1 = \beta_2 =\cdots = \beta_p = 0\quad vs\quad H_1: \text{至少存在一个 } \beta_j \neq 0
$$


## 2 R 方和调整 R 方

模型中可能会存在无意义的变量，这回增加模型的复杂度，却不会显著提高模型表现。此时，定义调整 R 方，从而平衡模型表现和模型复杂度的衡量。

### 2.1 增加变量后的回归分析

例如：向上面的例子增加一个无关的变量 `Snow` 

```R
CountryKitchen$Snow <- c(24, 31, 31, 36, 18, 42, 50, 49, 60, 62, 42, 58, 55, 79, 88) # nolint
pairs(CountryKitchen, main = "pairs(dataname)") # 绘图
```

```R
> cor(CountryKitchen)
                   Sales Advertisement   Promotion Competitor        Snow
Sales          1.0000000    0.70769256  0.61230329 -0.6248346  0.19521113
Advertisement  0.7076926    1.00000000  0.16133514 -0.2131088 -0.06041495
Promotion      0.6123033    0.16133514  1.00000000 -0.4939321  0.05054504
Competitor    -0.6248346   -0.21310879 -0.49393215  1.0000000 -0.20264187
Snow           0.1952111   -0.06041495  0.05054504 -0.2026419  1.00000000
```

注意到 `Snow` 与响应变量 `Sales` 关系较小 `cor = 0.1952111` 。

![](https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/cor_pairs.png)

此时进行线性回归：

```R
result5 <- lm(Sales ~ ., data = CountryKitchen)
summary(result5)
```

```R

Call:
lm(formula = Sales ~ ., data = CountryKitchen)

Residuals:
    Min      1Q  Median      3Q     Max 
-33.706  -5.189   5.557   9.343  16.964 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)    44.2094    32.0045   1.381 0.197254    
Advertisement  50.3533    10.4476   4.820 0.000703 ***
Promotion      61.1433    23.0614   2.651 0.024258 *  
Competitor     -1.6146     0.8130  -1.986 0.075105 .  
Snow            0.3035     0.2419   1.255 0.238081    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 17.16 on 10 degrees of freedom
Multiple R-squared:  0.8557,    Adjusted R-squared:  0.798 
F-statistic: 14.83 on 4 and 10 DF,  p-value: 0.00033
```

### 2.2 R 方与调整 R 方

R-squared 从 0.833 增加到 0.856 ：

- 基于 R-squared ，第二个模型似乎比第一个模型更好

- 但是从直观上来看 Snow 与年销售额 Sales 无关，并不应该将其放入模型中

**R-squared 总是随着新的自变量不断进入模型而增加，哪怕该自变量与应变量几乎没有关系。**

为了修正这种影响，引入调整 R 方：
$$
R^2_a = 1 - (1 - R^2)(\frac{n-1}{n-p-1})
$$

- $R^2_a$  $R_a^2$ 的增加量比 $R^2$ 的增加量小，这是因为前者考虑了模型中自变量 x 的个数

- 然而在这个例子中，即便是基于 $R_a^2$ 进行判断，仍会将与应变量几乎无关的自变量引入模型，修正判定系数只是一种修正的方法，未必在任何情况下都有效
- 为了衡量模型中每个自变量是否确实与应变量有关，一种更正规和有效的方法是对回归系数进行显著性检验：

```R
              Estimate Std. Error t value Pr(>|t|)    
Snow            0.3035     0.2419   1.255 0.238081    
```

由 `Pr(>|t|) = 0.23 > 0.05` 故接受 $H_0: \beta_{snow} = 0$ ，即不显著。



## 3 多重共线性

**多重共线性：**自变量之间存在高度线性相关性。

### 3.1 多重共线性的例子

例：变量 `GPA` 和 `GMAT` 去拟合 `salary`

```R
# 多重共线性
salary <- c(
    100000, 100000, 77500, 77500, 75000,
    87500, 77500, 87500, 77500, 90000,
    95000, 65000, 72500, 82500, 100000,
    97500, 68500, 85000, 88500, 100000,
    77500, 92500, 92500, 97500, 95000
)
GPA <- c(
    3.9, 3.9, 3.1, 3.2, 3.0,
    3.5, 3.0, 3.5, 3.2, 3.6,
    3.7, 2.9, 3.4, 3.4, 4.0,
    3.8, 2.8, 3.5, 3.6, 3.9,
    3.1, 3.7, 3.7, 4.0, 3.8
)
GMAT <- c(
    640, 644, 557, 550, 547,
    589, 533, 600, 630, 633,
    642, 522, 628, 583, 650,
    641, 530, 596, 605, 656,
    574, 636, 635, 654, 633
)
```

```R
result6 <- lm(salary ~ GPA + GMAT)
summary(result6)
```

```R

Call:
lm(formula = salary ~ GPA + GMAT)

Residuals:
     Min       1Q   Median       3Q      Max 
-10027.3  -1508.7    549.5   1831.0   4103.3 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept) -2507.37   10440.28  -0.240    0.812    
GPA         32650.32    4458.95   7.322 2.48e-07 ***
GMAT          -41.36      37.32  -1.108    0.280    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 3201 on 22 degrees of freedom
Multiple R-squared:  0.9178,    Adjusted R-squared:  0.9104 
F-statistic: 122.9 on 2 and 22 DF,  p-value: 1.151e-12
```

注意到：`Multiple R-squared:  0.9178,    Adjusted R-squared:  0.9104 ` 所以模型整体表现良好，但是

```R
            Estimate Std. Error t value Pr(>|t|)    
GMAT          -41.36      37.32  -1.108    0.280    
```

说明 `GMAT` 表现不显著，且系数为负，不符合常识。这可能的原因就是 `GMAT` 与 `GPA` 之间存在高度线性相关性，即多重共线性。

注意到：

```R
> cor(GPA, GMAT)
[1] 0.9150276
```

所以二者存在极高的线性关系。可以删去不显著的 `GMAT` 重新线性回归：

```R
result7 <- lm(salary ~ GPA)
summary(result7)
```

### 3.2 多次共线性的判断

**多重共线性：**自变量线性相关，即
$$
\exist\ c_j \neq 0\quad s.t.\ c_1X_1 + c_2X_2 + \cdots + c_pX_p = c_0
$$
**判断方法：**

1. 直接比较自变量 X 两两之间的线性相关系数
2. 计算 $X^T X$ 的 Kappa 值，其中 $X = (X_1,\ X_2,\ \cdots,\ X_p) \in R^{n \times p}$ 

$$
Kappa(X^T X) = \frac{\max\ \lambda_{X^T X}}{\min\ \lambda_{X^T X}}
$$

其中 $\lambda_{X^T X}$ 代表特征根。这是因为，若多重共线性，则 $X^T X$ 几乎不可逆。

经验判断：当 Kappa > 1000 则认为有严重的多重共线性；当 100 < Kappa < 1000 认为有中等严重的多重共线性；当 Kappa < 100 则认为多重共线性较弱。

**例如：**

```R
X <- cbind(GPA, GMAT)
kappa(t(X) %*% X)
# 13666179 >> 1000
```



## 4 模型选择

在回归模型中引入过多自变量可能会引起严重的问题，因此在所有可能的自变量中，应只选择一些与因变量“最有关”的进行建模，这就是**变量选择**问题。

### 4.1 模型选择例子

例：载入数据

```R
cement <- data.frame(
    X1 = c(
        7, 1, 11, 11, 7, 11, 3, 1,
        2, 21, 1, 11, 10
    ),
    X2 = c(
        26, 29, 56, 31, 52, 55, 71,
        31, 54, 47, 40, 66, 68
    ),
    X3 = c(
        6, 15, 8, 8, 6, 9, 17, 22,
        18, 4, 23, 9, 8
    ),
    X4 = c(
        60, 52, 20, 47, 33, 22, 6,
        44, 22, 26, 34, 12, 12
    ),
    Y = c(
        78.5, 74.3, 104.3, 87.6,
        95.9, 109.2, 102.7, 72.5,
        93.1, 115.9, 83.8, 113.3,
        109.4
    )
)
```

全变量回归：

```R
result8 <- lm(Y ~ X1 + X2 + X3 + X4, data = cement)
summary(result8)
```

```R

Call:
lm(formula = Y ~ X1 + X2 + X3 + X4, data = cement)

Residuals:
    Min      1Q  Median      3Q     Max 
-3.1750 -1.6709  0.2508  1.3783  3.9254 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)  
(Intercept)  62.4054    70.0710   0.891   0.3991  
X1            1.5511     0.7448   2.083   0.0708 .
X2            0.5102     0.7238   0.705   0.5009  
X3            0.1019     0.7547   0.135   0.8959  
X4           -0.1441     0.7091  -0.203   0.8441  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 2.446 on 8 degrees of freedom
Multiple R-squared:  0.9824,    Adjusted R-squared:  0.9736 
F-statistic: 111.5 on 4 and 8 DF,  p-value: 4.756e-07
```

注意到，所有系数的 p 值均大于 0.05 ，即都不显著，但模型整体 $R^2$ 表现良好。故下面检查多重共线性：

```R
X.cement <- as.matrix(cement[, 1:4])
kappa(t(X.cement) %*% X.cement)
# 548.3885 > 100
```

故，存在着较强的多重共线性，检查相关系数：

```R
> cor(X.cement)
           X1         X2         X3         X4
X1  1.0000000  0.2285795 -0.8241338 -0.2454451
X2  0.2285795  1.0000000 -0.1392424 -0.9729550
X3 -0.8241338 -0.1392424  1.0000000  0.0295370  # cor(X1, X3) = -0.82
X4 -0.2454451 -0.9729550  0.0295370  1.0000000  # cor(X2, X4) = -0.97
```

考虑去除 X3 和 去除 X3 、X4

```R
result9 <- lm(Y ~ X1 + X2 + X4, data = cement)
summary(result9)

result10 <- lm(Y ~ X1 + X2, data = cement)
summary(result10)
```

```R
> summary(result10)

Call:
lm(formula = Y ~ X1 + X2, data = cement)

Residuals:
   Min     1Q Median     3Q    Max 
-2.893 -1.574 -1.302  1.363  4.048 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept) 52.57735    2.28617   23.00 5.46e-10 ***
X1           1.46831    0.12130   12.11 2.69e-07 ***
X2           0.66225    0.04585   14.44 5.03e-08 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 2.406 on 10 degrees of freedom
Multiple R-squared:  0.9787,    Adjusted R-squared:  0.9744 
F-statistic: 229.5 on 2 and 10 DF,  p-value: 4.407e-09
```

### 4.2 模型选择方法

**向后选择法(backward)：**假设总共有 p 个可能的自变量，用所有的 p 个自变量拟合一个多元回归模型；如果其中有一些自变量系数估计值的 p-value 大于 0.05 ，则找出其中 p-value 最大的自变量剔除出模型，用余下的 p - 1 个自变量拟合多元回归模型；重复直至基于 p-value 没有自变量可以从回归模型中可以被剔除。

**向后选择法(backward)：**与向后选择法相反，不断加入新的变量。

**逐步回归：**类似于穷举，即将不同的变量都进行尝试，然后基于一些指标，找到最优的模型选择变量组合。

基于某个指标，这个指标被称为 **AIC** ，AIC 越小越好，一般而言，$AIC = -2\log(f(x)) + 2p$ 其中 f 为联合密度函数，而 p 为变量个数。

### 4.3 R 语言实现模型选择

```R
result8 <- lm(Y ~ X1 + X2 + X3 + X4, data = cement)
lm.step <- step(result8, direction = "back") # 向后选择
```

向后选择的结果（AIC）

```R
Start:  AIC=26.94
Y ~ X1 + X2 + X3 + X4

       Df Sum of Sq    RSS    AIC
- X3    1    0.1091 47.973 24.974
- X4    1    0.2470 48.111 25.011
- X2    1    2.9725 50.836 25.728
<none>              47.864 26.944
- X1    1   25.9509 73.815 30.576

Step:  AIC=24.97
Y ~ X1 + X2 + X4

       Df Sum of Sq    RSS    AIC
<none>               47.97 24.974
- X4    1      9.93  57.90 25.420
- X2    1     26.79  74.76 28.742
- X1    1    820.91 868.88 60.629
```

结果：选择 `X1, X2, X4`

```R
summary(lm.step)
```

```R

Call:
lm(formula = Y ~ X1 + X2 + X4, data = cement)

Residuals:
    Min      1Q  Median      3Q     Max 
-3.0919 -1.8016  0.2562  1.2818  3.8982 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  71.6483    14.1424   5.066 0.000675 ***
X1            1.4519     0.1170  12.410 5.78e-07 ***
X2            0.4161     0.1856   2.242 0.051687 .  
X4           -0.2365     0.1733  -1.365 0.205395    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 2.309 on 9 degrees of freedom
Multiple R-squared:  0.9823,    Adjusted R-squared:  0.9764 
F-statistic: 166.8 on 3 and 9 DF,  p-value: 3.323e-08
```

或者使用 `step()` 函数：

```R
step(result8, direction = "back")
```

```R
Start:  AIC=26.94					# 初始 AIC
Y ~ X1 + X2 + X3 + X4

# RSS 残差平方和 sum(ei^2) = sum((yi - yi_hat)^2)
       Df Sum of Sq    RSS    AIC
- X3    1    0.1091 47.973 24.974  	# 删除 X3
- X4    1    0.2470 48.111 25.011  	# 删除 X4
- X2    1    2.9725 50.836 25.728  	# 删除 X2
<none>              47.864 26.944  	# 不删
- X1    1   25.9509 73.815 30.576  	# 删除 X1

Step:  AIC=24.97  					# 上一步最小的 AIC -> 删除 X3
Y ~ X1 + X2 + X4

       Df Sum of Sq    RSS    AIC
<none>               47.97 24.974
- X4    1      9.93  57.90 25.420
- X2    1     26.79  74.76 28.742
- X1    1    820.91 868.88 60.629
# 删除任意一个 AIC 都会变大，故结束

Call:
lm(formula = Y ~ X1 + X2 + X4, data = cement)

Coefficients:
(Intercept)           X1           X2           X4  
    71.6483       1.4519       0.4161      -0.2365  
```

强制删去一个变量，使用函数 `drop1()`

```R
drop1(lm.step)
```

```R
Single term deletions

Model:
Y ~ X1 + X2 + X4
       Df Sum of Sq    RSS    AIC
<none>               47.97 24.974
X1      1    820.91 868.88 60.629
X2      1     26.79  74.76 28.742
X4      1      9.93  57.90 25.420
```

## 5 回归分析：预测、诊断

### 5.1 预测

对于新数据，进行预测：
$$
y^* = \hat{\beta_0} + \hat{\beta_1}x^*_1 + \cdots + \hat{\beta_p}x^*_p
$$
多个数据同样可以预测，使用 R 语言实现：

```R
newdata <- data.frame(
    Advertisement = c(1.2, 1, 1.4),
    Promotion = c(0.5, 0.6, 0.7),
    Competitor = c(25, 10, 8)
)

# 点估计
predict(result3, new = newdata)
       1        2        3 
108.3655 132.0996 161.3318 

# 区间估计
predict(result3, new = newdata, interval = "prediction")
       fit       lwr      upr
1 108.3655  67.19011 149.5408
2 132.0996  88.15866 176.0406
3 161.3318 115.96753 206.6961
```

### 5.2 诊断

我们需要诊断模型假设的成立性，多元线性回归模型的假设包括

- 随机误差相互独立（独立性）
- 随机误差均值为 0 ，并且有相同的标准差（同方差性）
- 随机误差服从正态分布

这些检验均有误差的估计残差来判断：
$$
\hat{\epsilon_i} = e_i = y_i - \hat{y_i}
$$

#### 5.2.1 同方差性

检测同方差性：画出残差（纵轴）对单个自变量或拟合因变量（横轴）的散点图，从图中观察残差对于单个自变量或拟合应变量的取值是否呈现出（函数形式的）趋势。

#### 5.2.2 随机误差的正态分布检验

随机误差的正态性假设可以用残差的直方图或 Q-Q 图来进行检测。

#### 5.2.3 随机误差独立（自相关性）

自相关性：是一种常见的违反独立性的现象，当样本观测是以某种自然序列（如时间）被记录时，可能出现自相关性。将残差按自然序列作图并检测趋势。

上面的检验图像的绘制，可以使用 R 语言简单地作出：

```R
# 诊断
png("img/ei.png", width = 1200, height = 1200, res = 200)
op <- par(mfrow = c(2, 2))
plot(result3, 1:4)
dev.off()
par(op)
```

![](https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/ei.png)
