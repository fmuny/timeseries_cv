# Load packages
require(caret)
require(ggplot2)
require(devtools)

# Load data from ggplot package
data("economics")

# Load functions from github
source_url("https://raw.githubusercontent.com/fmuny/timeseries_cv/master/code/cv_functions.R")

# Compute first differences and plot
df_ts <- diff(ts(economics[,2:6], start = c(1967, 7), frequency = 12))
plot(df_ts)

# Split in training and test set
df_train <- window(df_ts, start = c(1990, 1), end = c(2000, 12))
df_test  <- window(df_ts, start = c(2001, 1), end = c(2005, 12))

# 1.) How to use Timeslice
# Prepare indices
fitControl <- trainControl('timeslice', initialWindow = 12, horizon = 12)
# Run ML model
set.seed(156)
model_ts <- train(pce ~., data = df_train, method = "rf", trControl = fitControl)
# Predict on test set
pred_ts <- predict(model_ts, newdata = df_test[,-1])
# Compute performance measures 
perf_ts <- postResample(pred = pred_ts, obs = df_test[,1])

# 2.) How to use hv-block cross-validation
# Prepare indices
hv <- hv_block(df_train, v_before=12, v_after=12, gap_before=12, gap_after=12)
fitControl <- trainControl("cv", index = hv[['training']], 
                           indexOut = hv[['validation']])
# Run ML model
set.seed(156)
model_hv <- train(pce ~., data = df_train, method = "rf", trControl = fitControl)
# Predict on test set
pred_hv <- predict(model_hv, newdata = df_test[,-1])
# Compute performance measures 
perf_hv <- postResample(pred = pred_hv, obs = df_test[,1])

# 3.) How to use simplified block cross-validation
# Prepare indices
simp <- simplified_block(df_train, n_splits=5, gap_before=12, gap_after=12)
fitControl <- trainControl("cv", index = simp[['training']], 
                           indexOut = simp[['validation']])
# Run ML model
set.seed(156)
model_si <- train(pce ~., data = df_train, method = "rf", trControl = fitControl)
# Predict on test set
pred_si <- predict(model_si, newdata = df_test[,-1])
# Compute performance measures 
perf_si <- postResample(pred = pred_si, obs = df_test[,1])['RMSE']

# 4.) Compare results
data.frame(In_sample_RMSE = c(round(min(model_ts$results$RMSE),3),
                              round(min(model_hv$results$RMSE),3),
                              round(min(model_si$results$RMSE),3)),
           Out_of_sample_RMSE = c(round(perf_ts['RMSE'],3),
                                  round(perf_hv['RMSE'],3),
                                  round(perf_si['RMSE'],3)),
           row.names = c('Timeslice','hv-block', 'Simplified block'))