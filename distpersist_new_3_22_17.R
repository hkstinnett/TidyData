#total distance traveled for cells
library(tidyr)
library(dplyr)
cells.ctrl <- tbl_df(read.csv("Combined_ctrlcells_withpos.csv"))
cells.fgf8 <- tbl_df(read.csv("Combined_fgf8cells_withpos.csv"))

ctrl <- select(cells.ctrl, Track, Timepoint, X, Y, Position, Embryo, Bead)
fgf8 <- select(cells.fgf8, Track, Timepoint, X, Y, Position, Embryo, Bead)

aldat <- rbind(ctrl, fgf8)

#distance grouped by cell

finddistance<- function(cell){
  sum(sqrt((diff(cell$X))^2+(diff(cell$Y))^2))
}
findnetdistance<- function(cell){
  sqrt((tail(cell$X,1) - head(cell$X,1))^2 + 
         (tail(cell$Y,1) - head(cell$Y,1))^2)
}

#returns dataframe with sum distance for each individual cell
#in variable V1
distdf<-ddply(aldat, c("Embryo","Track", "Bead", "Position"), finddistance)
colnames(distdf)[5] <- "Totdist"
totalnetdist<-ddply(aldat, c("Embryo","Track", "Bead", "Position"), findnetdistance)
distdf$Netdist <- totalnetdist$V1
distdf$Persistence <-distdf$Netdist/distdf$Totdist

#returns datafarme with sum distance over first 25 timepoints
#above use the code but filter within as below
#totaldist25<-ddply(filter(aldat, Timepoint<25), c("Embryo","Track", "Bead", "Position"), finddistance)

library("ggplot2")

## cool plots
ggplot(distdf, aes(Bead, Totdist, colour = Position)) + 
  geom_boxplot() +
  labs( y = expression(
    paste("Total distance traveled (", 
          mu, 
          "m)")),
    x = "Bead condition") +
  scale_x_discrete(labels= c("ctrl (n=8)", "fgf8 (n=8)")) +
  theme_bw(base_size = 18) + 
  theme(axis.text = element_text(size = 14, colour = "black"), 
        panel.grid.minor = element_blank(),
        # remove the vertical grid lines
        panel.grid.major.x = element_blank() ,
        # explicitly set the horizontal lines (or they will disappear too)
        panel.grid.major.y = element_line( size=.2, color="black" ),
        legend.title = element_blank(),
        legend.position = "none"
  )

ggsave("totaldisttraveled_first25.pdf")

ggplot(distdf, aes(Bead, Netdist, colour = Position)) + 
  geom_boxplot() +
  labs( y = expression(
    paste("Displacement (", 
          mu, 
          "m)")),
    x = "Bead condition") +
  scale_x_discrete(labels= c("ctrl (n=8)", "fgf8 (n=8)")) +
  theme_bw(base_size = 18) + 
  theme(axis.text = element_text(size = 14, colour = "black"), 
        panel.grid.minor = element_blank(),
        # remove the vertical grid lines
        panel.grid.major.x = element_blank() ,
        # explicitly set the horizontal lines (or they will disappear too)
        panel.grid.major.y = element_line( size=.2, color="black" ),
        legend.title = element_blank(),
        legend.position = "none"
  )

ggsave("absdist_first25.pdf")


ggplot(distdf, aes(Bead, Persistence, colour = Position)) + 
  geom_boxplot() +
  labs( y = "Persistence (displacement/distance traveled)",
    x = "Bead condition") +
  scale_x_discrete(labels= c("ctrl (n=8)", "fgf8 (n=8)")) +
  theme_bw(base_size = 18) + 
  theme(axis.text = element_text(size = 14, colour = "black"), 
        panel.grid.minor = element_blank(),
        # remove the vertical grid lines
        panel.grid.major.x = element_blank() ,
        # explicitly set the horizontal lines (or they will disappear too)
        panel.grid.major.y = element_line( size=.2, color="black" ),
        legend.title = element_blank(),
        legend.position = "none"
  )

ggsave ("persistance_first25.pdf")

t.test(totaldist$totaldist[totaldist$Bead == "ctrl"],
       totaldist$totaldist[totaldist$Bead == "fgf8"])

t.test(totaldist$netdist[totaldist$Bead == "ctrl"],
       totaldist$netdist[totaldist$Bead == "fgf8"])

t.test(totaldist$persistence[totaldist$Bead == "ctrl"], 
       totaldist$persistence[totaldist$Bead == "fgf8"])
