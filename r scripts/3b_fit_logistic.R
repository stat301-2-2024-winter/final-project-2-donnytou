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
logistic_spec <- logistic_reg() |>
  set_engine("glm") |>
  set_mode("classification")

# create workflow
logistic_wflow <- workflow() |>
  add_recipe(traffic_recipe_baseline) |>
  add_model(logistic_spec) 

# fit to folds
logistic_fit <- fit_resamples(
  logistic_wflow,
  traffic_fold
)

# save out fitted workflow
save(
  logistic_fit,
  file = here("results/logistic_fit.rda")
)