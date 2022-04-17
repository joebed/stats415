# Neural Net
library(keras)

# Rel.inf 
boost.coefs = boost.df$rel.inf > .5
boost.coefs = boost.df[boost.coefs,"var"]

# To 
bart.coefs = bart_coefs$score > 5
bart.coefs = bart_coefs[bart.coefs, "var"]

# Use matrices for neural net, run lasso.R, bart.R, or gbm.R in kaggle_comp folderfirst to get coefficients
set.seed(997)

# This value can be lasso.coefs, bart.coefs, or boost.coefs
coefs = lasso.coefs

train = sample(8921, .8 * 8921)
training.df = train_data[,c("y", coefs)]

# Final submissions made with xFull and yFull
xFull = model.matrix(~ . - y, training.df)
yFull = training.df$y
xTr = model.matrix(~ . - y, training.df[train,])
yTr = training.df$y[train]
xTe = model.matrix(~ . - y, training.df[-train,])
yTe = training.df$y[-train]

# This was tweaked to get the best models
callbacks_list = list(callback_reduce_lr_on_plateau(monitor = "val_loss", patience = 10, min_lr = .000001))

set.seed(1587)
## create neural network
modnn <- keras_model_sequential () %>%
  
  # Change values in here as needed
  layer_dense(units = 100, activation = "relu") %>% # Hidden Layer 1
  layer_batch_normalization() %>%
  layer_dropout(rate = .05, trainable = TRUE) %>%

  layer_dense(units = 100, activation = "relu") %>% # Hidden Layer 2
  layer_batch_normalization() %>%
  layer_dropout(rate = .05, trainable = TRUE) %>%
  
  layer_dense(units = 100, activation = "relu", kernel_regularizer = regularizer_l2(.05)) %>% # Hidden Layer 3
  layer_batch_normalization() %>%
  
  layer_dense(units = 1)

modnn %>% compile(loss = "mse",
                  optimizer = optimizer_adam(learning_rate=0.01))

start_time <- Sys.time()
history <- modnn %>% fit(
  xTr, yTr, epochs = 100, batch_size = 64,
  callbacks = callbacks_list,
  #validation_split = .2,
  validation_data = list(xTe, yTe),
)

# Comment this out when using validation_split instead of validation_data
npred <- c(predict(modnn , xTe))
(plain_net <- cor(npred, yTe)^2) # test r^2
cor(c(predict(modnn, xTr)), yTr)^2 # train r^2

end_time <- Sys.time()
end_time - start_time

# Good if test error is around 5, want to try to get consistently below 5 but that is very hard
rm(list=c("boost.coefs","bart.coefs","end_time", "start_time"))
