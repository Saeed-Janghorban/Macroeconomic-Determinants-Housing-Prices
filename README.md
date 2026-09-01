# Macroeconomic Determinants of U.S. Housing Prices

## Overview

This project investigates the relationship between macroeconomic factors and U.S. housing price growth using monthly data from 1990 to 2025.

The main objective is to examine whether interest rates, unemployment, and inflation can explain changes in housing market dynamics.

---

## Data

The dataset is collected from the Federal Reserve Economic Database (FRED).

Variables:

- Housing Price Index (S&P/Case-Shiller U.S. National Home Price Index)
- Federal Funds Rate
- Unemployment Rate
- CPI-based Inflation Rate

Sample period:

January 1990 - December 2025

---

## Methodology

The project follows these steps:

1. Data collection from FRED
2. Data cleaning and merging
3. Construction of housing price growth and inflation variables
4. Descriptive statistics and correlation analysis
5. Ordinary Least Squares (OLS) regression
6. Regression diagnostic tests

The baseline regression model is:

HousingGrowth = β0 + β1 InterestRate + β2 Unemployment + β3 Inflation + ε

---

## Model Diagnostics

The following tests were performed:

- Residual Normality Test (Jarque-Bera)
- Heteroskedasticity Test (Breusch-Pagan)
- Autocorrelation Tests (Durbin-Watson and Breusch-Godfrey)
- Multicollinearity Test (Variance Inflation Factor)
- Influential Observation Analysis (Cook's Distance)

---

## Main Findings

- Unemployment shows a statistically significant negative relationship with housing price growth.
- Interest rates have the expected negative relationship with housing growth, although the statistical significance is limited.
- Inflation does not provide strong explanatory power in the baseline model.
- Diagnostic tests highlight some violations of classical OLS assumptions, which should be considered when interpreting results.

---

## Tools & Packages

- R
- tidyverse
- fredr
- psych
- lmtest
- car
- sandwich

---

## Author

Saeed Janghorban