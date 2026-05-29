# ============================================================================
# PROJECT: Economic Growth and Environmental Indicators
# SCRIPT:  Generate figures
# AUTHOR:  Grace Carver
# DATE:    May 29, 2026
# ============================================================================
#
# PURPOSE:
#   Create figures showing relationships between GDP, electricity access,
#   and renewable energy across countries and over time.
#
# INPUT:
#   data/processed/economic_environment_indicators.csv
#
# OUTPUT:
#   output/figures/day4/fig1-fig8 (8 figures)
#
# ============================================================================

library(ggplot2)
library(dplyr)
library(scales)
library(countrycode)
library(ggrepel)
library(forcats)

setwd("/Users/grace/Desktop/2026_Application_Day_3")

# ============================================================================
# 1. LOAD AND PREPARE DATA
# ============================================================================

data <- read.csv("data/processed/economic_environment_indicators.csv",
                 stringsAsFactors = FALSE) %>%
  mutate(
    Region = countrycode(
      CountryCode, origin = "wb", destination = "region",
      custom_match = c(
        "XKX" = "Europe & Central Asia",
        "MEA" = "Middle East & North Africa",
        "TMN" = "Other"
      )
    ),
    RegionCollapsed = case_when(
      Region == "Sub-Saharan Africa" ~ "Sub-Saharan Africa",
      Region %in% c("South Asia", "East Asia & Pacific") ~
        "South & East Asia",
      Region %in% c("Europe & Central Asia", "North America") ~
        "Europe & North America",
      Region %in% c("Latin America & Caribbean",
                    "Middle East & North Africa") ~
        "Latin America & MENA",
      TRUE ~ NA_character_
    )
  ) %>%
  select(-Region)

# ============================================================================
# 2. SET UP CONSISTENT STYLING
# ============================================================================

theme_pub <- function() {
  theme_minimal(base_size = 11) +
    theme(
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(color = "grey92"),
      axis.line = element_line(color = "black", linewidth = 0.4),
      axis.ticks = element_line(color = "black", linewidth = 0.3),
      plot.title = element_text(face = "bold", size = 12),
      plot.subtitle = element_text(color = "grey40", size = 9),
      plot.caption = element_text(color = "grey50", size = 7, hjust = 0),
      legend.position = "bottom",
      legend.key.size = unit(0.35, "cm"),
      plot.margin = margin(8, 10, 6, 8))}

source_note <- "Source: World Bank World Development Indicators (2023 release). CC BY 4.0."

# ============================================================================
# 3. PREPARE DATASETS FOR ANALYSIS
# ============================================================================

# Year 2021 selected as it is the most recent year with the most complete
# data coverage.

data_latest <- data %>%
  filter(Year == 2021, !is.na(GdpPerCapita), !is.na(AccessToElec),
         !is.na(RegionCollapsed))

data_latest_renewable <- data %>%
  filter(Year == 2021, !is.na(GdpPerCapita), !is.na(ShareRenewableElec),
         !is.na(RegionCollapsed))

# ============================================================================
# 4. GENERATE FIGURES
# ============================================================================

# Figure 1: Electricity access vs. GDP per capita
fig1 <- data_latest %>%
  ggplot(aes(x = GdpPerCapita, y = AccessToElec,
             color = RegionCollapsed)) +
  geom_point(alpha = 0.65, size = 1.8) +
  scale_x_log10(
    labels = label_dollar(scale = 1e-3, suffix = "k"),
    breaks = c(500, 1000, 2000, 5000, 10000, 30000, 100000)
  ) +
  scale_y_continuous(limits = c(0, 101),
                     labels = label_percent(scale = 1)) +
  scale_color_brewer(palette = "Dark2", name = NULL) +
  labs(
    title = "Electricity access vs. GDP per capita",
    subtitle = "Cross-section of 196 countries, 2021",
    x = "GDP per capita (log scale, current USD)",
    y = "Access to electricity (% of population)",
    caption = source_note
  ) +
  theme_pub()

ggsave("output/figures/day4/fig1_access_vs_gdp_scatter.png", fig1,
       width = 7, height = 4.5, dpi = 180, bg = "white")

# Figure 2: Renewable electricity share vs. GDP per capita
fig2 <- data_latest_renewable %>%
  ggplot(aes(x = GdpPerCapita, y = ShareRenewableElec,
             color = RegionCollapsed)) +
  geom_point(alpha = 0.65, size = 1.8) +
  scale_x_log10(
    labels = label_dollar(scale = 1e-3, suffix = "k"),
    breaks = c(500, 1000, 2000, 5000, 10000, 30000, 100000)
  ) +
  scale_y_continuous(limits = c(0, 101),
                     labels = label_percent(scale = 1)) +
  scale_color_brewer(palette = "Dark2", name = NULL) +
  labs(
    title = "Renewable electricity share vs. GDP per capita",
    subtitle = "Cross-section of 194 countries, 2021",
    x = "GDP per capita (log scale, current USD)",
    y = "Share of renewable electricity (% of total output)",
    caption = source_note
  ) +
  theme_pub()

ggsave("output/figures/day4/fig2_renewable_vs_gdp_scatter.png", fig2,
       width = 7, height = 4.5, dpi = 180, bg = "white")

# Figure 3: Electricity access over time
data_ts_access <- data %>%
  filter(CountryCode %in% c("IND", "NGA", "ETH", "BGD", "IDN", "PAK"),
         Year >= 2000, Year <= 2021, !is.na(AccessToElec))

fig3 <- ggplot(data_ts_access,
               aes(x = Year, y = AccessToElec, color = Country,
                   group = Country)) +
  geom_line(linewidth = 0.9) +
  geom_point(data = data_ts_access %>% group_by(Country) %>%
               slice_max(Year), size = 2.2) +
  geom_text_repel(
    data = data_ts_access %>% group_by(Country) %>% slice_max(Year),
    aes(label = Country), size = 2.6, direction = "y", nudge_x = 1,
    hjust = 0, segment.color = NA
  ) +
  scale_x_continuous(limits = c(2000, 2024),
                     breaks = seq(2000, 2020, 5)) +
  scale_y_continuous(limits = c(0, 101),
                     labels = label_percent(scale = 1)) +
  scale_color_brewer(palette = "Dark2") +
  labs(
    title = "Electricity access over time",
    subtitle = "Selected large low- and middle-income countries, 2000–2021",
    x = NULL,
    y = "Access to electricity (% of population)",
    caption = source_note
  ) +
  theme_pub() + theme(legend.position = "none")

ggsave("output/figures/day4/fig3_access_timeseries.png", fig3,
       width = 7, height = 4.5, dpi = 180, bg = "white")

# Figure 4: Renewable electricity share over time
data_ts_renewable <- data %>%
  filter(CountryCode %in% c("NOR", "BRA", "DEU", "CHN", "USA", "IND"),
         Year >= 2000, Year <= 2021, !is.na(ShareRenewableElec))

fig4 <- ggplot(data_ts_renewable,
               aes(x = Year, y = ShareRenewableElec, color = Country,
                   group = Country)) +
  geom_line(linewidth = 0.9) +
  geom_point(data = data_ts_renewable %>% group_by(Country) %>%
               slice_max(Year), size = 2.2) +
  geom_text_repel(
    data = data_ts_renewable %>% group_by(Country) %>% slice_max(Year),
    aes(label = Country), size = 2.6, direction = "y", nudge_x = 1,
    hjust = 0, segment.color = NA
  ) +
  scale_x_continuous(limits = c(2000, 2024),
                     breaks = seq(2000, 2020, 5)) +
  scale_y_continuous(labels = label_percent(scale = 1)) +
  scale_color_brewer(palette = "Dark2") +
  labs(
    title = "Renewable electricity share over time",
    subtitle = "Selected economies, 2000–2021",
    x = NULL,
    y = "Share of renewable electricity (%)",
    caption = source_note
  ) +
  theme_pub() + theme(legend.position = "none")

ggsave("output/figures/day4/fig4_renewable_timeseries.png", fig4,
       width = 7, height = 4.5, dpi = 180, bg = "white")

# Figure 5: Distribution of electricity access
fig5 <- data %>%
  filter(Year %in% c(2000, 2020), !is.na(AccessToElec)) %>%
  mutate(Year = factor(Year)) %>%
  ggplot(aes(x = AccessToElec, fill = Year, color = Year)) +
  geom_density(alpha = 0.35, linewidth = 0.7) +
  scale_x_continuous(labels = label_percent(scale = 1),
                     limits = c(0, 101)) +
  scale_fill_manual(values = c("2000" = "#d7191c", "2020" = "#2166ac"),
                    name = "Year") +
  scale_color_manual(values = c("2000" = "#d7191c", "2020" = "#2166ac"),
                     name = "Year") +
  labs(
    title = "Distribution of electricity access, 2000 vs. 2020",
    subtitle = "Density across ~180 countries",
    x = "Access to electricity (% of population)",
    y = "Density",
    caption = source_note
  ) +
  theme_pub()

ggsave("output/figures/day4/fig5_access_distribution_shift.png", fig5,
       width = 7, height = 4.5, dpi = 180, bg = "white")

# Figure 6: Countries with lowest electricity access
fig6 <- data_latest %>%
  filter(!is.na(AccessToElec)) %>%
  slice_min(AccessToElec, n = 20) %>%
  mutate(Country = fct_reorder(Country, AccessToElec)) %>%
  ggplot(aes(x = AccessToElec, y = Country)) +
  geom_col(fill = "#d7191c", alpha = 0.85, width = 0.7) +
  geom_text(aes(label = sprintf("%.0f%%", AccessToElec)), hjust = -0.1,
            size = 2.8, color = "grey20") +
  scale_x_continuous(expand = expansion(mult = c(0, 0.15)),
                     labels = label_percent(scale = 1)) +
  labs(
    title = "Countries with lowest electricity access",
    subtitle = "2021 data",
    x = "Access to electricity (% of population)",
    y = NULL,
    caption = source_note
  ) +
  theme_pub() +
  theme(panel.grid.major.y = element_blank(),
        axis.line.y = element_blank(), axis.ticks.y = element_blank())

ggsave("output/figures/day4/fig6_access_bottom20.png", fig6,
       width = 7, height = 5.5, dpi = 180, bg = "white")

# Figure 7: Countries with highest renewable electricity share
fig7 <- data_latest_renewable %>%
  filter(!is.na(ShareRenewableElec)) %>%
  slice_max(ShareRenewableElec, n = 20) %>%
  mutate(Country = fct_reorder(Country, ShareRenewableElec)) %>%
  ggplot(aes(x = ShareRenewableElec, y = Country)) +
  geom_col(fill = "#1b7837", alpha = 0.85, width = 0.7) +
  geom_text(aes(label = sprintf("%.0f%%", ShareRenewableElec)),
            hjust = -0.1, size = 2.8, color = "grey20") +
  scale_x_continuous(expand = expansion(mult = c(0, 0.15)),
                     labels = label_percent(scale = 1)) +
  labs(
    title = "Countries with highest renewable electricity share",
    subtitle = "2021 data",
    x = "Share of renewable electricity (% of total output)",
    y = NULL,
    caption = source_note
  ) +
  theme_pub() +
  theme(panel.grid.major.y = element_blank(),
        axis.line.y = element_blank(), axis.ticks.y = element_blank())

ggsave("output/figures/day4/fig7_renewable_top20.png", fig7,
       width = 7, height = 5.5, dpi = 180, bg = "white")

# Figure 8: Electricity access trends by RegionCollapsed
RegionCollapsedal_ts <- data %>%
  filter(Year >= 2000, Year <= 2021, !is.na(AccessToElec)) %>%
  group_by(Year, RegionCollapsed) %>%
  summarise(AvgAccess = mean(AccessToElec, na.rm = TRUE),
            .groups = 'drop') %>%
  filter(!is.na(RegionCollapsed)) %>%
  mutate(
    RegionCollapsed = factor(
      RegionCollapsed,
      levels = c("Europe & North America", "Latin America & MENA",
                 "South & East Asia", "Sub-Saharan Africa")
    )
  )

fig8 <- ggplot(RegionCollapsedal_ts, aes(x = Year, y = AvgAccess,
                                color = RegionCollapsed)) +
  geom_line(linewidth = 1.2) +
  facet_wrap(~RegionCollapsed, ncol = 2) +
  scale_y_continuous(labels = label_percent(scale = 1),
                     limits = c(0, 101)) +
  scale_color_manual(
    values = c(
      "Europe & North America" = "#1b9e77",
      "Latin America & MENA" = "#d95f02",
      "South & East Asia" = "#7570b3",
      "Sub-Saharan Africa" = "#e7298a"
    )
  ) +
  labs(
    title = "Electricity access trends by RegionCollapsed",
    subtitle = "2000–2021: Expansion pace varies significantly across RegionCollapseds",
    x = NULL,
    y = "Average access (%)",
    caption = source_note
  ) +
  theme_pub() +
  theme(
    legend.position = "none",
    plot.margin = margin(4, 6, 4, 4),
    panel.spacing = unit(0.5, "lines"),
    strip.text = element_text(size = 10, margin = margin(t = 2, b = 2))
  )

ggsave("output/figures/day4/fig8_access_RegionCollapsedal_facets.png", fig8,
       width = 8, height = 6, dpi = 180, bg = "white")