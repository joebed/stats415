
set.seed(1)
library(glmnet)

MSE <- function(y1, y2){
  mean((y1-y2)^2)
}

train_data <- read.csv("./train_data.csv")
train_data <- subset(train_data, select = -c(y))
test_data <- read.csv("./test_data.csv")
test_data <- subset(test_data, select = names(train_data))

head(train_data)

## Can we predict cholesterol levels based on dietary 
## cholesterol intake?

lm.fit <- lm(LBXTC ~ DR1TCHOL, train_data)
summary(lm.fit)
#plot(lm.fit)

dim(train_data)

dim(test_data)

train_pred <- predict(lm.fit, train_data)
MSE(train_data$LBXTC, train_pred)

test_pred <- predict(lm.fit, test_data)
MSE(test_data$LBXTC, test_pred)

##Dietary cholesterol appears significant in predicting 
##cholesterol levels with a significance of 0.05
## Based on the plots, it doesn't look like the relationship is 
## linear.

fit <- lm(LBXTC ~ poly(DR1TCHOL, 10), data = train_data)
summary(fit)

## Using a polynomial model, the variables are only significant 
## using 4 degrees or less. 

fit <- lm(LBXTC ~ poly(DR1TCHOL, 4), data = train_data)
summary(fit)
#plot(fit)

train_pred <- predict(fit, train_data)
MSE(train_data$LBXTC, train_pred)

test_pred <- predict(fit, test_data)
MSE(test_data$LBXTC, test_pred)

## Also, the plots indicate the relationship 
## may not be well-expressed by a polynomial either.

## Can we use a larger set of dietary variables to predict
## cholesterol levels?

diet_train <- subset(train_data, select = -c(SEQN, SMAQUEX2, 
                                             LBDTCSI, WTDRD1, WTDR2D, DR1EXMER, DRDINT, DR1DBIH, 
                                             DR1LANG, DR1TNUMF, DR1DAY, DBQ095Z, DRQSPREP, DRQSDIET, 
                                             DR1_300, DR1TWS, SDDSRVYR, RIDEXMON, RIAGENDR, RIDAGEYR, 
                                             RIDRETH1, DMDCITZN, DMDHHSIZ, DMDFMSIZ, INDHHIN2, 
                                             INDFMIN2, INDFMPIR, DMDHRGND, DMDHRAGE, DMDHREDU, 
                                             DMDHRMAR, SIALANG, SIAPROXY, SIAINTRP, FIALANG, 
                                             MIALANG, FIAPROXY, MIAPROXY, FIAINTRP, MIAINTRP, 
                                             WTINT2YR, WTMEC2YR, SDMVPSU, DR1BWATZ, 1))

diet_test <- subset(test_data, select = names(diet_train))

names(diet_train)

names(diet_test)

head(diet_train)

full <- lm(LBXTC ~ ., data = diet_train)
summary(full)

train_pred <- predict(full, train_data)
MSE(train_data$LBXTC, train_pred)

test_pred <- predict(full, test_data)
MSE(test_data$LBXTC, test_pred)

y_train <- diet_train$LBXTC
x_train <- as.matrix(subset(diet_train, select = -c(LBXTC)))

y_test <- diet_test$LBXTC
x_test <- as.matrix(subset(diet_test, select = -c(LBXTC)))

library(glmnet)

lasso <- cv.glmnet(x_train, y_train, alpha = 1)
bestl <- lasso$lambda.min
fit.lass <- glmnet(x_train, y_train, alpha = 1, 
                   lambda = bestl)
fit.lass$beta

lasso_test <- predict(fit.lass, s = bestl, 
                      newx = x_test)
lasso_train <- predict(fit.lass, s = bestl, 
                       newx = x_train)

err_train <- mean((train_data$LBXTC - lasso_train)^2)
err_train

err_test <- mean((test_data$LBXTC - lasso_test)^2)
err_test





