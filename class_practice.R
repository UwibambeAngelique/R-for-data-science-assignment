
# R for Data Science (MSDA9113): Class  practice
# Student Name: Uwibambe Angelique
#
# Topics: calculator, data structures (vector, matrix, list, factor,
# data frame), missing values, data importation, exploratory data
# analysis, graphs, linear models, data management, dates, subsetting.
#
# Data file: class_data.txt (HEIGHT and WEIGHT of 43 students) must be in
# the same folder as this script. Open the .Rproj so R finds it.



# 1. R AS A CALCULATOR

2 + 3
10 / 4
2^5
sqrt(16)

# 2. VECTORS: the foundational R data structure

# ---- Numeric ----
x   <- c(0.5, 0.6)
age <- c(20, 35, 32, 29)
summary(age)              # min, quartiles, median, mean, max

age <- c(35, 24, 18, 24)
mean(age)                 # 25.25

# ---- Logical ----
x <- c(TRUE, FALSE)
x <- c(T, F)

# ---- Character ----
x     <- c("a", "b", "c")
class <- c("M", "F", "F", "M")

# ---- Integer ----
x <- 9:29
x

# ---- Complex ----
x <- c(1 + 0i, 2 + 4i)
x


# 3. MATRIX and matrix operations

(x <- matrix(1:6, nrow = 2, ncol = 3))
(y <- matrix(1:6, nrow = 3, ncol = 2))
x %*% y                   # matrix multiplication: result is 2 x 2


# 4. LIST: can hold different types of objects

(x <- list(1, "a", TRUE, 1 + 4i))


# 5. FACTOR: categorical data
x <- factor(c("yes", "yes", "no", "yes", "no"))
x
levels(x)
table(x)

# 6. MISSING VALUES

x <- c(1, 2, NA, 10, 3)
is.na(x)                  # which elements are NA

# "NA" typed as text is NOT a missing value
x   <- c(1, 2, 4, "NA", 5)
bad <- is.na(x)
print(bad)                # all FALSE
x[!bad]

# Keep only the rows that are complete in several objects
x <- c(1, 2, NA, 4, NA, 5)
y <- c("a", "b", NA, "d", NA, "f")
good <- complete.cases(x, y)
good
x[good]
y[good]


# 7. COERCION
# If a character is present, everything becomes character
c(1, 2, "a")
# Logical + numbers: TRUE becomes 1, FALSE becomes 0
sum(c(TRUE, TRUE, FALSE, FALSE, FALSE))     # 2

# 8. DATA FRAMES: different types of data in one table

studentID  <- c(1, 2, 3, 4, 5)
math_score <- c(12, 17, 10, 9, NA)
gender     <- c("M", "F", "M", "M", "F")
it_score   <- c(13, 18, 11, 10, 19)

scoredata <- data.frame(studentID, gender, math_score, it_score)
scoredata
View(scoredata)

# Creating data from the keyboard opens an editor window, so it is commented out:
# data_class2 <- data.frame(height = numeric(0), weight = numeric(0), bmi = numeric(0))
# data_class2 <- edit(data_class2)

# 9. DATA IMPORTATION

# R can import data from Excel, statistical packages (SAS, SPSS, Stata),
# text files (ASCII, XML, web scraping) and databases (SQL, MySQL, Oracle, Access).
# (SPSS and MySQL imports are done in Assignment 1.)

# Text file: the lecturer used a path on his own computer, so a relative path is used here
data_class <- read.table("class_data.txt", header = TRUE)

variable.names(data_class)     # "HEIGHT" "WEIGHT"
head(data_class)
tail(data_class)
data_class[10:20, ]            # rows 10 to 20
summary(data_class$WEIGHT)
length(data_class$WEIGHT)      # 43
data_class[, -1]               # everything except the first column
data_class$WEIGHT

# Built-in data sets
data()                         # list of available data sets
data("airquality")
variable.names(airquality)
str(airquality)

# 10. EXPLORATORY DATA ANALYSIS


# ---- Numerical summaries ----
data_class
summary(data_class)
str(data_class)

apply(data_class, 1, mean)     # mean of each row
apply(data_class, 2, sd)       # standard deviation of each column

c(mean(data_class$HEIGHT), sd(data_class$HEIGHT))
c(mean(data_class$WEIGHT), sd(data_class$WEIGHT))
c(Mean = mean(data_class$HEIGHT), SD = sd(data_class$HEIGHT))
c(Mean = mean(data_class$WEIGHT), SD = sd(data_class$WEIGHT))

# 11. CATEGORICAL vs CONTINUOUS VARIABLE (iris)

data("iris")
head(iris)

mean(iris$Petal.Length)
mean(iris$Petal.Length[iris$Species == "setosa"])
mean(iris$Petal.Length[iris$Species == "versicolor"])
mean(iris$Petal.Length[iris$Species == "virginica"])

# Shortcut: by() applies a function to each group
by(iris$Petal.Length, iris$Species, mean)
by(iris$Petal.Length, iris$Species, sd)
by(iris$Petal.Length, iris$Species, summary)

# Box-and-whisker plot: differences between categories
boxplot(iris$Sepal.Length ~ iris$Species, data = iris,
        main = "Comparison of categorical vs quantitative")

# 12. TWO CATEGORICAL VARIABLES (UC Berkeley admissions)

ucba <- data.frame(UCBAdmissions)
head(ucba)

(cross <- xtabs(Freq ~ Gender + Admit, data = ucba))

# Is there gender bias in UCB graduate admission?
prop.table(cross, 1)           # row proportions

# Simpson's paradox: a trend in the combined data disappears or reverses
# when the data are split into groups (here, by department)
cross2 <- xtabs(Freq ~ Gender + Admit, data = ucba[ucba$Dept == "F", ])
prop.table(cross2, 1)

# 13. BAR CHARTS

dat <- read.table(text = "ProdA ProdB ProdC ProdD
1 110 50 60 70
2 120 50 80 65", header = TRUE)
barplot(as.matrix(dat), beside = TRUE, col = c("red", "green"))

dat <- read.table(text = "A   B   C   D   E   F    G
1 10 80 30 90 70 60  90
2 20 50 70 50 40 10  40
3 60 80 80 60  60 30 160
4 20 40 70 80 20 10  70", header = TRUE)
barplot(as.matrix(dat))        # stacked bars

# 14. SCATTER PLOT and CORRELATION

plot(WEIGHT ~ HEIGHT, data = data_class)                 # formula version
plot(data_class$HEIGHT, data_class$WEIGHT)               # x, y version
plot(data_class[, 1], data_class[, 2], main = "Graph")   # by column number

cor(data_class$HEIGHT, data_class$WEIGHT)                # 0.266 (weak positive)


# 15. LINEAR MODELS
plot(WEIGHT ~ HEIGHT, data = data_class)
abline(lm(WEIGHT ~ HEIGHT, data = data_class)$coefficient)   # regression line

data_lm <- lm(HEIGHT ~ WEIGHT, data = data_class)
summary(data_lm)               # WEIGHT is not significant at 5% (p = 0.084)

par(mfrow = c(2, 2))           # show the 4 diagnostic plots together
plot(data_lm)
par(mfrow = c(1, 1))

hist(data_class$HEIGHT)
hist(data_class$WEIGHT, col = "blue")

# Regression line plus a smooth (lowess) line
plot(WEIGHT ~ HEIGHT, data = data_class)
abline(lm(WEIGHT ~ HEIGHT, data = data_class)$coefficient)
lines(lowess(data_class$HEIGHT, data_class$WEIGHT), col = "blue")

cor(data_class$HEIGHT, data_class$WEIGHT)
lm(WEIGHT ~ HEIGHT, data = data_class)   # intercept -4.20, slope 0.356



# 16. DATA MANAGEMENT: create another variable (BMI)

# attach() lets us use HEIGHT and WEIGHT without data_class$ (detached below)
attach(data_class)

(BMI <- WEIGHT / (HEIGHT / 100)^2)
(BMI <- round(WEIGHT / (HEIGHT / 100)^2, digits = 2))

head(cbind(data_class, BMI), n = 5)
new_data_class <- cbind(data_class, BMI)
tail(cbind(data_class, BMI), n = 10)

summary(BMI)
stem(BMI, scale = 2)           # stem-and-leaf plot

detach(data_class)


# 17. DATES

today <- Sys.Date()
format(today, format = "%B %d %Y")     # month name, day, year
format(today, format = "%A")           # day of the week

dob <- as.Date("1982-02-10")           # date of birth used in class
difftime(today, dob, units = "days")

startdate <- as.Date("2004-02-13")
enddate   <- as.Date("2011-01-22")
days <- enddate - startdate
days                                   # 2535 days



# 18. SUBSETTING: $, [ ] and [[ ]]

# Leadership study: how men and women differ in the way they lead.
# Five questions, scored 1 (strongly disagree) to 5 (strongly agree).
# Age 99 means the value is missing.

manager <- c(1, 2, 3, 4, 5)
country <- c("US", "US", "UK", "UK", "UK")
gender  <- c("M", "F", "F", "M", "F")
age     <- c(32, 45, 25, 39, 99)
q1 <- c(5, 3, 3, 3, 2)
q2 <- c(4, 5, 5, 3, 2)
q3 <- c(5, 2, 5, 4, 1)
q4 <- c(5, 5, 5, NA, 2)
q5 <- c(5, 5, 2, NA, 1)

leadership <- data.frame(manager, country, gender, age, q1, q2, q3, q4, q5)
str(leadership)
names(leadership)

# ---- Recode 99 as missing, then create age categories ----
leadership$age[leadership$age == 99] <- NA
View(leadership)

leadership$agecat[leadership$age > 75] <- "Elder"
leadership$agecat[leadership$age >= 35 & leadership$age <= 75] <- "Middle Aged"
leadership$agecat[leadership$age < 35] <- "Young"
leadership

# ---- Handle missing values: listwise deletion ----
is.na(leadership[, 5:9])
newdata <- na.omit(leadership)         # removes rows with any NA
newdata

# ---- Sorting ----
order(leadership$age)
newdata2 <- leadership[order(leadership$age), ]
newdata2

# ---- Merging data sets (added example: the lecturer gave notes only) ----
# Horizontal: merge() joins two data frames by a common key
extra <- data.frame(manager = c(1, 2, 3, 4, 5),
                    department = c("Sales", "HR", "IT", "Sales", "HR"))
merge(leadership, extra, by = "manager")

# Vertical: rbind() stacks data frames with the same variables
new_manager <- data.frame(manager = 6, country = "US", gender = "F", age = 41,
                          q1 = 4, q2 = 4, q3 = 3, q4 = 5, q5 = 4,
                          agecat = "Middle Aged")
rbind(leadership, new_manager)

# ---- Selecting and dropping variables ----
newdata3 <- leadership[, c(5:9)]
myvars <- c("q1", "q2", "q3", "q4", "q5")
(newdata3 <- leadership[myvars])

newdata4 <- leadership[, c(-1, -2)]
(newdata4 <- leadership[, -(1:5)])
newdata5 <- leadership[, c(-1, -7)]

# ---- $ versus [[ ]] ----
leadership[[4]]                        # fourth column as a vector
leadership$age                         # the same column by name

# ---- Selecting observations ----
newdata6 <- leadership[c(-1, -3), ]    # drop rows 1 and 3
newdata6 <- leadership[c(2, 4, 5), ]   # keep rows 2, 4 and 5

newdata7 <- subset(leadership, age >= 35 | age < 24,
                   select = c(q1, q2, q3, q4, q5))
newdata7

# Males older than 30 (with() avoids attach())
(newdata7 <- leadership[leadership$gender == "M" & leadership$age > 30, ])
