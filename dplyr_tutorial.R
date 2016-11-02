#dplyer tutorial and learning 
#using windows machine

#install dplyer and library

install.packages("dplyer")
library(dplyr) 

#install example data
install.packages(c("nycflights13", "Lahman"))

#start with example of 336776 flights that departed from NYC in 2013
#data from Bureau of Transportation Statistics

library(nycflights13)

#use this data set to learn commands

filter(flights, month == 1, day ==1)
#filter(dataset, condition, ...)

slice(flights, 1:10)
#slice(dataset, row:row)

arrange(flights, year, month, day)
#puts the columns you list first in order, then the rest of data)

#can use desc() to put a column in descending order
arrange(flights, desc(arr_delay))

select(flights, year, month, day)
#allows you to select a subset of columns, does not print the rest of the data

# Select all columns between year and day (inclusive)
select(flights, year:day)

#select all columns except those from year to day (inclusive)
select(flights, -(year:day))

#you can rename variables with select, but you drop all other variables
select(flights, tail_num = tailnum)

#instead use rename()
rename(flights, tail_num = tailnum)

distinct(flights, tailnum)
distinct(flights, origin, dest)
#this allows us to find unique variables in a table

#to add new columns that are functions of existing columns
#mutate allows you to refer to columns you just created
#transform does not
#transmute only keeps new variables and does not print others

mutate(flights,
       gain = arr_delay - dep_delay,
       speed = distance/ air_time * 60)

mutate(flights,
       gain = arr_delay - dep_delay,
       gain_per_hour = gain / (air_time / 60)
)

transform(flights,
        gain = arr_delay - dep_delay,
        gain_per_hour = gain / (air_time / 60)
)

transmute(flights,
          gain = arr_delay - dep_delay,
          gain_per_hour = gain / (air_time / 60)
)

#collapses data frame to a single row
summarise(flights,
          delay = mean(dep_delay, na.rm = TRUE)
)

summarise(flights,
          distance = mean(distance, ra.rm = TRUE))

#you can also randomly seperate rows with 
#sample_n(dataframe, fixed number) and 
#sample_frac(dataframe, fixed fraction)
sample_n(flights, 10)

sample_frac(flights, 0.01)

#You may have noticed that the syntax and function of all these verbs 
#are very similar:
  
#The first argument is a data frame.
#The subsequent arguments describe what to do with the data frame. 
#Notice that you can refer to columns in the data frame directly
#without using $.
#The result is a new data frame

#Together these properties make it easy to chain together multiple
#simple steps to achieve a complex result.
#These five functions provide the basis of a language of data manipulation.
#At the most basic level, you can only alter a tidy data frame
#in five useful ways:

#you can reorder the rows (arrange()), 
#pick observations and variables of interest (filter() and select()),
#add new variables that are functions of existing variables (mutate()),
#or collapse many values to a summary (summarise()). 

#The remainder of the language comes from applying the five functions 
#to different types of data. 

#GROUPED operations

#use group_by() function to apply functions to groups of
#observations accross datasets

#breaks down a data set into a specified group of rows

#importantly, all this is achieved wit hthe same syntax as an
#ungrouped object

