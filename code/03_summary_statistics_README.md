# 03_summary_statistics.R

Computes per-indicator summary statistics and writes them to CSV tables.

---

## Purpose

Produces a concise summary statistics table for each indicator — covering the number of countries, central tendency, spread, and correlation with log GDP per capita. These tables are the primary analytical output of the pipeline.

---

## Inputs

| File | Location | Description |
|---|---|---|
| `economic_environment_indicators.csv` | `data/processed/` | Cleaned panel data from `02_clean_data.R` |

---

## Outputs

| File | Location | Description |
|---|---|---|
| `access_to_electricity_summary.csv` | `output/figures/` | Summary stats for access to electricity |
| `share_renewable_electricity_summary.csv` | `output/figures/` | Summary stats for share of renewable electricity |

---

## What the Script Does

1. **Constructs log GDP** — Creates `LogGdpPerCapita = log(GdpPerCapita)` for use in correlations.
2. **Computes summary statistics** — For each indicator, calculates:

| Statistic | Description |
|---|---|
| `Indicator` | Human-readable indicator name |
| `Unit` | Unit of measurement |
| `Number of Countries` | Count of distinct countries with non-missing data |
| `Mean` | Sample mean |
| `Median` | Sample median |
| `Min` | Sample minimum |
| `Max` | Sample maximum |
| `StdDev` | Standard deviation |
| `Correlation With LogGDP` | Pearson correlation with log GDP per capita (complete observations only) |

3. **Writes tables** — Saves one CSV per indicator to `output/figures/`.

---

## Packages Required

| Package | Use |
|---|---|
| `tidyverse` | Summarization and piping |
| `data.table` | Loaded for compatibility |
| `knitr` | Table formatting utilities |
