# MAKE SURE TO COMMENT OUT LINES 65 and 66 in set_up_data.R file
# This is to override scaling in order to find cholesterol measures (high, borderline, normal)

## Decision Tree with Random Forests


colnames(train_data)
colnames(test_data)

summary(train_data$LBXTC)

# Creating an indicator variable
train_data$highchol = as.factor(ifelse(train_data$LBXTC >= 239, "Yes", "No"))
test_data$highchol = as.factor(ifelse(test_data$LBXTC >= 239, "Yes", "No"))

table(train_data$highchol)

# Deleting variables that are directly related to cholesterol levels
train_data$LBXTC = NULL
test_data$LBXTC = NULL
train_data$LBDTCSI = NULL
test_data$LBDTCSI = NULL

# Deleting variables that are not informative
train_data$SEQN = NULL
train_data$SMAQUEX2 = NULL
test_data$SEQN = NULL
test_data$SMAQUEX2 = NULL

# deleting unique variables between train and test sets
test_data$DMDHRBR4 = NULL
train_data$y = NULL

# install package groupdata to upsample the train set in order to balance out response classes
#install.packages("groupdata2")
library(groupdata2)

# upsampling train set
set.seed(123)
train_data = upsample(train_data, cat_col = "highchol")

table(train_data$highchol)

# running a random forest algorithm
#install.packages("randomForest")
library(randomForest)
m = 12
mod_rf = randomForest(highchol~., data = train_data, mtry = m, ntree = 1000, importance = T)

# looking at most important variables
mod_rf
varImpPlot(mod_rf) # looks like age (RIDAGEYR) is highly affecting results, so let's try to run another model without age as a predictor

rf_pred = predict(mod_rf, test_data)
test_err = mean(test_data$highchol != rf_pred)
test_err

# Removing age as a predictor variable
train_data_a = train_data
test_data_a = test_data
train_data_a$RIDAGEYR = NULL
test_data_a$RIDAGEYR = NULL

mod_rf_2 = randomForest(highchol~., data = train_data_a, mtry = m, ntree = 1000, importance = T)

varImpPlot(mod_rf_2)

rf_2_pred = predict(mod_rf_2, test_data_a)
table(rf_2_pred, test_data_a$highchol)


## Decision Tree with Boosting

train_data_b = train_data_a
train_data_b$highchol = ifelse(train_data_b$highchol == "Yes", 1, 0)
test_data_b = test_data_a
test_data_b$highchol = ifelse(test_data_b$highchol == "Yes", 1, 0)


range = seq(500, 2000, by = 100)
test_err = c()
train_err = c()
library(gbm)
for(i in range) {
  mod_adaboost = gbm(highchol~ ., data = train_data_b, distribution="adaboost", n.trees= i)
  
  train_pred = predict(mod_adaboost, train_data_b, n.trees = i, type='response')
  train_pred = ifelse(train_pred > 0.5, 1, 0)
  train_err_i = mean(train_data_b$highchol != train_pred)
  
  
  test_pred = predict(mod_adaboost, test_data_b, n.trees = i, type='response')
  test_pred = ifelse(test_pred > 0.5, 1, 0)
  test_err_i = mean(test_data_b$highchol != test_pred)
  
  train_err = c(train_err, train_err_i)
  test_err = c(test_err, test_err_i)
}

par(mfrow = c(1,2))
plot(range, train_err, type = "b")
plot(range, test_err, type = "b")

mod_adaboost_optimal = gbm(highchol~., data = train_data_b, distribution="adaboost", n.trees= 950)
summary(mod_adaboost_optimal)

test_pred_adaboost = predict(mod_adaboost_optimal, test_data_b, n.trees = 950, type='response')
test_pred_adaboost = ifelse(test_pred_adaboost > 0.5, 1, 0)
table(test_pred_adaboost, test_data_b$highchol)
test_err_adaboost = mean(test_data_b$highchol != test_pred_adaboost)


## ANN Model
install.packages("nnet")
library(nnet)
library(caret)

range_nn = range = seq(1, 7, by = 1)
test_err_nn = c()
for (i in range_nn) {
  mod_nn_i = nnet(highchol~ _______, data = train_data_a, size=i, decay=5e-4, maxit=100)
  nn_pred_i = predict(mod_nn_i, test_data_a)
  nn_pred_i = ifelse(nn_pred_i > .5, "Yes", "No")
  test_err_nn_i = mean(test_data_a$highchol != nn_pred_i)
  test_err_nn = c(test_err_nn, test_err_nn_i)
}

mod_nn = nnet(highchol~., data = train_data, size=5, decay=5e-4, maxit=100)
mod_nn
nn_pred = predict(mod_nn, test_data)
nn_pred = ifelse(nn_pred > .5, "Yes", "No")
table(nn_pred, test_data$highchol)


grid <- expand.grid(.size = c(1, 2, 3, 4, 5, 6, 7),
                    .decay = c(1e-5, 1e-4, 1e-3, 1e-2))
mod_nn_tune <- train(highchol~., data = train_data, method = "nnet", preProcess = c("center","scale"),
                     tuneGrid = grid)
mod_nn_tune

