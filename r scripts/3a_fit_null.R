# load packages
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data and recipe
load(here("data/traffic_fold.rda"))
load(here("recipes/recipe1_parametric.rda"))

# model specification
null_spec <- null_model() |>
  set_engine("parsnip") |>
  set_mode("classification")

# create workflow
null_wflow <- workflow() |>
  add_recipe(recipe1_parametric) |>
  add_model(null_spec)

# fit to folds
library(doMC)
registerDoMC(parallel::detectCores(logical = TRUE))
set.seed(2)
null_fit <- fit_resamples(
  null_wflow,
  traffic_fold
)

# save out fitted workflow
save(
  null_fit,
  file = here("results/null_fit.rda")
)