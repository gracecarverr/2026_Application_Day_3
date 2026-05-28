# 01_fetch_data.R

Fetches country-level data from the World Bank API using the `WDI` R package and saves the raw output as a CSV.

---

## Purpose

Pulls three indicators for all available countries over 1990–2023 directly from the World Bank's World Development Indicators database. Using the API (rather than a manual download) ensures the data can be refreshed whenever a new vintage is released by re-running this script.

---

## Inputs

| Source | Type | Details |
|---|---|---|
| World Bank API | Live API | Accessed via the `WDI` R package (`https://api.worldbank.org/v2`) |

### Indicators fetched

| Variable name | WDI Code | Description | Unit |
|---|---|---|---|
| `NY.GDP.PCAP.CD` | GDP per capita | Current USD per person | USD |
| `EG.ELC.ACCS.ZS` | Access to electricity | Share of population with access | % |
| `EG.ELC.RNWX.ZS` | Share of renewable electricity | Renewables as share of total output | % |

---

## Outputs

| File | Location | Description |
|---|---|---|
| `wdi_raw.csv` | `data/raw/` | Raw API response — **never edited by hand** |

---

## Key Details

- **Data range:** 1990–2023
- **Access date:** May 28, 2026
- **License:** CC BY 4.0 (World Bank)
- Raw data are saved to `data/raw/` and treated as read-only. All cleaning happens in `02_clean_data.R`.

---

## Packages Required

| Package | Use |
|---|---|
| `WDI` | World Bank API client |
| `tidyverse` | Loaded here for downstream compatibility |
