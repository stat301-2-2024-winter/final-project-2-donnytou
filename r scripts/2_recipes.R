# load packages
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data
load(here("data/traffic_train.rda"))
load(here("data/traffic_data_throwaway.rda"))

# feature selection using logistic lasso
feature_spec <- logistic_reg(penalty = 0.01, mixture = 1) |>
  set_engine("glmnet") |>
  set_mode("classification")
feature_recipe <- recipe(
  injurious ~ .,
  traffic_data_throwaway
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
    not_right_of_way_i,
    traffic_control_device,
    fatal_i
  ) |>
  step_impute_knn(
    hit_and_run_i,
    report_type,
    latitude,
    longitude,
    street_direction
  ) |>
  step_dummy(all_nominal_predictors())
feature_wflow <- workflow() |>
  add_recipe(feature_recipe) |>
  add_model(feature_spec)
feature_fit <- fit(feature_wflow, traffic_data_throwaway)
feature_fit |> 
  extract_fit_engine() |>
  summary()

# build baseline recipe 
traffic_recipe_baseline <- recipe(
  injurious ~ month + posted_speed_limit + weather_condition + street_direction,
  data = traffic_train
) |>
  step_impute_knn(street_direction) |>
  step_dummy(all_nominal_predictors()) |>
  step_zv(all_predictors()) |>
  step_normalize(all_numeric_predictors())

# check recipe
prep(traffic_recipe_baseline) |>
  bake(new_data = NULL)

# save recipe
save(
  traffic_recipe_baseline,
  file = here("recipes/traffic_recipe_baseline.rda")
)