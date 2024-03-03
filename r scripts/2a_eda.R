# load packages
library(tidyverse)
library(tidymodels)
library(here)

# load data
load(here("data/traffic_train.rda"))

# bivariate analysis: initial feature selection
### bivariate EDA functions
barchart_func <- function(x) {
  traffic_train |>
    ggplot(aes(x = {{ x }})) +
    geom_bar() +
    facet_wrap(vars(injurious)) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}
barchart_func2 <- function(x) {
  traffic_train |>
    ggplot(aes(x = {{ x }}, fill = injurious)) +
    geom_bar(position = "fill") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}
histogram_func <- function(x) {
  traffic_train |>
    ggplot(aes(x = {{ x }})) +
    geom_histogram() +
    facet_wrap(vars(injurious)) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}
boxplot_func <- function(x) {
  traffic_train |>
    ggplot(aes(x = injurious, y = {{ x }})) +
    geom_boxplot()
}
table_func <- function(x) {
  traffic_train |>
    summarize(
      mean({{ x }}, na.rm = TRUE),
      .by = injurious
    )
}
### traffic-related factors
barchart_func(traffic_control_device_i)
barchart_func(street_direction)
barchart_func(intersection_related_i)
barchart_func2(alignment)
barchart_func2(trafficway_type)
boxplot_func(posted_speed_limit)
histogram_func(posted_speed_limit)
table_func(lane_cnt)
### incident-specific factors
barchart_func2(damage)
barchart_func(hit_and_run_i)
histogram_func(num_units)
table_func(num_units)
barchart_func(prim_contributory_cause)
barchart_func(sec_contributory_cause)
barchart_func(first_crash_type)
barchart_func(report_type)
### extraneous factors
barchart_func(weather_condition)
barchart_func(lighting_condition)
barchart_func(roadway_surface_condition)
barchart_func(device_condition)
barchart_func(road_defect)
### temporal factors
histogram_func(hour)
table_func(hour)
histogram_func(year)
table_func(year)
histogram_func(month)
table_func(month)
histogram_func(crash_day_of_week)
table_func(crash_day_of_week)
### chosen predictors (10): `posted_speed_limit`, `lane_cnt`, `device_condition`, `month`, `intersection_related_i`, `lighting_condition`, `trafficway_type`, `first_crash_type`, `report_type`, `num_units`

# multivariate analysis: interaction term selection
### multivariate EDA functions
barchart_new <- function(x, y) {
  traffic_train |>
    ggplot(aes({{ x }}, fill = injurious)) +
    geom_bar(position = "fill") +
    facet_wrap(vars({{ y }})) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}
histogram_new <- function(x, y) {
  traffic_train |>
    ggplot(aes({{ x }}, fill = injurious)) +
    geom_histogram(position = "fill", color = "black") +
    facet_wrap(vars({{ y }})) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}
scatterplot_new <- function(x, y) {
  traffic_train |>
    ggplot(aes({{ x }}, {{ y }})) +
    geom_point() +
    geom_smooth(method = "lm") +
    facet_wrap(vars(injurious))
}
### chosen predictors (11): `alignment`, `posted_speed_limit`, `lane_cnt`, `device_condition`, `month`, `intersection_related_i`, `lighting_condition`, `trafficway_type`, `first_crash_type`, `report_type`, `num_units`
### internal ("number of units involved") and external interactions
barchart_func2(num_units)
barchart_new(num_units, intersection_related_i)
barchart_new(num_units, device_condition)
barchart_new(num_units, lighting_condition)
### external and external interactions
barchart_func2(alignment)
barchart_new(alignment, lighting_condition)
