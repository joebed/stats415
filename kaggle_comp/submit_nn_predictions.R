# Make predictions based on NN object modnn

bart.coefs = bart_coefs$score > 3
bart.coefs = bart_coefs[bart.coefs, "var"]

temp_data = test_data[,c(boost.coefs)]
temp_data$"y" = rep(1, nrow(temp_data))

y = predict(modnn, model.matrix(~ . - y, temp_data))

sub = data.frame(y)
sub$SEQN = test_data$SEQN

write.csv(sub, "sub.csv", row.names = FALSE)

rm(list=c("temp_data","y","sub"))
