# Neural Net
library(keras)

boost.coefs = boost.df$rel.inf > .5
boost.coefs = boost.df[boost.coefs,"var"]

bart.coefs = bart_coefs$score > 5
bart.coefs = bart_coefs[bart.coefs, "var"]

# Use matrices for neural net, run Lasso.R first to get lasso coefficients
set.seed(997)
coefs = boost.coefs

training.df = train_data[,c("y", coefs)]
xFull = model.matrix(~ . - y, training.df)
yFull = training.df$y

callbacks_list = list(callback_reduce_lr_on_plateau(monitor = "val_loss", patience = 10, min_lr = .000001))

set.seed(1587)
## create neural network
modnn <- keras_model_sequential () %>%
  
  layer_dense(units = 100, activation = "relu") %>%
  layer_batch_normalization() %>%
  layer_dropout(rate = .05, trainable = TRUE) %>%

  layer_dense(units = 100, activation = "relu") %>%
  layer_batch_normalization() %>%
  layer_dropout(rate = .05, trainable = TRUE) %>%
  
  layer_dense(units = 100, activation = "relu", kernel_regularizer = regularizer_l2(.05)) %>%
  layer_batch_normalization() %>%
  
  layer_dense(units = 1)

modnn %>% compile(loss = "mse",
                  optimizer = optimizer_adam(learning_rate=0.01))

start_time <- Sys.time()
history <- modnn %>% fit(
  xFull, yFull, epochs = 500, batch_size = 64,
  callbacks = callbacks_list,
  validation_split = .2
)
end_time <- Sys.time()
end_time - start_time

# Good if test error is around 5, want to try to get consistently below 5 but that is very hard
rm(list=c("boost.coefs","bart.coefs","end_time", "start_time"))
