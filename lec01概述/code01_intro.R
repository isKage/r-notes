# setwd("");  # 填入路径
rm(list = ls());

c(58, 105, 88, 118, 117, 137, 157, 169, 149, 202) -> sales;
sales <- c(58, 105, 88, 118, 117, 137, 157, 169, 149, 202);
sales = c(58, 105, 88, 118, 117, 137, 157, 169, 149, 202);

help(cor);
?cor;

help("+");
?'+';

getwd();

ls();

# 创建一些对象
x <- c(1, 2, 3)
y <- rnorm(10)

# 查看工作空间
ls()

# 保存工作空间到文件
save.image("my_workspace.RData")

# 删除工作空间中的对象
rm(x, y)

# 加载工作空间
load("my_workspace.RData")

# 再次查看工作空间
ls()

ls()  # 查看当前工作空间所有对象

ls(pat = "m")  # 名字包含 m 的所有对象
ls(pat = "^m")  # 名字以 m 开头的所有对象
ls.str()  # 展示所有对象的详细信息


mode(x);
mode(sales);

class(x);
class(sales);
