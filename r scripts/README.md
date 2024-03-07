### R scripts

This README explains the code files found within this subdirectory as well as the unique purposes they each serve within the broader modelling process.

- `0a_cleaning_exploration.R`: initial raw data load-in with cleaning and missingness analysis
- `0b_new_outcome.R`: creation of outcome variable with corresponding distribution/missingness analysis
- `1_data_split.R`: initial data split & forming of resamples
- `2a_eda.R`: univariate/bivariate/multivariate EDAs to justify recipe feature selection
- `2b_recipes.R`: data preprocessing/feature engineering for various models
- `3a_fit_null.R`: fitting of baseline null model to resamples 
- `3b_fit_nbayes.R`: fitting of baseline naive Bayes model to resamples 
- `3c_fit_logistic.R`: fitting of logistic regression model to resamples 
- `3d_tune_en.R`: fitting/tuning of elastinc net model to resamples
- `3e_tune_knn.R`: fitting/tuning of k-nearest neighbors model to resamples 
- `3f_tune_rf.R`: fitting/tuning of random forest model to resamples 
- `3g_tune_bt.R`: fitting/tuning of boosted tree model to resamples
- `4_model_analysis.R`: analysis/comparison of models fit to resamples; final model selection
- `5_train_best_model.R`: training/fitting of final model, `boosted1`, on training set
- `6_assess_best_model.R`: assessment of final model, `boosted`, on testing set

