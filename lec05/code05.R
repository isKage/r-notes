getwd()
setwd("./lec05")
rm(list = ls())

# 时间
date()
Sys.Date()
Sys.time()

date1 <- as.Date("2025-03-25")
mode(date1)
class(date1)
date2 <- as.Date("2025/03/25")
mode(date2)
class(date2)

unclass(as.Date("2025/03/25"))
unclass(as.Date("1970/01/01"))
unclass(as.Date("1969/12/31"))

as.Date("10/24/08", format = "%m/%d/%y")
as.Date("October-24-2008", format = "%B-%d-%Y")

T1 <- as.Date("October-24-2008", format = "%B-%d-%Y")
T2 <- as.Date("October-28-2008", format = "%B-%d-%Y")
time_diff <- T2 - T1
print(time_diff) # Time difference of 4 days
class(time_diff) # "difftime"
mode(time_diff) # "numeric"

datestring <- c("10 7, 2015 10:40", "10 9, 2011 9:10")
x <- strptime(datestring, "%m %d, %Y %H:%M")
print(x)

class(x)

time_ct <- as.POSIXct("2023-10-05 14:30:00")
print(time_ct)

time_lt <- as.POSIXlt("2023-10-05 14:30:00")
print(time_lt)
print(time_lt$wday) # 星期几（0=周日，1=周一，...）
print(time_lt$yday) # 一年中的第几天（0-365）
print(time_lt$mon) # 月份（0-11，0=1月，1=2月，...）

# 从 POSIXct 转换为 POSIXlt
time_lt <- as.POSIXlt(time_ct)
print(time_lt)

# 从 POSIXlt 转换为 POSIXct
time_ct <- as.POSIXct(time_lt)
print(time_ct)

as.POSIXct("2023-10-05 14:30:00", tz = "UTC")


# 获取当前时间
x <- Sys.time()
print(x) # 输出当前时间

# 查看时间类型
class(x) # 输出: "POSIXct" "POSIXt"

# 转换为 POSIXlt 类
tempx <- as.POSIXlt(x)
print(tempx) # 输出转换后的时间

# 解构 POSIXlt 对象
unclass(tempx) # 查看内部结构

# 提取秒数
seconds <- tempx$sec
print(seconds) # 输出秒数（可能包含小数部分）

# 定义两个日期
x <- as.Date("2012-03-01")
y <- as.Date("2012-02-28")

# 计算日期差
time_diff <- x - y
print(time_diff) # 输出: Time difference of 2 days

# 比较日期
is_later <- x > y
print(is_later) # 输出: TRUE
