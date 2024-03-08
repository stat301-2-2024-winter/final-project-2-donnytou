# load packages
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load fitted models
load(here("results/null_fit.rda"))
load(here("results/nbayes_fit.rda"))
load(here("results/logistic_fit1.rda"))
load(here("results/logistic_fit2.rda"))
load(here("results/en_tuned1.rda"))
load(here("results/en_tuned2.rda"))
load(here("results/knn_tuned1.rda"))
load(here("results/knn_tuned2.rda"))
load(here("results/rf_tuned1.rda"))
load(here("results/rf_tuned2.rda"))
load(here("results/boosted_tuned1.rda"))
load(here("results/boosted_tuned2.rda"))

# extract accuracy metrics --> combine into one table
### null fit
null_accuracy <- null_fit |>
  collect_metrics() |>
  filter(.metric == "accuracy") |>
  mutate(model = "null")
### naive Bayes
nbayes_accuracy <- nbayes_fit |>
  collect_metrics() |>
  filter(.metric == "accuracy") |>
  mutate(model = "nbayes")
### logistic fit — kitchen sink
logistic_accuracy1 <- logistic_fit1 |>
  collect_metrics() |>
  filter(.metric == "accuracy") |>
  mutate(model = "logistic1")
### logistic fit — feature engineered
logistic_accuracy2 <- logistic_fit2 |>
  collect_metrics() |>
  filter(.metric == "accuracy") |>
  mutate(model = "logistic2")
### elastic net fit — kitchen sink
en_accuracy1 <- en_tuned1 |>
  collect_metrics() |>
  filter(.metric == "accuracy") |>
  arrange(desc(mean)) |>
  slice_head(n = 1) |>
  mutate(model = "en1")
### elastic net fit — feature engineered
en_accuracy2 <- en_tuned2 |>
  collect_metrics() |>
  filter(.metric == "accuracy") |>
  arrange(desc(mean)) |>
  slice_head(n = 1) |>
  mutate(model = "en2")
### nearest neighbors fit — kitchen sink
knn_accuracy1 <- knn_tuned1 |>
  collect_metrics() |>
  filter(.metric == "accuracy") |>
  arrange(desc(mean)) |>
  slice_head(n = 1) |>
  mutate(model = "knn1")
### nearest neighbors fit — feature engineered
knn_accuracy2 <- knn_tuned2 |>
  collect_metrics() |>
  filter(.metric == "accuracy") |>
  arrange(desc(mean)) |>
  slice_head(n = 1) |>
  mutate(model = "knn2")
### random forest fit — kitchen sink
rf_accuracy1 <- rf_tuned1 |>
  collect_metrics() |>
  filter(.metric == "accuracy") |>
  arrange(desc(mean)) |>
  slice_head(n = 1) |>
  mutate(model = "rf1")
### random forest fit — feature engineered
rf_accuracy2 <- rf_tuned2 |>
  collect_metrics() |>
  filter(.metric == "accuracy") |>
  arrange(desc(mean)) |>
  slice_head(n = 1) |>
  mutate(model = "rf2")
### boosted tree fit — kitchen sink
boosted_accuracy1 <- boosted_tuned1 |>
  collect_metrics() |>
  filter(.metric == "accuracy") |>
  arrange(desc(mean)) |>
  slice_head(n = 1) |>
  mutate(model = "boosted1")
### boosted tree fit — feature engineered
boosted_accuracy2 <- boosted_tuned2 |>
  collect_metrics() |>
  filter(.metric == "accuracy") |>
  arrange(desc(mean)) |>
  slice_head(n = 1) |>
  mutate(model = "boosted2")
### combined fit
combined_accuracy <- bind_rows(
  null_accuracy,
  nbayes_accuracy,
  logistic_accuracy1,
  logistic_accuracy2,
  en_accuracy1,
  en_accuracy2,
  knn_accuracy1,
  knn_accuracy2,
  rf_accuracy1,
  rf_accuracy2,
  boosted_accuracy1,
  boosted_accuracy2
) |>
  select(
    model,
    .metric,
    .estimator,
    mean,
    std_err,
    n
  )

# saving out results
save(
  combined_accuracy,
  file = here("results/combined_accuracy.rda")
)
