### Tuning, Fitting, and Final Assessment Results

This directory contains results from all scripts used for fitting/training, tuning, and assessing models.


#### Results from Model Competition
- `null_fit`: results from fitting baseline null model to resamples using parametric kitchen sink recipe
- `nbayes_fit`: results from fitting baseline naive Bayes model to resamples using custom naive Bayes recipe
- `logistic_fit1`: results from fitting logistic regression model to resamples using parametric kitchen sink recipe
- `logistic_fit2`: results from fitting a logistic regression model resamples using parametric feature engineered recipe
- `en_tuned1`: results from tuning elastic net model on resamples using parametric kitchen sink recipe
- `en_tuned2`: results from tuning elastic net model on resamples using parametric feature engineered recipe
- `knn_tuned1`: results from tuning K-nearest-neighbors model on resamples using non-parametric kitchen sink recipe
- `knn_tuned2`: results from tuning K-nearest-neighbors model on resamples using non-parametric feature engineered recipe
- `rf_tuned1`: results from tuning random forest model on resamples using non-parametric kitchen sink recipe
- `rf_tuned2`: results from tuning random forest model on resamples using non-parametric feature engineered recipe
- `boosted_tuned1`: results from tuning boosted tree model on resamples using non-parametric kitchen sink recipe
- `boosted_tuned2`: results from tuning boosted tree model on resamples using non-parametric feature engineered recipe
- `combined_accuracy`: combined accuracy results for top model "representatives" across all 12 recipe-model combinations


#### Results from Final Model (`boosted1`) Fit/Assessment
- `final_fit`: results from fitting top-performing model on entire training set
- `final_tibble`: side-by-side tibble comparing actual .vs. true `injurious` class outcomes in the testing set, with class probabilities as well
- `final_accuracy`: final accuracy result for the top-performing model's predictions in the testing set
