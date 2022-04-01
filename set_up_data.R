# In order to use this, use setwd({final_project_directory})
# getwd() gets your current working directory if you're unsure where you are at

# Data of all years has these names
files = c("/TCHOL.XPT", "/SMQ.XPT", "/DR1TOT.XPT", "/DEMO.XPT", "/BPX.XPT", "/BMX.XPT")

library(haven)

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

# Remove any column where there is an NA
years_data = years_data[, colSums(is.na(years_data)) == 0]

# Set train and test data
train_data = read.csv("data/train.csv")
test_data = read.csv("data/test.csv")
train_data = merge(train_data, years_data, all.x = TRUE, by="SEQN")
test_data = merge(test_data, years_data, all.x = TRUE, by="SEQN")


# Clean workspace
rm(c("year_data", "years_data", "val", "d", "dir", "i", "j", "year"))


