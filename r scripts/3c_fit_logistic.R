# load packages
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data and recipes
load(here("data_splits/traffic_fold.rda"))
load(here("recipes/recipe1_parametric.rda"))
load(here("recipes/recipe2_parametric.rda"))

# model specification
logistic_spec <- logistic_reg() |>
  set_engine("glm") |>
  set_mode("classification")

# create workflows
logistic_wflow1 <- workflow() |>
  add_recipe(recipe1_parametric) |>
  add_model(logistic_spec) 
logistic_wflow2 <- workflow() |>
  add_recipe(recipe2_parametric) |>
  add_model(logistic_spec)

# fit to folds
library(doMC)
registerDoMC(parallel::detectCores(logical = TRUE))
set.seed(2)
logistic_fit1 <- fit_resamples(
  logistic_wflow1,
  traffic_fold
)
registerDoMC(parallel::detectCores(logical = TRUE))
set.seed(2)
logistic_fit2 <- fit_resamples(
  logistic_wflow2,
  traffic_fold
)

# save out fitted workflow
save(
  logistic_fit1,
  file = here("results/logistic_fit1.rda")
)
save(
  logistic_fit2,
  file = here("results/logistic_fit2.rda")
)