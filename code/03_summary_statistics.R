# ============================================================================
# PROJECT: Economic Growth and Environmental Indicators
# SCRIPT:  Generate summary statistics
# AUTHOR:  Grace Carver
# DATE:    May 28, 2026
# ============================================================================
#
# PURPOSE:
#   Create summary statistics
#   - Descriptive statistics for each indicator
#
# INPUT:
#   data/processed/economic_environment_indicators.csv
#
# OUTPUT:
#   output/tables/summary_statistics.csv
#
# ============================================================================

library(tidyverse)
library(data.table)
library(knitr)

# Set working directory;

setwd("~/Desktop/economic-growth-environment-data")

# Read cleaned data;

WorldBank <- read.csv("data/processed/economic_environment_indicators.csv")

# Create log GDP for easier interpretation;

WorldBank$LogGdpPerCapita <- log(WorldBank$GdpPerCapita)

# Summary statistics for each indicator;

access_summary <- WorldBank %>%
  summarise(
    Indicator = "Access to Electricity",
    Unit = "% of population",
    'Number of Countries' = n_distinct(CountryCode[!is.na(AccessToElec)]),
    Mean = round(mean(AccessToElec, na.rm = TRUE), 2),
    Median = round(median(AccessToElec, na.rm = TRUE), 2),
    Min = round(min(AccessToElec, na.rm = TRUE), 2),
    Max = round(max(AccessToElec, na.rm = TRUE), 2),
    StdDev = round(sd(AccessToElec, na.rm = TRUE), 2),
    'Correlation With LogGDP' = round(cor(AccessToElec, LogGdpPerCapita, 
                                          use = "complete.obs"), 3)
  )

renewables_summary <- WorldBank %>%
  summarise(
    Indicator = "Share of Renewable Electricity",
    Unit = "% of Total",
    'Number of Countries' = n_distinct(CountryCode[!is.na(ShareRenewableElec)]),
    Mean = round(mean(ShareRenewableElec, na.rm = TRUE), 2),
    Median = round(median(ShareRenewableElec, na.rm = TRUE), 2),
    Min = round(min(ShareRenewableElec, na.rm = TRUE), 2),
    Max = round(max(ShareRenewableElec, na.rm = TRUE), 2),
    StdDev = round(sd(ShareRenewableElec, na.rm = TRUE), 2),
    'Correlation With LogGDP' = round(cor(ShareRenewableElec, LogGdpPerCapita, 
                                          use = "complete.obs"), 3)
  )

# Write tables to CSV;

write.csv(access_summary, "output/tables/access_to_electricity_summary.csv",
          row.names = FALSE)
write.csv(renewables_summary, "output/tables/share_renewable_electricity_summary.csv", 
          row.names = FALSE)



