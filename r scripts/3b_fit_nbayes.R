# load packages
library(tidyverse)
library(tidymodels)
library(here)
library(discrim)

# handle common conflicts
tidymodels_prefer()

# load data and recipe
load(here("data_splits/traffic_fold.rda"))
load(here("recipes/recipe_naive.rda"))

# model specification
nbayes_spec <- naive_Bayes() |>
  set_engine("klaR") |>
  set_mode("classification")

# create workflow
nbayes_wflow <- workflow() |>
  add_recipe(recipe_naive) |>
  add_model(nbayes_spec)

# fit to folds
library(doMC)
registerDoMC(parallel::detectCores(logical = TRUE))
set.seed(2)
nbayes_fit <- fit_resamples(
  nbayes_wflow,
  traffic_fold
)

# save out fitted workflow
save(
  nbayes_fit,
  file = here("results/nbayes_fit.rda")
)