
#install.packages("plyr")
library(plyr)

#install.packages("dplyr")
library(dplyr) 

#install.packages("tidyr")
library(tidyr)

#this will just calculate the bead-cell distance

bcdist <- function(cellfilename, beadfilename){
  
  cells <- tbl_df(read.csv(cellfilename))
  bead <- tbl_df(read.csv(beadfilename))
  
  cells <- select(cells, Track, Timepoint, X, Y, Embryo, Bead)
  bead <- select(bead, X, Y, Timepoint, Embryo)
  
  bcdf <- left_join(cells, bead, by= c("Embryo", "Timepoint"), 
                    suffix = c(".cells", ".bead"))
 
  bcdf <- mutate(bcdf, 
                 X.dist = bcdf$X.cells-bcdf$X.bead, 
                 Y.dist = bcdf$Y.cells-bcdf$Y.bead)
  bcdf <- mutate(bcdf, dist = sqrt((bcdf$X.dist)^2+(bcdf$Y.dist)^2))
  
  bcdf_bytime <- group_by(bcdf, Timepoint)
  bcdf_dist <- dplyr::summarise(bcdf_bytime, 
                          n = length(unique(bcdf$Timepoint)),
                          mean = mean(dist),
                          sd = sd(dist),
                          se = sd/sqrt(n))
  return(bcdf_dist)
  
}
