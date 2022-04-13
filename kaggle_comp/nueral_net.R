# Neural Net
library(keras)

# Use matrices for neural net, run Lasso.R first to get lasso coef
set.seed(997)
train = sample(8921, 8921 * .8)
train_df = train_data[train,c("y", lasso.coefs)]
test_df = train_data[-train,c("y", lasso.coefs)]

xTr = model.matrix(lm(y ~ ., train_df))
yTr = train_df$y
xTe = model.matrix(lm(y ~ ., test_df))
yTe = test_df$y



## create neural network
modnn <- keras_model_sequential () %>%
  layer_dense(units = 50, activation = "relu", kernel_regularizer = regularizer_l2(0.15)) %>% # hidden layer 1
  layer_dense(units = 25, activation = "relu", kernel_regularizer = regularizer_l1(0.15)) %>% # hidden layer 2
  layer_dense(units = 10, activation = "relu", kernel_regularizer = regularizer_l2(0.15)) %>% # hidden layer 3
  layer_dense(units = 1) # output layer, no activation

modnn %>% compile(loss = "mse",
                  optimizer = optimizer_adam(learning_rate=0.01))

start_time <- Sys.time()
history <- modnn %>% fit(
  xTr, yTr, epochs = 200, batch_size = 50,
  validation_data = list(xTe, yTe)
)
end_time <- Sys.time()
end_time - start_time

npred <- c(predict(modnn , xTe))
(plain_net <- cor(npred, yTe)^2) # test r^2
cor(c(predict(modnn, xTr)), yTr)^2 # train r^2
