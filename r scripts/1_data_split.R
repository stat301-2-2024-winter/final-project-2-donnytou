# load packages
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data
load(here("data/traffic_data_updated.rda"))

# downsampling using dplyr
traffic_downsampled <- traffic_data_updated |>
  filter(!is.na(injurious)) |>
  slice_sample(
    n = 110241,
    by = injurious
  )

# shrink data set to target size (<50k rows)
set.seed(1)
traffic_split1 <- initial_split(
  traffic_downsampled,
  prop = 0.2,
  strata = injurious
)
traffic_data1 <- training(traffic_split1)
traffic_data_throwaway <- testing(traffic_split1)
save(
  traffic_data_throwaway,
  file = here("data/traffic_data_throwaway.rda")
)

# initial split
set.seed(1)
traffic_split <- initial_split(
  traffic_data1,
  prop = .8,
  strata = injurious
)
traffic_train <- training(traffic_split)
traffic_test <- testing(traffic_split)

# split verification
### observation count
traffic_split
.8 * 44096
.2 * 44096

### outcome variable distribution check
traffic_train |>
  ggplot(aes(injurious)) +
  geom_bar(fill = "steelblue") +
  theme_minimal() 
traffic_test |>
  ggplot(aes(injurious)) +
  geom_bar(fill = "steelblue") +
  theme_minimal()

# V-fold cross validation
set.seed(2)
traffic_fold <- vfold_cv(
  traffic_train,
  v = 5,
  repeats = 3,
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

