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
knn_spec <- nearest_neighbor(
  neighbors = tune()
) |>
  set_engine("kknn") |>
  set_mode("classification")

# create workflows
knn_wflow1 <- workflow() |>
  add_model(knn_spec) |>
  add_recipe(recipe1_tree)
knn_wflow2 <- workflow() |>
  add_model(knn_spec) |>
  add_recipe(recipe2_tree)

# update hyperparameter ranges, build tuning grid
knn_params <- extract_parameter_set_dials(knn_spec) |>
  update(
    neighbors = neighbors(c(1, 15))
  )
knn_grid <- grid_regular(knn_params, levels = 5)

# fit to folds
library(doMC)
registerDoMC(parallel::detectCores(logical = TRUE))
set.seed(2)
knn_tuned1 <- knn_wflow1 |>
  tune_grid(
    traffic_fold,
    grid = knn_grid,
    control = control_grid(save_workflow = TRUE)
  )
registerDoMC(parallel::detectCores(logical = TRUE))
set.seed(2)
knn_tuned2 <- knn_wflow2 |>
  tune_grid(
    traffic_fold,
    grid = knn_grid,
    control = control_grid(save_workflow = TRUE)
  )

# save out fitted workflow
save(
  knn_tuned1,
  file = here("results/knn_tuned1.rda")
)
save(
  knn_tuned2,
  file = here("results/knn_tuned2.rda")
)