# load packages
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data
load(here("data/traffic_train.rda"))
load(here("data/traffic_data_throwaway.rda"))

# background job for mac
library(doMC)
registerDoMC(parallel::detectCores(logical = TRUE))

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
    starts_with("work"),
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
    dooring_i,
    photos_taken_i,
    statements_taken_i,
    not_right_of_way_i,
    traffic_control_device,
    fatal_i
  ) |>
  step_impute_knn(
    hit_and_run_i,
    lane_cnt,
    intersection_related_i,
    report_type,
    latitude,
    longitude,
    street_direction
  ) |>
  step_dummy(all_nominal_predictors()) |>
  step_normalize(all_numeric_predictors())
feature_wflow <- workflow() |>
  add_recipe(feature_recipe) |>
  add_model(feature_spec)
traffic_data_throwaway_downsized <- initial_split(
  traffic_data_throwaway,
  prop = 0.2
) |>
  training()
feature_fit <- fit(feature_wflow, traffic_data_throwaway_downsized)
save(
  feature_fit,
  file = here("feature_fit.rda")
)
coef(feature_fit |>
       extract_fit_engine())

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

### build parametric recipes: linear regression, elastic net model, k-nearest neighbor ---------
# variant 1
traffic_recipe_log1 <- recipe(
  injurious ~ year + month + weekday + hour + traffic_control_device_i + num_units + street_direction + damage + hit_and_run_i + intersection_related_i + alignment + lane_cnt + speed_limit + device_condition + weather_condition + lighting_condition + latitude + longitude,
  data = traffic_train |>
    rename(
      weekday = crash_day_of_week,
      speed_limit = posted_speed_limit
    )
) |>
  step_zv(all_predictors()) |>
  step_impute_knn(
    lane_cnt,
    hit_and_run_i,
    intersection_related_i,
    latitude,
    longitude
  ) |>
  step_dummy(all_nominal_predictors()) |>
  step_interact() |> 
  step_normalize(all_numerical_predictors())
# variant 2
### change: interaction terms, predictors
traffic_recipe_log2 <- recipe(
  
)

### build non-parametric recipes: random forest, boosted trees, k-nearest neighbor ---------
# variant 1
traffic_recipe_tree1 <- recipe(
  injurious ~ year + month + weekday + hour + traffic_control_device_i + num_units + street_direction + damage + hit_and_run_i + intersection_related_i + alignment + lane_cnt + speed_limit + device_condition + weather_condition + lighting_condition + latitude + longitude,
  data = traffic_train |>
    rename(
      weekday = crash_day_of_week,
      speed_limit = posted_speed_limit
    )
) |>
  step_zv(all_predictors()) |>
  step_impute_knn(
    lane_cnt,
    hit_and_run_i,
    intersection_related_i,
    latitude,
    longitude
  ) |>
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_normalize(all_numerical_predictors())
# variant 2

# save recipe
save(
  traffic_recipe_baseline,
  file = here("recipes/traffic_recipe_baseline.rda")
)