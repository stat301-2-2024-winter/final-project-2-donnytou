## Overview

This folder contains initial setup data objects for this project.

- `traffic_split.rda`: RSplit object resulting from initial split; can derive the testing and training dataset from this object
- `traffic_train.rda`: Training dataset derived from `traffic_split`
- `traffic_test.rda`: Testing dataset derived from `traffic_split`
- `traffic_fold.rda`: Resampled data derived from `traffic_train` using 5-fold cross-validation; used for model competition, tuning, and performance estimation
- `traffic_data_throwaway.rda`: Portion of original dataset (post-downsampling) separate from `traffic_split`; used for univariate, bivariate, and multivariate EDAs