# load packages
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# background job for mac
library(doMC)
registerDoMC(parallel::detectCores(logical = TRUE))

# load data and recipe
load(here("data/traffic_fold.rda"))
load(here("recipes/traffic_recipe_baseline.rda"))

# model specification
null_spec <- null_model() |>
  set_engine("parsnip") |>
  set_mode("classification")

# create workflow
null_wflow <- workflow() |>
  add_recipe(traffic_recipe_baseline) |>
  add_model(null_spec)

# fit to folds
null_fit <- fit_resamples(
  null_wflow,
  traffic_fold
)

# save out fitted workflow
save(
  null_fit,
  file = here("results/null_fit.rda")
)