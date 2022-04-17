# Bayesian Additive Trees
# NOT DONE YET
library(BART)

set.seed(234523)

x = train_data[,3:144]
y = train_data[,2]

bart = gbart(x, y, x.test = test_data)

yhat = bart$yhat.test.mean

bart_coefs = data.frame(bart$varcount.mean)
names(bart_coefs)[1] = "score"

bart_coefs$var = rownames(bart_coefs)

write.csv(bart_coefs, "bart_coef.csv", row.names = FALSE)
