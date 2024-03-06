# load packages
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data
load(here("data_splits/traffic_test.rda"))

# load fitted results
load(here("results/final_fit.rda"))

# predict on test set and assess results
### create probability/class prediction set
final_class <- predict(
  final_fit,
  new_data = traffic_test,
  type = "class"
)
final_prob <- predict(
  final_fit,
  new_data = traffic_test,
  type = "prob"
)
final_tibble <- traffic_test |>
  select(injurious) |>
  bind_cols(final_class, final_prob)
### assess using `accuracy`
final_accuracy <- final_tibble |>
  accuracy(
    truth = injurious,
    estimate = .pred_class
  )
### save out
save(
  final_tibble,
  file = here("results/final_tibble.rda")
)
save(
  final_accuracy,
  file = here("results/final_accuracy.rda")
)

# visualize results
### create confusion matrix
final_conf <- final_tibble |>
  conf_mat(
    truth = injurious,
    estimate = .pred_class
  ) |>
  autoplot(type = "heatmap") +
  scale_fill_gradient(low = "skyblue", high = "cornflowerblue")
### save out
save(
  final_conf,
  file = here("plots/final_conf.rda")
)