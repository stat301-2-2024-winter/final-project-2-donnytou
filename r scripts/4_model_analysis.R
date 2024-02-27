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
  collect_metrics() |>
  filter(.metric == "accuracy") |>
  mutate(model = "null")
### logistic fit
logistic_accuracy <- logistic_fit |>
  collect_metrics() |>
  filter(.metric == "accuracy") |>
  mutate(model = "logistic")
### combined fit
combined_accuracy <- bind_rows(
  null_accuracy,
  logistic_accuracy
)

# saving out results
save(
  null_accuracy,
  file = here("results/null_accuracy.rda")
)
save(
  logistic_accuracy,
  file = here("results/logistic_accuracy.rda")
)
save(
  combined_accuracy,
  file = here("results/combined_accuracy.rda")
)


