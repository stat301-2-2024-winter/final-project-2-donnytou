# load packages
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data
load(here("data_splits/traffic_train.rda"))

# load tuned results and extract optimal model
load(here("results/boosted_tuned1.rda"))
final_wflow <- boosted_tuned1 |>
  extract_workflow(boosted_tuned1) |>
  finalize_workflow(select_best(boosted_tuned1, metric = "accuracy"))

# fit final workflow
set.seed(3)
final_fit <- fit(
  final_wflow,
  data = traffic_train
)

# save out results
save(
  final_fit,
  file = here("results/final_fit.rda")
)