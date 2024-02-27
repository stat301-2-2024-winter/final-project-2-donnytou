# load packages
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data
load(here("data/traffic_train.rda"))

# build baseline recipe 
traffic_recipe_baseline <- recipe(
  injurious ~ year + month + hour + crash_day_of_week + posted_speed_limit + device_condition + lighting_condition + weather_condition + num_units + report_type + street_direction,
  data = traffic_train
) |>
  step_impute_knn(report_type, street_direction) |>
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