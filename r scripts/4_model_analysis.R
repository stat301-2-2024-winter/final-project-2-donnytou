# load packages
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load fitted models
load(here("results/null_fit.rda"))
load(here("results/logistic_fit.rda"))

# extract accuracy metrics --> combine into one table
### null fit
null_accuracy <- null_fit |>
  collect_metrics(metric = "accuracy") |>
  select(.metric = "accuracy")
### logistic fit
logistic_accuracy <- logistic_fit |>
  collect_metrics(metric = "accuracy") |>
  select(.metric = "accuracy")
### combined fit
combined_accuracy <- bind_rows(
  null_accuracy,
  logistic_accuracy
)

