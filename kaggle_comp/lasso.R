# Lasso Selection
library(glmnet)

# Use matrices for glmnet, make sure SEQN not included
train_set = train_data[,-1]

x = model.matrix(y ~ ., train_set)[,-1]
y = train_set$y

set.seed(24)

# Get best lambda using CV, use it to fit a model in order to get coefficients
cv.out = cv.glmnet(x, y, alpha = 1)
bestlam = cv.out$lambda.min
lasso.out = glmnet(x, y, alpha = 1, lambda = bestlam)

# Get coefficient names
lasso.coefs = as.matrix(coef(lasso.out, s = bestlam))
lasso.coefs = rownames(lasso.coefs)[lasso.coefs > 0]
lasso.coefs = lasso.coefs[-(1)]

# Clean workspace
rm(list=c("x", "y", "cv.out", "bestlam", "lasso.out", "train_set"))