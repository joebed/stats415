# MAKE SURE TO COMMENT OUT LINES 65 and 66 in set_up_data.R file
# This is to override scaling in order to find cholesterol measures (high, borderline, normal)

## Decision Tree with Random Forests


summary(train_data$LBXTC)
train_data$highchol = as.factor(ifelse(train_data$LBXTC >= 239, "Yes", "No"))
train_data$borderlinechol = as.factor(ifelse(train_data$LBXTC >= 200, "Yes", "No"))

test_data$highchol = as.factor(ifelse(test_data$LBXTC >= 239, "Yes", "No"))
test_data$borderlinechol = as.factor(ifelse(test_data$LBXTC >= 200, "Yes", "No"))

train_data$LBXTC = NULL
test_data$LBXTC = NULL
train_data$LBDTCSI = NULL
test_data$LBDTCSI = NULL

train_data$y = NULL
#install.packages("randomForest")
library(randomForest)
m = 12
mod_rf = randomForest(highchol~ .-borderlinechol, data = train_data, mtry = m, ntree = 1000, importance = T)

varImpPlot(mod_rf)

mod_rf_2 = randomForest(borderlinechol~ .-highchol, data = train_data, mtry = m, ntree = 1000, importance = T)

varImpPlot(mod_rf_2)

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
## ANN Model

