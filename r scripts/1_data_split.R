# load packages
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data
load(here("data/traffic_data_updated.rda"))

# initial split
set.seed(1)
traffic_split <- initial_split(
  traffic_data_updated,
  prop = .8,
  strata = injurious
)
traffic_train <- training(traffic_split)
traffic_test <- testing(traffic_split)

# split verification
### observation count
traffic_split
.8 * 803144
.2 * 803144

### outcome variable distribution check
traffic_train |>
  ggplot(aes(injurious)) +
  geom_bar() +
  theme_minimal()
traffic_test |>
  ggplot(aes(injurious)) +
  geom_bar() +
  theme_minimal()

# V-fold cross validation
set.seed(2)
traffic_fold <- vfold_cv(
  traffic_train,
  v = 5,
  repeats = 5,
  strata = injurious
)

# save out data
save(
  traffic_train,
  file = here("data/traffic_train.rda")
)
save(
  traffic_test,
  file = here("data/traffic_test.rda")
)
save(
  traffic_fold,
  file = here("data/traffic_fold.rda")
)

