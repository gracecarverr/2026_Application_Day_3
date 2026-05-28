# ============================================================================
# PROJECT: Economic Growth and Environmental Indicators
# SCRIPT:  Fetch country-level data from World Bank API
# AUTHOR:  Grace Carver
# DATE:    May 28, 2026
# ============================================================================
# INPUT:
#   World Bank API (https://api.worldbank.org/v2)
#
# OUTPUT:
#   data/raw/wdi_raw.csv - Raw data from World Bank (unedited)
#
# NOTES:
#   - Access date: May 28, 2026
#   - Data range: 1990-2023
#   - License: CC BY 4.0 (World Bank)
#
# ============================================================================

# Gather country-level data from the World Bank API:

# Load necessary packages;

library(WDI)
library(tidyverse)
library(here)

# Fetch data from World Bank API;

WorldBank <- WDI(indicator = c(
  "NY.GDP.PCAP.CD",
  "EG.ELC.ACCS.ZS",
  "EG.ELC.RNWX.ZS"),
  start = 1990,
  end = 2023)

# Save raw data to CSV

write.csv(WorldBank, here("data", "raw", "wdi_raw.csv"), row.names = FALSE)

