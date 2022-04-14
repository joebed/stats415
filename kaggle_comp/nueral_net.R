# Neural Net
library(keras)

# Use matrices for neural net, run Lasso.R first to get lasso coefficients
set.seed(997)
coefs = boost.coefs
train = sample(8921, 8921 * .8)
train_df = train_data[train,c("y", coefs)]
test_df = train_data[-train,c("y", coefs)]

xTr = model.matrix(lm(y ~ ., train_df))
yTr = train_df$y
xTe = model.matrix(lm(y ~ ., test_df))
yTe = test_df$y


callbacks_list = list(callback_reduce_lr_on_plateau(monitor = "val_loss"))

## create neural network
modnn <- keras_model_sequential () %>%
  layer_dense(units = 20, activation = "relu") %>% # hidden layer 1
  layer_batch_normalization() %>%
  layer_dense(units = 20, activation = "relu") %>% # hidden layer 2
  layer_batch_normalization() %>%
  layer_dense(units = 20, activation = "relu") %>% # hidden layer 3
  layer_batch_normalization() %>%
  layer_dense(units = 1) # output layer, no activation

modnn %>% compile(loss = "mse",
                  optimizer = optimizer_adam(learning_rate=0.01))

start_time <- Sys.time()
history <- modnn %>% fit(
  xTr, yTr, epochs = 200, batch_size = 50,
  validation_data = list(xTe, yTe),
  callbacks = callbacks_list
)
end_time <- Sys.time()
end_time - start_time

npred <- c(predict(modnn , xTe))
(plain_net <- cor(npred, yTe)^2) # test r^2
cor(c(predict(modnn, xTr)), yTr)^2 # train r^2
