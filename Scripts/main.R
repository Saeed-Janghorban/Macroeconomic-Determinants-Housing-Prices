# Macroeconomic Determinants of Housing Prices
# Evidence from U.S. Data

# Author: Saeed Janghorban
# Date: 2026

library(tidyverse)
library(fredr)
library(psych)
library(lmtest)
library(car)
library(sandwich)
library(tseries)

fredr_set_key("e8ab10a5e4b595f22143da30328c971e")

# Housing_data and Visualization and Save
housing <- fredr(
  series_id = "CSUSHPISA",
  observation_start = as.Date("1990-01-01"),
  observation_end = as.Date("2025-12-31")
)

housing_data <- housing %>%
  select(date, value) %>%
  rename(
    housing_price = value
  )

ggplot(
  housing_data,
  aes(
    x = date,
    y = housing_price
  )
) +
  geom_line() +
  labs(
    title = "U.S. Housing Price Index (1990-2025)",
    x = "Year",
    y = "Housing Price Index"
  )

write.csv(
  housing_data,
  "Data/housing_price.csv",
  row.names = FALSE
)

# Interest_rate
interest <- fredr(
  series_id = "FEDFUNDS",
  observation_start = as.Date("1990-01-01"),
  observation_end = as.Date("2025-12-31")
)

interest_data <- interest %>%
  select(date,value) %>%
  rename(
    interest_rate = value
  )

write.csv(
  interest_data,
  "Data/interest_data.csv",
  row.names = FALSE
)

# Unemployment_rate
unemployment <- fredr(
  series_id = "UNRATE",
  observation_start = as.Date("1990-01-01"),
  observation_end = as.Date("2025-12-31")
)

unemployment_data <- unemployment %>%
  select(date,value) %>%
  rename(
    unemployment = value
  )

write.csv(
  unemployment_data,
  "Data/unemployment_data.csv",
  row.names = FALSE
)

# Consumer price index (CPI)
cpi <- fredr(
  series_id = "CPIAUCSL",
  observation_start = as.Date("1990-01-01"),
  observation_end = as.Date("2025-12-31")
)

cpi_data <- cpi %>%
  select(date,value) %>%
  rename(
    cpi = value
  )

write.csv(
  cpi_data,
  "Data/cpi_data.csv",
  row.names = FALSE
)

# Merging all data
dataset <- housing_data %>%
  left_join(
    interest_data,
    by="date"
  ) %>%
  left_join(
    unemployment_data,
    by="date"
  ) %>%
  left_join(
    cpi_data,
    by="date"
  )

write.csv(
  dataset,
  "Data/housing_macro_dataset.csv",
  row.names = FALSE
)

# Delete missing data
colSums(is.na(dataset))
dataset_clean <- dataset %>%
  drop_na()

# Descriptive statistics
describe(dataset_clean)

numeric_data <- dataset_clean %>%
  select(
    housing_price,
    interest_rate,
    unemployment,
    cpi
  )
cor(numeric_data)

# Data transformation (housing price and inflation)
dataset_clean <- dataset_clean %>%
  arrange(date) %>%
  mutate(
    housing_growth =
      (housing_price - lag(housing_price)) /
      lag(housing_price) * 100
  )

dataset_clean <- dataset_clean %>%
  arrange(date) %>%
  mutate(
    inflation =
      (cpi - lag(cpi,12)) /
      lag(cpi,12) * 100
  )

dataset_model <- dataset_clean %>%
  drop_na()

# Linear Model
model_ols <- lm(
  housing_growth ~ interest_rate + unemployment + inflation,
  data = dataset_model
)

summary(model_ols)

# Residual Normality Check
residuals_ols <- residuals(model_ols)

hist(
  residuals_ols,
  main = "Histogram of OLS Residuals",
  xlab = "Residuals"
)

qqnorm(residuals_ols)
qqline(
  residuals_ols,
  col = "red"
)

jarque.bera.test(residuals_ols) # Jarque-Bera test for residual normality

# Heteroskedasticity Test: Breusch-Pagan Test
bptest(model_ols)

# Autocorrelation Test: Durbin-Watson Test
durbinWatsonTest(model_ols)

# Multicollinearity Test: Variance Inflation Factor (VIF)
vif(model_ols)

# Influential Observations: Cook's Distance
cooksd <- cooks.distance(model_ols)
plot(
  cooksd,
  type="h",
  main="Cook's Distance"
)

# Overall Model Significance: F-test
summary(model_ols)

# Individual Variable Significance: T-tests
coeftest(model_ols)

# Model Explanatory Power: R-squared
summary(model_ols)$r.squared

# Adjusted R-squared
summary(model_ols)$adj.r.squared