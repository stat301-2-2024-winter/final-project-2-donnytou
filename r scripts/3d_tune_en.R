# load packages
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data and recipe
load(here("data_splits/traffic_fold.rda"))
load(here("recipes/recipe1_parametric.rda"))
load(here("recipes/recipe2_parametric.rda"))

# model specification
en_spec <- logistic_reg(
  mixture = tune(),
  penalty = tune()
) |>
  set_engine("glmnet") |>
  set_mode("classification")

# create workflows
en_wflow1 <- workflow() |>
  add_model(en_spec) |>
  add_recipe(recipe1_parametric)
en_wflow2 <- workflow() |>
  add_model(en_spec) |>
  add_recipe(recipe2_parametric)

# update hyperparameter ranges, build tuning grid
en_params <- extract_parameter_set_dials(en_spec) |>
  update(
    mixture = mixture(c(0, 1)),
    penalty = penalty(c(-3, 0))
  )
en_grid <- grid_regular(en_params, levels = 10)

# fit to folds
library(doMC)
registerDoMC(parallel::detectCores(logical = TRUE))
set.seed(2)
en_tuned1 <- en_wflow1 |>
  tune_grid(
    traffic_fold,
    grid = en_grid,
    control = control_grid(save_workflow = TRUE)
  )
registerDoMC(parallel::detectCores(logical = TRUE))
set.seed(2)
en_tuned2 <- en_wflow2 |>
  tune_grid(
    traffic_fold,
    grid = en_grid,
    control = control_grid(save_workflow = TRUE)
  )

# save out fitted workflow
save(
  en_tuned1,
  file = here("results/en_tuned1.rda")
)
save(
  en_tuned2,
  file = here("results/en_tuned2.rda")
)