# load packages
library(tidyverse) 
library(here)
library(caret)

# handle common conflicts
tidymodels_prefer()

# load data
load(here("data/traffic_data_cleaned.rda"))

# new outcome variable `injurious` + new dttm variables as predictors
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
    injurious = factor(injurious, levels = c("Yes", "No")),
    crash_date_new = mdy(str_sub(
      crash_date,
      start = 1,
      end = 10
    )), 
    placeholder1 = str_sub(
      crash_date,
      start = 12,
      end = 22
    ),
    crash_time = parse_date_time(
      placeholder1,
      "%H:%M:%S %p"
    ),
    year = year(crash_date_new),
    month = month(crash_date_new),
    hour = hour(crash_time)
  ) |>
  select(-c(crash_date, placeholder1))
save(
  traffic_data_updated,
  file = here("data/traffic_data_updated.rda")
)

# new outcome variable analysis: missingness and distribution
### missingness
missing_injurious <- traffic_data_updated |>
  select(injurious) |>
  naniar::miss_var_summary() |>
  knitr::kable()
save(
  missing_injurious,
  file = here("plots/missing_outcome.rda")
)
### distribution (visual)
distribution_outcome1 <- traffic_data_updated |>
  filter(!is.na(injurious)) |>
  ggplot(aes(injurious)) +
  geom_bar(fill = "skyblue") +
  theme_minimal() +
  labs(
    title = "Distribution of traffic collisions by injuriousness",
    subtitle = "The vast majority of traffic collisions leave involved agents unscathed"
  )
save(
  distribution_outcome1,
  file = here("plots/distribution_outcome1.rda")
)
### distribution (table)
distribution_outcome2 <- traffic_data_updated |>
  filter(!is.na(injurious)) |>
  count(injurious) 
save(
  distribution_outcome2,
  file = here("plots/distribution_outcome2.rda")
)




