# load packages
library(tidyverse)
library(here)

# load, clean dataset
hotel_data <- read_csv("data/hotel_bookings.csv") 
glimpse(hotel_data)
