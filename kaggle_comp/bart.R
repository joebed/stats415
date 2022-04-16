# Bayesian Additive Trees

library(BART)

set.seed(234523)
train = sample(8921, 8921*.8)

x = train_data[,3:144]
y = train_data[,2]

xtrain = x[train,]
ytrain = y[train]

xtest = x[train,]
ytest = y[train]

bart = gbart(x, y, x.test = test_data)

yhat = bart$yhat.test.mean

mean((ytest - yhat)^2)
