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

# create workflow

# fit to folds
set.seed(2)

# save out fitted workflow