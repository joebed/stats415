# Gradient Boosted Model
library(gbm)

# Using a validation set and shrinkage = .1:
# Num  trees: MSE
# 5000 trees: 6.991007
# 100  trees: 7.414672
# 1000 trees: 6.656163
# 2500 trees: 6.865633
# 1250 trees: 6.712508
# 750  trees: 6.693474

set.seed(68)
num_trees = 1000

boost.mod <- gbm(
  y~.,
  data=train_data,
  distribution="gaussian",
  n.trees=num_trees,
  shrinkage = .01,
  cv.folds = 5,
  interaction.depth=4)

boost.df = summary(boost.mod)
rm(list = c("num_trees"))
