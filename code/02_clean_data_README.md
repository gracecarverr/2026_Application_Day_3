# 02_clean_data.R

Cleans and tidies the raw World Bank data by removing non-country aggregates, selecting relevant columns, and renaming variables for readability.

---

## Purpose

The raw WDI download includes regional and income-group aggregates (e.g., "East Asia & Pacific", "High income") alongside true country observations. This script filters those out, retains only the variables needed for analysis, renames them to human-readable labels, and saves a tidy, analysis-ready dataset.

---

## Inputs

| File | Location | Description |
|---|---|---|
| `wdi_raw.csv` | `data/raw/` | Raw output from `01_fetch_data.R` |

---

## Outputs

| File | Location | Description |
|---|---|---|
| `economic_environment_indicators.csv` | `data/processed/` | Cleaned, country-level panel data |

---

## What the Script Does

1. **Removes aggregates** — Drops rows whose ISO3 code matches a known list of regional, income-group, and sub-national codes (e.g., `WLD`, `EAP`, `HIC`). This leaves only sovereign-country observations.
2. **Selects columns** — Retains `iso3c`, `country`, `year`, and the three indicator columns.
3. **Renames columns** — Replaces WDI codes with readable names:

| Original name | Renamed to |
|---|---|
| `iso3c` | `CountryCode` |
| `country` | `Country` |
| `year` | `Year` |
| `NY.GDP.PCAP.CD` | `GdpPerCapita` |
| `EG.ELC.ACCS.ZS` | `AccessToElec` |
| `EG.ELC.RNWX.ZS` | `ShareRenewableElec` |

---

## Packages Required

| Package | Use |
|---|---|
| `tidyverse` | Filtering and piping (`filter`, `%>%`) |
| `data.table` | Column renaming (`setnames`) |
