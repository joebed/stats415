# Bayesian Additive Trees
library(BART)

set.seed(234523)
train = sample(8921, .8 * 8921)

x = train_data[,3:144]
y = train_data[,2]
xtrain = x[train,]
ytrain = y[train]
xtest = x[-train,]
ytest = y[-train]

bart = gbart(xtrain, ytrain, x.test = xtest)

# This code was ran to write to csv file in data folder

# bart_coefs = data.frame(bart$varcount.mean)
# names(bart_coefs)[1] = "score"
# bart_coefs$var = rownames(bart_coefs)
# write.csv(bart_coefs, "./data/bart_coef.csv", row.names = FALSE)
