# Set up workspace for the final project

rm(list=ls())

# Set working directory. Just hit enter if you're already on it
getwd()
wd = readline(prompt="What is your final project directory?")

if (nchar(wd) > 0){
  setwd(wd)
  getwd()
}

train_data = read.csv("./data/train_data.csv")
test_data = read.csv("./data/test_data.csv")
boost.df = read.csv("./data/boostdf.csv")
bart_coefs = read.csv("./data/bart_coef.csv")

train_data = train_data[,seq(2, 145)]
test_data = test_data[,seq(2, 145)]

rm(wd)

