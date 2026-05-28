# Economic Growth and Environmental Indicators

**Author:** Grace Carver  
**Date:** May 28, 2026

---

## Overview

This repository constructs a country-level panel dataset spanning 1990–2023 to examine stylized facts about economic development and the environment. Using the World Bank's World Development Indicators (WDI), the project fetches, cleans, and summarizes three indicators:

| Indicator | WDI Code | Unit |
|---|---|---|
| GDP per capita | `NY.GDP.PCAP.CD` | Current USD |
| Access to electricity | `EG.ELC.ACCS.ZS` | % of population |
| Share of renewable electricity | `EG.ELC.RNWX.ZS` | % of total electricity output |

The pipeline is fully reproducible: raw data are never edited by hand, all transformations happen in code, and outputs are written to clearly labeled folders.

---

## Repository Structure

```
.
├── code/
│   ├── 01_fetch_data.R          # Pull raw data from World Bank API
│   ├── 02_clean_data.R          # Tidy and clean the raw data
│   └── 03_summary_statistics.R  # Generate summary statistics tables and figure
├── data/
│   ├── raw/                     # Raw data — never edited
│   │   └── wdi_raw.csv
│   └── processed/               # Cleaned, analysis-ready data
│       └── economic_environment_indicators.csv
├── output/
│   ├── figures/                 # Plots
│   │   └── gdp_vs_electricity.png
│   └── tables/                  # Summary statistics tables
│       ├── access_to_electricity_summary.csv
│       └── share_renewable_electricity_summary.csv
├── LICENSE.md
└── README.md
```

---

## Data Sources and Provenance

| Indicator | Source | Indicator Code | URL | Access Date | Vintage | License |
|---|---|---|---|---|---|---|
| GDP per capita | World Bank WDI | `NY.GDP.PCAP.CD` | https://data.worldbank.org/indicator/NY.GDP.PCAP.CD | May 28, 2026 | 2023 release | CC BY 4.0 |
| Access to electricity | World Bank WDI | `EG.ELC.ACCS.ZS` | https://data.worldbank.org/indicator/EG.ELC.ACCS.ZS | May 28, 2026 | 2023 release | CC BY 4.0 |
| Share of renewable electricity | World Bank WDI | `EG.ELC.RNWX.ZS` | https://data.worldbank.org/indicator/EG.ELC.RNWX.ZS | May 28, 2026 | 2023 release | CC BY 4.0 |

> **Raw data policy:** All downloaded files are saved to `data/raw/` and treated as read-only. Every transformation is performed in code and written to `data/processed/`.

---

## Software and Package Requirements

**Language:** R (≥ 4.3.0)

| Package | Purpose |
|---|---|
| `WDI` | World Bank API client |
| `tidyverse` | Data manipulation and piping |
| `data.table` | Fast data operations (`setnames`) |
| `knitr` | Table formatting |
| `here` | Portable, root-relative file paths |

Install all packages with:

```r
install.packages(c("WDI", "tidyverse", "data.table", "knitr", "here"))
```

---

## Scripts

Run the scripts in order from the project root directory.

| Script | Description |
|---|---|
| [`code/01_fetch_data.R`](code/01_fetch_data.R) | Fetches raw country-level data from the World Bank API and saves to `data/raw/wdi_raw.csv` |
| [`code/02_clean_data.R`](code/02_clean_data.R) | Removes regional aggregates, selects and renames columns, and saves a tidy dataset to `data/processed/` |
| [`code/03_summary_statistics.R`](code/03_summary_statistics.R) | Computes per-indicator summary statistics (N, mean, median, min, max, SD, correlation with log GDP) and writes tables to `output/tables/`; produces scatter plot to `output/figures/` |

---

## Reproducing the Analysis

1. Clone the repository.
2. Open R and install the required packages (see above).
3. Run each script in order:

```r
source("code/01_fetch_data.R")
source("code/02_clean_data.R")
source("code/03_summary_statistics.R")
```

All paths are relative to the project root. Scripts use the `here` package to resolve paths — no manual working directory changes are needed.
