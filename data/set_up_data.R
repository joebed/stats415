# In order to use this, use setwd({final_project_directory})
# getwd() gets your current working directory if you're unsure where you are at

# Clean workspace beforehand
rm(list=ls())

# Data of all years has these names
files = c("/TCHOL.XPT", "/SMQ.XPT", "/DR1TOT.XPT", "/DEMO.XPT", "/BPX.XPT", "/BMX.XPT")

library(haven)
library(dplyr)


years_data = list()

# Iterate through all years
for(i in seq(1, 5)){
  
  # Set year
  year = 2 * i + 2007
  # Set string of directory, make sure to setwd to your final project directory
  dir = paste("data/", year, sep="")
  year_data = data.frame()
  
  # Iterate through all files and left join
  for(j in seq(1,6)){
    
    d = paste(dir, files[j], sep="")
    val = read_xpt(d)
    
    if(j == 1){
      year_data = val
    }
    else{
      year_data = merge(year_data, val, all.x = TRUE, by = "SEQN")
    }
    
  }
  
  if(i == 1){
    years_data = year_data
  }
  else{
   years_data = bind_rows(years_data, year_data) 
  }
  
}

# Set train and test data
train_data = read.csv("data/train.csv")
test_data = read.csv("data/test.csv")
train_data = merge(train_data, years_data, all.x = TRUE, by="SEQN")
test_data = merge(test_data, years_data, all.x = TRUE, by="SEQN")

# Remove any column where there is an NA
train_data = train_data[, colSums(is.na(train_data)) == 0]
test_data = test_data[, colSums(is.na(test_data)) == 0]

# Remove columns as outlined in group guidelines
drops = c("SMDUPCA", "SMD100BR", "DR1DRSTZ", "DRABF", "RIDSTATR")
train_data = train_data[, !(names(train_data) %in% drops)]
test_data = test_data[, !(names(test_data) %in% drops)]

# Standardize data
train_data[seq(3, 144)] = scale(train_data[seq(3, 144)])
test_data[seq(2, 144)] = scale(test_data[seq(2, 144)])

# Clean data
rm(list = c("d", "dir", "files", "i", "j", "year", "year_data", "years_data", "drops", "val"))


