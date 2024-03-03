# load packages
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data and recipe
load(here("data/traffic_fold.rda"))
load(here("recipes/recipe1_tree.rda"))
load(here("recipes/recipe2_tree.rda"))

# model specification
rf_spec <- rand_forest(
  trees = 500,
  mtry = tune(),
  min_n = tune()
) |>
  set_engine("ranger") |>
  set_mode("classification")

# create workflows
rf_wflow1 <- workflow() |>
  add_model(rf_spec) |>
  add_recipe(recipe1_tree)
rf_wflow2 <- workflow() |>
  add_model(rf_spec) |>
  add_recipe(recipe2_tree)

# update hyperparameter ranges, build tuning grid
rf_params <- extract_parameter_set_dials(rf_spec) |>
  update(
    mtry = mtry(c(1,5)),
    min_n = min_n(c(2, 40))
  )
rf_grid <- grid_regular(rf_params, levels = 4)

# fit to folds
library(doMC)
registerDoMC(parallel::detectCores(logical = TRUE))
set.seed(2)
rf_tuned1 <- rf_wflow1 |>
  tune_grid(
    traffic_fold,
    grid = rf_grid,
    control = control_grid(save_workflow = TRUE)
  )
registerDoMC(parallel::detectCores(logical = TRUE))
set.seed(2)
rf_tuned2 <- rf_wflow2 |>
  tune_grid(
    traffic_fold,
    grid = rf_grid,
    control = control_grid(save_workflow = TRUE)
  )

# save out fitted workflow
save(
  rf_tuned1,
  file = here("results/rf_tuned1.rda")
)
save(
  rf_tuned2,
  file = here("results/rf_tuned2.rda")
)