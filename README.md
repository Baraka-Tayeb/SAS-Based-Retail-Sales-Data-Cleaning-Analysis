# SAS Retail Sales Data Management

A complete end-to-end data quality and exploratory analytics project

# 🎯 Objective

To develop a comprehensive SAS-based analytical workflow that cleans, transforms, validates, and analyzes retail sales data in order to improve data quality, uncover performance patterns, and generate insights that support business decision-making.

# 📌 Project Overview

This project applies advanced SAS programming to prepare and analyze a large retail sales dataset containing product-level and region-level metrics. The workflow includes missing value treatment, formula-based corrections, robust statistical checks, manual one-hot encoding, distribution analysis, and inferential statistics.
The project demonstrates proficiency in SAS data management, EDA, statistical tests, and business interpretation.

# 🛠️ Methodology & Workflow
# 1️⃣ Data Inspection & Quality Assessment

Explored dataset structure using PROC CONTENTS

Identified missing values with PROC MEANS NMISS

Previewed records using PROC PRINT

# 2️⃣ Missing Value Imputation & Logical Corrections

Used mathematical relationships to restore missing fields:

total_sales = price_per_unit × units_sold

price_per_unit = total_sales ÷ units_sold

units_sold = total_sales ÷ price_per_unit

This ensured internal consistency across all sales figures.

# 3️⃣ Outlier Detection & Distribution Analysis

Performed statistical distribution checks using:

Histograms + density curves

Boxplots

Skewness and kurtosis via PROC UNIVARIATE

Robust statistics (ROBUSTSCALE)

Variables analyzed included price_per_unit, units_sold, total_sales, and operating_profit.

# 4️⃣ Median Imputation & Robust Scaling

Replaced missing numeric values with median using PROC STDIZE, improving dataset reliability.

# 5️⃣ Data Validation via SQL

Recalculated total sales

Compared discrepancies

Validated corrections with PROC SQL and custom delta calculations

# 6️⃣ Manual Feature Engineering (One-Hot Encoding)

Created binary indicators for:

Retailer

Region

Product category

Sales method

This expanded the dataset for statistical modelling.

$ 7️⃣ Region & State Binning

Aggregated U.S. states into:

Northeast

South

Midwest

West

And created a combined state_binning variable to support geographic analysis.

# 8️⃣ Standardization (Z-Score Scaling)

Applied z-score transformations for:

price_per_unit

units_sold

total_sales

operating_profit

Used PROC STANDARD to normalize distributions.

# 9️⃣ Exploratory Data Analysis & Visualization

Generated insights using:

Bar charts (sales by product, region, retailer)

Scatterplots (price vs total sales)

Pie charts (sales distribution)

Heatmap correlation matrices

Histograms with normal curves

These visualizations highlighted sales trends and performance differences.

# 🔟 Statistical Hypothesis Testing
ANOVA

Sales differences by retailer

Sales method comparisons

Price differences between sales channels

T-Tests

West vs South (price_per_unit)

Men’s vs Women’s product categories (units_sold)

Correlation Analysis

Strength relationships among key numeric metrics

Visualized using custom heatmap

# ⭐ Key Skills Demonstrated

SAS Programming (DATA step, PROC SQL, PROC SGPLOT, PROC UNIVARIATE, PROC STANDARD)

Data Cleaning & Preprocessing

Outlier & Distribution Analysis

Feature Engineering

Statistical Testing (ANOVA, t-test)

Correlation Analysis

Z-Score Standardization

Business Reporting & Interpretation

# 🚀 Impact & Outcomes

Produced a clean, validated dataset ready for modeling or reporting

Identified key drivers of sales and profitability

Revealed performance differences across regions, retailers, and products

Strengthened the reliability of business metrics through consistent calculations

Generated clear visual insights that support managerial decision-making
