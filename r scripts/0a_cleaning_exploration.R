# load packages
library(tidyverse) 
library(here)
library(naniar)
library(DT)
library(knitr)

# handle common conflicts
tidymodels_prefer()

# load and clean dataset
traffic_data_cleaned <- read_csv("data/Traffic_Crashes_-_Crashes_20240203.csv") |>
  janitor::clean_names() |>
  rename(
    roadway_surface_condition = roadway_surface_cond
  ) |>
  mutate(
    traffic_control_device_i = fct_collapse(
      traffic_control_device,
      "Yes" = unique(traffic_control_device[!(traffic_control_device %in% c("NO CONTROLS", "UNKNOWN"))]),
      "No" = "NO CONTROLS",
      "Unknown" = "UNKNOWN"
    ),
    device_condition = fct_collapse(
      device_condition,
      "Bad" = c("NO CONTROLS", "FUNCTIONING IMPROPERLY", "NOT FUNCTIONING", "MISSING", "WORN REFLECTIVE MATERIAL"),
      "Good" = "FUNCTIONING PROPERLY",
      "Unknown" = c("UNKNOWN", "OTHER")
    ),
    weather_condition = fct_collapse(
      weather_condition,
      "Precipitation" = c("SNOW", "RAIN", "BLOWING SNOW", "FREEZING RAIN/DRIZZLE", "SLEET/HAIL"),
      "Clouds/Wind" = c("CLOUDY/OVERCAST", "SEVERE CROSS WIND GATE"),
      "Clear" = "CLEAR",
      "Other" = c("OTHER", "BLOWING SAND, SOIL, DIRT", "FOG/SMOKE/HAZE"),
      "Unknown" = "UNKNOWN"
    ),
    first_crash_type = fct_collapse(
      first_crash_type,
      "Object" = c("FIXED OBJECT", "OTHER OBJECT", "TRAIN"),
      "Animal" = "ANIMAL",
      "Non-motorist" = c("PEDALCYCLIST", "PEDESTRIAN"),
      "Motorist" = unique(first_crash_type[!(first_crash_type %in% c("FIXED OBJECT", "OTHER OBJECT", "TRAIN", "ANIMAL", "PEDALCYCLIST", "PEDESTRIAN"))]),
      "Other" = "OTHER NONCOLLISION"
    ),
    roadway_surface_condition = fct_collapse(
      roadway_surface_condition,
      "Good" = "DRY",
      "Bad" = c("SNOW OR SLUSH", "WET", "ICE", "SAND, MUD, DIRT"),
      "Other" = c("UNKNOWN", "OTHER")
    ),
    road_defect = fct_collapse(
      road_defect,
      "No" = "NO DEFECTS",
      "Yes" = c("DEBRIS ON ROADWAY", "WORN SURFACE", "SHOULDER DEFECT", "RUT, HOLES"),
      "Other" = c("UNKNOWN", "OTHER")
    ),
    trafficway_type = fct_collapse(
      trafficway_type,
      "Unknown" = c("UNKNOWN", "UNKNOWN INTERSECTION TYPE", "NOT REPORTED")
    ),
    trafficway_type = fct_lump_n(
      trafficway_type,
      n = 6
    ),
    prim_contributory_cause = fct_lump_n(
      prim_contributory_cause,
      n = 6
    ),
    sec_contributory_cause = fct_lump_n(
      sec_contributory_cause,
      n = 6
    ),
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
  )
save(
  traffic_data_cleaned,
  file = here("data/traffic_data_cleaned.rda")
)


# missingness exploration — whole dataset
load(here("data/traffic_data_cleaned.rda"))
missing_table <- naniar::miss_var_summary(traffic_data_cleaned) 
DT::datatable(missing_table)
missing_names <- missing_table |>
  pull(variable)
traffic_data_cleaned |>
  select(missing_names) |>
  gg_miss_var()

# outcome variable exploration — distribution + missingness
traffic_data_cleaned |>
  ggplot(aes(injuries_total)) +
  geom_bar(fill = "steelblue") +
  theme_classic() +
  labs(
    title = "Distribution of the number of traffic incident injuries",
    subtitle = "The vast majority of traffic collisions leave involved agents unscathed"
  ) +
  scale_x_continuous(breaks = c(0:20))
traffic_data_cleaned |>
  filter(injuries_total >= 5) |>
  ggplot(aes(injuries_total)) +
  geom_bar(fill = "steelblue") +
  theme_classic() +
  labs(
    title = "Distribution of the number of traffic incident injuries",
    subtitle = "Restricted to incidents involving at least 5 injured agents"
  ) +
  scale_x_continuous(breaks = c(5:20))
traffic_data_cleaned |>
  count(injuries_total) |>
  datatable()
traffic_data_cleaned |>
  select(injuries_total) |>
  miss_var_summary() |>
  kable()
