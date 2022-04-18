
## EDA for classification model

boxplot(RIDAGEYR~highchol,data=train_data, main="High Cholesterol Data", xlab="High Cholesterol Status", ylab="Age")
boxplot(BPXDI1~highchol,data=train_data, main="High Cholesterol Data", xlab="High Cholesterol Status", ylab="Blood Pressure")
boxplot(INDHHIN2~highchol,data=train_data, main="High Cholesterol Data", xlab="High Cholesterol Status", ylab="Household Income")
boxplot(BMXWT~highchol,data=train_data, main="High Cholesterol Data", xlab="High Cholesterol Status", ylab="Weight")


head(train_data)

