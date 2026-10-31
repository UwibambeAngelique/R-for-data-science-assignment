# ggplot2 geoms on built-in datasets
# Datasets: mpg (fuel economy of 234 cars) and economics (US monthly data)
# Functions used: geom_bar, geom_boxplot, geom_density, geom_histogram,
#   geom_hline, geom_jitter, geom_line, geom_rug, geom_text,
#   geom_violin, geom_vline
# (geom_point and geom_smooth are commented out in the instructions)

# Package
if (!"ggplot2" %in% rownames(installed.packages())) {
  install.packages("ggplot2", type = "binary")
}
library(ggplot2)

dir.create("images", showWarnings = FALSE)   # folder for saving plots

#  Look at the built-in data 
head(mpg)       # class, drv (drive: 4 / f / r), hwy and cty (miles per gallon)
str(mpg)
head(economics) # date, unemploy (thousands of unemployed people), ...

mean_hwy <- mean(mpg$hwy)

# 1. geom_bar(): number of cars by class and drive type
p1 <- ggplot(mpg, aes(x = class, fill = drv)) +
  geom_bar(position = "dodge") +
  labs(title = "Number of cars by class and drive type",
       x = "Car class", y = "Number of cars", fill = "Drive") +
  theme_minimal()
p1
ggsave("images/builtin_01_bar.png", p1, width = 7, height = 4.5, dpi = 200)

# 2. geom_text(): count labels on top of the bars
p2 <- ggplot(mpg, aes(x = class)) +
  geom_bar(fill = "steelblue") +
  geom_text(stat = "count", aes(label = after_stat(count)), vjust = -0.4) +
  labs(title = "Number of cars by class (with counts)",
       x = "Car class", y = "Number of cars") +
  theme_minimal()
p2
ggsave("images/builtin_02_text.png", p2, width = 7, height = 4.5, dpi = 200)

# 3. geom_histogram() + geom_rug() + geom_vline(): highway mileage

p3 <- ggplot(mpg, aes(x = hwy)) +
  geom_histogram(binwidth = 2, fill = "steelblue", colour = "white") +
  geom_rug(alpha = 0.3) +                                  # one tick per car
  geom_vline(xintercept = mean_hwy, colour = "red",
             linetype = "dashed", linewidth = 1) +         # mean highway mileage
  labs(title = "Distribution of highway mileage",
       subtitle = paste("Dashed line = mean (", round(mean_hwy, 1), "mpg )"),
       x = "Highway miles per gallon", y = "Number of cars") +
  theme_minimal()
p3
ggsave("images/builtin_03_histogram.png", p3, width = 7, height = 4.5, dpi = 200)


# 4. geom_density(): highway mileage by drive type

p4 <- ggplot(mpg, aes(x = hwy, fill = drv)) +
  geom_density(alpha = 0.4) +
  labs(title = "Highway mileage by drive type",
       x = "Highway miles per gallon", y = "Density", fill = "Drive") +
  theme_minimal()
p4
ggsave("images/builtin_04_density.png", p4, width = 7, height = 4.5, dpi = 200)

# 5. geom_boxplot(): highway mileage by car class

p5 <- ggplot(mpg, aes(x = reorder(class, hwy, median), y = hwy, fill = class)) +
  geom_boxplot(show.legend = FALSE) +
  labs(title = "Highway mileage by car class",
       x = "Car class (ordered by median)", y = "Highway miles per gallon") +
  theme_minimal()
p5
ggsave("images/builtin_05_boxplot.png", p5, width = 7, height = 4.5, dpi = 200)


# 6. geom_jitter() + geom_hline(): every car and the overall mean

p6 <- ggplot(mpg, aes(x = drv, y = hwy, colour = drv)) +
  geom_jitter(width = 0.2, alpha = 0.7, show.legend = FALSE) +   # spread overlapping points
  geom_hline(yintercept = mean_hwy, linetype = "dashed") +       # overall mean
  labs(title = "Highway mileage of each car by drive type",
       subtitle = paste("Dashed line = overall mean (", round(mean_hwy, 1), "mpg )"),
       x = "Drive type (4 = four-wheel, f = front, r = rear)",
       y = "Highway miles per gallon") +
  theme_minimal()
p6
ggsave("images/builtin_06_jitter.png", p6, width = 7, height = 4.5, dpi = 200)

# 7. geom_violin(): city mileage by drive type (boxplot drawn inside)

p7 <- ggplot(mpg, aes(x = drv, y = cty, fill = drv)) +
  geom_violin(alpha = 0.5, show.legend = FALSE) +
  geom_boxplot(width = 0.1, show.legend = FALSE) +
  labs(title = "City mileage by drive type",
       x = "Drive type", y = "City miles per gallon") +
  theme_minimal()
p7
ggsave("images/builtin_07_violin.png", p7, width = 7, height = 4.5, dpi = 200)

# 8. geom_line() + geom_vline() + geom_text(): US unemployment over time

label_2008 <- data.frame(x = as.Date("2007-10-01"), y = 12000,
                         label = "2008 financial\ncrisis")

p8 <- ggplot(economics, aes(x = date, y = unemploy)) +
  geom_line(colour = "steelblue", linewidth = 1) +
  geom_vline(xintercept = as.Date("2008-01-01"), linetype = "dashed", colour = "red") +
  geom_text(data = label_2008, aes(x = x, y = y, label = label),
            hjust = 1, size = 3.5, inherit.aes = FALSE) +
  labs(title = "US unemployment, 1967 to 2015",
       x = "Year", y = "Unemployed people (thousands)") +
  theme_minimal()
p8
ggsave("images/builtin_08_line_vline.png", p8, width = 7, height = 4.5, dpi = 200)
