# load packages
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data
load(here("data_splits/traffic_train.rda"))

# background job for mac
library(doMC)
registerDoMC(parallel::detectCores(logical = TRUE))

# parametric/non-tree-based recipes ------------
### baseline kitchen sink recipe
recipe1_parametric <- recipe(
  injurious ~ .,
  data = traffic_train
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
  step_zv(all_predictors()) |>
  step_normalize(all_numeric_predictors())
### check recipe
prep(recipe1_parametric) |>
  bake(new_data = NULL)
### naive Bayes recipe
recipe_naive <- recipe(
  injurious ~ .,
  data = traffic_train
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
  step_zv(all_predictors()) |>
  step_normalize(all_numeric_predictors())
### check recipe
prep(recipe_naive) |>
  bake(new_data = NULL)
### post-feature-engineering recipe
recipe2_parametric <- recipe(
  injurious ~ alignment + posted_speed_limit + lane_cnt + intersection_related_i + trafficway_type + device_condition + report_type + first_crash_type + num_units + lighting_condition + month,
  data = traffic_train
) |>
  step_impute_knn(
    lane_cnt,
    intersection_related_i,
    report_type
  ) |>
  step_dummy(all_nominal_predictors()) |>
  step_interact(terms = ~ starts_with("lighting_condition_"):num_units) |>
  step_interact(terms = ~ starts_with("trafficway_type_"):num_units) |>
  step_interact(terms = ~ starts_with("lighting_condition_"):starts_with("alignment_")) |>
  step_interact(terms = ~ starts_with("intersection_related_i_"):starts_with("alignment_")) |>
  step_zv(all_predictors()) |>
  step_normalize(all_numeric_predictors())
### check recipe
glimpse(prep(recipe2_parametric) |>
  bake(new_data = NULL))

# non-parametric/tree-based recipes ------------
### baseline kitchen sink recipe
recipe1_tree <- recipe(
  injurious ~ .,
  data = traffic_train
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
  step_dummy(
    all_nominal_predictors(),
    one_hot = TRUE
  ) |>
  step_zv(all_predictors()) |>
  step_normalize(all_numeric_predictors())
### check recipe
prep(recipe1_tree) |>
  bake(new_data = NULL)
#### post-feature-engineering recipe
recipe2_tree <- recipe(
  injurious ~ alignment + posted_speed_limit + lane_cnt + intersection_related_i + trafficway_type + device_condition + report_type + first_crash_type + num_units + lighting_condition + month,
  data = traffic_train
) |>
  step_impute_knn(
    lane_cnt,
    intersection_related_i,
    report_type
  ) |>
  step_dummy(
    all_nominal_predictors(), 
    one_hot = TRUE
  ) |>
  step_zv(all_predictors()) |>
  step_normalize(all_numeric_predictors())
### check recipe
prep(recipe2_tree) |>
  bake(new_data = NULL)

# save recipes
save(
  recipe1_parametric,
  file = here("recipes/recipe1_parametric.rda")
)
save(
  recipe_naive,
  file = here("recipes/recipe_naive.rda")
)
save(
  recipe2_parametric,
  file = here("recipes/recipe2_parametric.rda")
)
save(
  recipe1_tree,
  file = here("recipes/recipe1_tree.rda")
)
save(
  recipe2_tree,
  file = here("recipes/recipe2_tree.rda")
)
