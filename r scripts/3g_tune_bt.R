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
boosted_spec <- boost_tree(
  trees = 500,
  mtry = tune(),
  min_n = tune(),
  learn_rate = tune()
) |>
  set_engine("xgboost") |>
  set_mode("classification")

# create workflows
boosted_wflow1 <- workflow() |>
  add_model(boosted_spec) |>
  add_recipe(recipe1_tree)
boosted_wflow2 <- workflow() |>
  add_model(boosted_spec) |>
  add_recipe(recipe2_tree)

# update hyperparameter ranges, build tuning grid
boosted_params <- extract_parameter_set_dials(boosted_spec) |>
  update(
    mtry = mtry(c(1, 5)),
    min_n = min_n(c(2, 40)),
    learn_rate = learn_rate(c(-5, -0.2))
  )
boosted_grid <- grid_regular(boosted_params, levels = 4)

# fit to folds
library(doMC)
registerDoMC(parallel::detectCores(logical = TRUE))
set.seed(2)
boosted_tuned1 <- boosted_wflow1 |>
  tune_grid(
    traffic_fold,
    grid = boosted_grid,
    control = control_grid(save_workflow = TRUE)
  )
registerDoMC(parallel::detectCores(logical = TRUE))
set.seed(2)
boosted_tuned2 <- boosted_wflow2 |>
  tune_grid(
    traffic_fold,
    grid = boosted_grid,
    control = control_grid(save_workflow = TRUE)
  )

# save out fitted workflow
save( 
  boosted_tuned1,
  file = here("results/boosted_tuned1.rda")
)
save(
  boosted_tuned2,
  file = here("results/boosted_tuned2.rda")
)