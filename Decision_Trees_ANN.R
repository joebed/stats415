# MAKE SURE TO COMMENT OUT LINES 65 and 66 in set_up_data.R file
# This is to override scaling in order to find cholesterol measures (high, borderline, normal)

## Decision Tree with Random Forests

colnames(train_data)
colnames(test_data)
summary(train_data$LBXTC)
train_data$highchol = as.factor(ifelse(train_data$LBXTC >= 239, "Yes", "No"))
#train_data$borderlinechol = as.factor(ifelse(train_data$LBXTC >= 200, "Yes", "No"))

test_data$highchol = as.factor(ifelse(test_data$LBXTC >= 239, "Yes", "No"))
#test_data$borderlinechol = as.factor(ifelse(test_data$LBXTC >= 200, "Yes", "No"))

train_data$LBXTC = NULL
test_data$LBXTC = NULL
train_data$LBDTCSI = NULL
test_data$LBDTCSI = NULL

train_data$SEQN = NULL
train_data$SMAQUEX2 = NULL
test_data$SEQN = NULL
test_data$SMAQUEX2 = NULL

train_data$RIDAGEYR = NULL
test_data$RIDAGEYR = NULL

test_data$DMDHRBR4 = NULL
train_data$y = NULL

#install.packages("groupdata2")
library(groupdata2)

train_data = upsample(train_data, cat_col = "highchol")

#install.packages("randomForest")
library(randomForest)
m = 12
#.-borderlinechol
mod_rf = randomForest(highchol~., data = train_data, mtry = m, ntree = 1000, importance = T)

mod_rf
varImpPlot(mod_rf)

rf_pred = predict(mod_rf, test_data)
rf_pred
table(rf_pred, test_data$highchol)

#mod_rf_2 = randomForest(borderlinechol~ .-highchol, data = train_data, mtry = m, ntree = 1000, importance = T)

#summary(mod_rf_2)
#varImpPlot(mod_rf_2)

#rf_2_pred = predict(mod_rf_2, test_data)
#table(rf_pred, test_crabs$sp)

#train_data$BP_Systolic = (train_data$BPXSY1 + train_data$BPXSY2 + train_data$BPXSY3)/3
#summary(train_data$BP_Systolic)

#train_data$BP_Diastolic = (train_data$BPXDI1 + train_data$BPXDI2 + train_data$BPXDI3)/3
#summary(train_data$BP_Diastolic)


## Decision Tree with Boosting
train_data_b = train_data
train_data_b$highchol = ifelse(train_data_b$highchol == "Yes", 1, 0)
test_data_b = test_data
test_data_b$highchol = ifelse(test_data_b$highchol == "Yes", 1, 0)


range = seq(100, 1000, by = 50)
test_err = c()
train_err = c()
library(gbm)
for(i in range) {
  mod_adaboost = gbm(highchol~ .-borderlinechol, data = train_data_b, distribution="adaboost", n.trees= i)
  
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

mod_adaboost_optimal = gbm(highchol~ .-borderlinechol, data = train_data_b, distribution="adaboost", n.trees= 200)

test_pred_adaboost = predict(mod_adaboost_optimal, test_data_b, n.trees = 200, type='response')
test_pred_adaboost = ifelse(test_pred_adaboost > 0.5, 1, 0)
table(test_pred_adaboost)
test_err_adaboost = mean(test_data_b$highchol != test_pred_adaboost)


## ANN Model
install.packages("keras")
