# R 语言基本介绍

本文介绍如何下载 R 语言和软件 RStudio 以及 R 语言的基本语法、R 的程序包、R 的对象。具体介绍了如何下载包、管理包、加载包和删除包，以及对象的命名和删除方法，和对象的属性和类别。

## 1 下载安装 R
官网地址 [https://cran.r-project.org/](https://cran.r-project.org/)

> 不可含有中文路径



## 2 安装 RStudio

官网地址 [https://posit.co/downloads/](https://posit.co/downloads/)

![](https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/QQ_1740033669420.png)



## 3 基本语法

### 3.1 常见符号

- `>` ：命令或运算提示符
- `+` ：续行符
- 多条语句之间用 `;` 或者回车符分隔
- 多个语句可以用 `{}` 组合
- 以 `#` 开始为注释部分
- 向上，向下键可以浏览以前输入过的命令
- 赋值符：`=` `<-`  `->`

赋值符号例：下面三个等价

```R
c(58, 105, 88, 118, 117, 137, 157, 169, 149, 202) -> sales;
sales <- c(58, 105, 88, 118, 117, 137, 157, 169, 149, 202);
sales = c(58, 105, 88, 118, 117, 137, 157, 169, 149, 202);
```



### 3.2 帮助文档

- 查看**函数**的帮助文档

`help(func)` 或者 `?func` 从而打开帮助文档。

- 查看**运算符和关键字**的帮助文档

`help('')` 或者 `?''` 从而打开帮助文档，但要使用引号。

```R
help(cor);
?cor;

help("+");
?'+';
```

![](https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/QQ_1740033121414.png)

- Description ：函数的描述
- Usage ：函数的具体形式/格式
- Arguments ：函数的输入参数
- Value ： 输出值
- Examples ：【使用样例】



### 3.3 工作目录

**工作目录** ：读取外部文件和保存结果到外部文件的默认目录。使用 `getwd()` 查看和 `setwd()` 设置。例如：

```R
> getwd();
[1] "/Users/username"

> setwd("/Users/username/Desktop/code/r/r-notes");

> getwd();
[1] "/Users/username/Desktop/code/r/r-notes"
```



### 3.4 工作空间

#### 3.4.1 工作空间

**工作空间**是 R 语言中当前会话的环境，它包含了所有用户定义的变量、函数、数据框、列表等对象。

- 查看工作空间：可以使用`ls()`函数查看当前工作空间中的所有对象。

```R
ls();
```
- 删除对象：可以使用`rm()`函数从工作空间中删除对象。
```R
rm();
```
- 清空工作空间：可以使用`rm(list = ls())`清空所有对象。
```R
rm(list = ls())
```

#### 3.4.2 .RData 文件

`.RData` 文件是 R 语言中用于保存和加载工作空间的文件格式。

- 保存工作空间：使用 `save.image()` 函数可以将当前工作空间保存到 `.RData` 文件中。
```R
save.image("my_workspace.RData")
```
  默认情况下，R 会将工作空间保存到名为 `.RData` 的文件中。
```R
save.image()  # 保存到默认的 .RData 文件
```

- 加载工作空间：使用 `load()` 函数可以从 `.RData` 文件中加载保存的工作空间。
```R
load("my_workspace.RData")
```
加载后，工作空间中的所有对象会恢复到当前会话中。

- 选择性保存：可以使用 `save()` 函数选择性地保存特定对象到 `.RData` 文件中。
```R
save(object1, object2, file = "my_data.RData")
```

#### 3.4.3 示例

```R
# 创建一些对象
x <- c(1, 2, 3)
y <- rnorm(10)

# 查看工作空间
ls()

# 保存工作空间到文件
save.image("my_workspace.RData")

# 删除工作空间中的对象
rm(x, y, df)

# 加载工作空间
load("my_workspace.RData")

# 再次查看工作空间
ls()
```



## 4 R 的程序包 Packages

R程序包是多个函数的集合，具有详细的说明和示例。每个程序包包括R函数，数据，帮助文件，描述文件等。

### 4.1 R 程序包分类

R 包可以分为以下几类：

- 基础包：随R安装自带的包
- 推荐包：通常随R一起安装，但不是核心包
- 第三方包：由社区或开发者贡献的包，需要通过CRAN、GitHub等平台安装

### 4.2 安装 R 包
#### 4.2.1 从 CRAN 安装
CRAN 是 R 包的官方仓库。使用 `install.packages()` 函数安装
```R
install.packages("dplyr")  # 安装dplyr包
```

#### 4.2.2 从 GitHub 安装
一些开发者会将包发布在 GitHub 上，可以使用 `devtools` 包安装：
```R
install.packages("devtools")  # 安装 devtools 包

devtools::install_github("tidyverse/dplyr")  # 从 GitHub 安装 dplyr
```

#### 4.2.3 本地安装

从 CRAN 上下载 `.zip` 文件，然后在 RStudio 中选择：【Tools】->【Install Packages ...】->【Install from】后选择下载的 `.zip` 文件。

<img src="https://blog-iskage.oss-cn-hangzhou.aliyuncs.com/images/QQ_1740035683185.png" style="zoom:50%;" />

### 4.3 加载和使用 R 包
安装包后，需要使用 `library()` 或 `require()` 函数加载包
```R
library(dplyr)  # 加载dplyr包
require(ggplot2)  # 加载ggplot2包
```

> - `library()`：加载包，如果包未安装会报错。
> - `require()`：尝试加载包，如果包未安装会返回`FALSE`，但不会报错。

- 查看所有已安装的包：
```R
installed.packages()
```
- 查看当前加载的包：
```R
search()
```

- 更新已安装的包：

```R
update.packages()
```

### 4.4 卸载 R 包
使用 `remove.packages()` 函数卸载包
```R
remove.packages("dplyr")
```



## 5 R 的对象 Objects

在 R 中，所有的数据集、函数、函数结果等，均统称为 "对象"（Object）

### 5.1 对象的命名

- 区分大小写
- 由 `A-Z` `a-z` `0-9` `_` `.` 组成名字
- 对象名要以字母或者 `.` 开始
- 如果以 `.` 开头，后面不能跟数字
- 尽量避免使用保留名

### 5.2 查看与移除对象

- 使用 `ls()` 查看当前所有对象

```R
ls()  # 查看当前工作空间所有对象

ls(pat = "m")  # 名字包含 m 的所有对象
ls(pat = "^m")  # 名字以 m 开头的所有对象
ls.str()  # 展示所有对象的详细信息
```

- 使用 `rm()` 删除对象

```R
rm()  # 可以填入对象名

rm(list = c("x", "y"))  # 删除对象 x 和 y
rm(list = ls())  # 删除所有对象
```

> 【推荐】在每个脚本文件 `.R` 都在文件开始设置工作路径和清空对象

```R
setwd("");  # 填入路径
rm(list = ls());
```

### 5.3 对象的属性 Attribute 与类别  Class

#### 5.3.1 使用 `mode()` 判断对象的属性

```R
> x <- 1;
> mode(x)
[1] "numeric"

> is.integer(x)
[1] FALSE

> is.numeric(x)
[1] TRUE

> y <- is.numeric(x)
> mode(y)
[1] "logical"
```

或者使用 `is.numeric(); is.logical(); is.character; is.complex()` 进行判断。

#### 5.3.2 使用 `class()` 判断对象的类别

常见的类型：

- 向量 vector
- 矩阵 matrix
- 数组 array
- 数据框 dataframe
- 列表 list













