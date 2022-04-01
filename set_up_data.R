train_data = read.csv("data/train.csv")
test_data = read.csv("data/test.csv")
files = c("/TCHOL_F.XPT", "/SMQ_F.XPT", "/DR1TOT_F.XPT", "/DEMO_F.XPT", "/BPX_F.XPT", "/BMX_F.XPT")
files_11 = c("/TCHOL_G.XPT", "/SMQ_G.XPT", "/DR1TOT_G.XPT", "/DEMO_G.XPT", "/BPX_G.XPT", "/BMX_G.XPT")

for(i in seq(0, 4)){
  year = 2 * i + 2009
  dir = paste("data/", year, sep="")
  if (2 * i + 2009 ==2011){
    yearfiles = files_11
  }
  else{
    yearfiles = files
  }
  for(j in seq(1,6)){
    d = paste(dir, yearfiles[j], sep="")
    new_df = read_xpt(d)
   # train_data = merge(train_data, new_df, by.x(S))
  }
}

