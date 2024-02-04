# load packages
library(tidyverse) 
library(here)
library(naniar)
library(DT)
library(knitr)

# load and clean dataset
traffic_data <- read_csv("data/Traffic_Crashes_-_Crashes_20240203.csv") |>
  janitor::clean_names() |>
  rename(
    roadway_surface_condition = roadway_surface_cond
  ) |>
  mutate(
    across(
      c(
        ends_with("i"),
        ends_with("cause"),
        ends_with("type"),
        ends_with("condition"),
        traffic_control_device,
        most_severe_injury,
        work_zone_type,
        street_direction,
        alignment,
        damage,
        road_defect
      ),
      factor
    ),
    fatal_i = if_else(
      injuries_fatal > 0,
      TRUE,
      if_else(
        injuries_fatal == 0,
        FALSE,
        NA
      )
    )
  ) |>
  relocate(fatal_i)

# missingness exploration — whole dataset
missing_table <- miss_var_summary(traffic_data) 
datatable(missing_table)
missing_names <- missing_table |>
  pull(variable)
traffic_data |>
  select(missing_names) |>
  gg_miss_var()

# outcome variable exploration — distribution + missingness
traffic_data |>
  ggplot(aes(injuries_total)) +
  geom_bar() +
  theme_classic() +
  labs(
    title = "Distribution of the number of traffic incident injuries",
    subtitle = "The vast majority of traffic collisions leave involved agents unscathed"
  ) +
  scale_x_continuous(breaks = c(0:20))
traffic_data |>
  count(injuries_total) |>
  datatable(nrows = 5)
traffic_data |>
  select(injuries_total) |>
  miss_var_summary() |>
  kable()
