# load packages
library(tidyverse)
library(tidymodels)
library(here)

# load data
load(here("data/traffic_train.rda"))

# build baseline recipe 
traffic_recipe_baseline <- recipe(
  formula = injurious ~.,
  data = traffic_train
) |>
  step_rm(
    starts_with("injuries"),
    crash_time,
    crash_date_new,
    most_severe_injury,
    location,
    crash_month,
    crash_hour,
    street_name,
    street_no,
    date_police_notified,
    crash_date_est_i,
    crash_record_id,
    beat_of_occurrence,
    crash_type,
    workers_present_i,
    dooring_i,
    work_zone_type,
    work_zone_i,
    photos_taken_i,
    statements_taken_i,
    not_right_of_way_i
  ) |>
  step_impute_knn(
    hit_and_run_i,
    report_type,
    latitude,
    longitude,
    fatal_i,
    street_direction
  ) |>
  step_dummy(all_nominal_predictors()) |>
  step_zv(all_predictors()) |>
  step_normalize(all_numeric_predictors())

# check recipe
prep(traffic_recipe_baseline) |>
  bake(new_data = NULl)