
install.packages("plyr")
library(plyr)

install.packages("dplyr")
library(dplyr) 

install.packages("tidyr")
library(tidyr)

#create variable listing all files
#files within the data folder of interest
#the full.names make a directory path to the data file

file_list <- list.files(path = "../01 Data/Cell tracking_all data/01 WT/00 raw/",
           recursive = TRUE, full.names = TRUE, pattern = "3D.txt")

#for each element of the list, apply function and keep results with llply
mylist<-llply(file_list, function(x) tbl_df(read.csv(x, header = TRUE, sep = "\t")))

#for each element of the list, take the number of the embryo and make that a new variable
#then assign that to a column in mylist again
for (i in 1:length(mylist)){
  embryo_dataset<-mylist[[i]]
  embryo_dataset_new <- mutate(embryo_dataset, Embryo = i)
  mylist[[i]] <- embryo_dataset_new
}


all<-do.call("rbind", mylist)

#use names() to change names
names(all) <- c("Serial", "Track", "Slice",
                "X", "Y","Distance", "Velocity", "Pixel", "Z", "Embryo")

#add a column with experiment condition, in this case wt
all<-mutate(all,  Background = "wt")

#save to a new file
write.table(all, file = "Combined_WT.csv", sep = ",", row.names = FALSE)

#to read into a new script
read.csv("Combined_WT.csv")


