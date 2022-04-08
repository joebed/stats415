# Set up workspace for the final project

rm(list=ls())

# Set working directory. Just hit enter if you're already on it
getwd()

wd = readline(prompt="What is your final project directory?")
setwd(wd)


train_data = read.csv("train_data.csv")
test_data = read.csv("test_data.csv")

rm(wd)

