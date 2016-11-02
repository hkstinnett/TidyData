#setwd

#on macbook:
#setwd("~/Dropbox/Tidy Data")

#always install plyr before dplyr

install.packages("plyr")
library(plyr)

install.packages("dplyr")
library(dplyr) 

install.packages("tidyr")
library(tidyr)

#create character listing all files
#files within the data folder of interest
#the full.names make a directory path to the data file
file_list <- list.files("WT Test Data", full.names = TRUE)

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



#everything below this comment is random thought

#typeof(data)
#it is a list

#typeof(data)
# "list"

#class(data)
#"data.frame"

#use names() to see the column names
#names(data)

#loop that goes thru every file, add a new column and set all values to what ever loop you are on
#set next column to the next file number
#have loop create list of data frames
#have list of data frames that all have same column

  

#raw data to clean data
#analyses are performed on clean data
#save the data that generates the figure with the plot

#this loop works to merge all the observations, but does not add 
#an id column


#for (file in file_list){
#  if (!exists("dataset")){
#    dataset <-read.csv(file, header = TRUE, sep=",")}
#}
#  if(exists("dataset")){
#    temp_dataset <-read.csv(file, header=TRUE, sep = ",")
#    dataset<-rbind(dataset, temp_dataset)
#    rm(temp_dataset)
#}


