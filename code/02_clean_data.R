# ============================================================================
# PROJECT: Economic Growth and Environmental Indicators
# SCRIPT:  Clean and tidy the raw data
# AUTHOR:  Grace Carver
# DATE:    May 28, 2026
# ============================================================================
#
# INPUT:
#   data/raw/wdi_raw.csv
#
# OUTPUT:
#   data/processed/economic_environment_indicators.csv
#
# ============================================================================

# Set working directory;

setwd("~/Desktop/economic-growth-environment-data")

# Read raw data;

WorldBank <- read.csv("data/raw/wdi_raw.csv")

# Remove aggregate country codes, filter down to countries;

exclude_codes <- c("EAR", "EMU", "HPC", "LDC", "LTE", "NAC", "OED", "PRE", 
                   "PST","ABW", "ASM", "BMU", "CHI", "CUW", "CYM", "FRO", 
                   "GIB", "GRL", "GUM", "HKG", "IMN", "MAC", "MAF", "MNP", 
                   "NCL", "PRI", "PYF", "SXM", "TCA", "VGB", "VIR","AFE", 
                   "AFW", "ARB", "CEB", "CSS", "EAP", "EAS", "TEA", "ECA", 
                   "ECS", "TEC", "EUU", "IBD", "IBT", "IDB", "IDX", "IDA", 
                   "LAC", "LCN", "TLA", "LMY", "LIC", "LMC", "MIC", "MNA", 
                   "OSS", "SAS", "SSA", "SSF", "SST", "TSA", "TSS", "UMC", 
                   "WLD","FCS", "PSS")

WorldBank <- WorldBank %>%
  filter(!(iso3c %in% exclude_codes)) %>%
  filter(iso3c != "")

# Keep only necessary columns;

WorldBank <- WorldBank[, c("iso3c", "country", "year", 
                       "NY.GDP.PCAP.CD", 
                       "EG.ELC.ACCS.ZS", 
                       "EG.ELC.RNWX.ZS")]

# Rename columns for readability;

setnames(WorldBank,
         old = c(
           "iso3c",
           "country",
           "year",
           "NY.GDP.PCAP.CD",
           "EG.ELC.ACCS.ZS",
           "EG.ELC.RNWX.ZS"
         ),
         new = c(
           "CountryCode",
           "Country",
           "Year",
           "GdpPerCapita",
           "AccessToElec",
           "ShareRenewableElec"
         )
)

# Save processed data to CSV;

write.csv(WorldBank, "data/processed/economic_environment_indicators.csv", 
          row.names = FALSE)

