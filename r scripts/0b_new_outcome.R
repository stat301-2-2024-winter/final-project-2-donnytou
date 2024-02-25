# load packages
library(tidyverse) 
library(here)
library(caret)

# load data
load(here("data/traffic_data_cleaned.rda"))

# new outcome variable: `injurious`
traffic_data_updated <- traffic_data_cleaned |>
  mutate(
    injurious = if_else(
      injuries_total > 0,
      "Yes",
      if_else(
        injuries_total == 0,
        "No",
        NA
      )
    ),
    injurious = factor(injurious, levels = c("Yes", "No"))
  )
save(
  traffic_data_updated,
  file = here("data/traffic_data_updated.rda")
)

# new outcome variable analysis: missingness and distribution
### missingness
traffic_data_updated |>
  select(injurious) |>
  naniar::miss_var_summary() |>
  knitr::kable()
### distribution (visual)
traffic_data_updated |>
  ggplot(aes(injurious)) +
  geom_bar(fill = "steelblue") +
  theme_minimal()
### distribution (table)
traffic_data_updated |>
  count(injurious) |>
  knitr::kable()



