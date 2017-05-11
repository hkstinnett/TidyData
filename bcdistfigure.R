source("bcdistfxn.R")

#install.packages("plyr")
library(plyr)

#install.packages("dplyr")
library(dplyr) 

#install.packages("tidyr")
library(tidyr)

ctrl<- bcdist("tbx5mobead/Combined_ctrlcells.csv", "tbx5mobead/Combined_ctrlbead.csv")
fgf8<- bcdist("tbx5mobead/Combined_fgf8cells.csv", "tbx5mobead/Combined_fgf8bead.csv")

ctrlplot <- data.frame(timepoint = ctrl$Timepoint, 
                       mean = ctrl$mean-ctrl$mean[1],
                       sem = ctrl$se,
                       ci = ctrl$se*1.96,
                       condition= "ctrl")
fgf8plot <- data.frame(timepoint = fgf8$Timepoint, 
                       mean = fgf8$mean-fgf8$mean[1],
                       sem = fgf8$se,
                       ci = fgf8$se*1.96,
                       condition="fgf8")

alldat <- rbind(ctrlplot, fgf8plot)
alldat25 <- filter(alldat, timepoint<26)

#install.packages("ggthemes")
library(ggplot2)
library(ggthemes)

pd = position_dodge(0.5)

ggplot(alldat, aes(x = timepoint, y = mean, colour = condition)) + 
  #ylim(-40, 40) +
  geom_point(position=pd) +
  geom_errorbar(data = alldat, aes(ymax = mean+sem, ymin = mean-sem), position = pd) +
  labs( y = expression(
    paste("Change in average bead-cell distance (", 
          mu, 
          "m)")), 
        x = "Timepoint (every 8 minutes)") +
  scale_colour_discrete(labels= c("ctrl (n=8)", "fgf8 (n=8)")) +
  theme_bw(base_size = 18) + 
  theme(axis.text = element_text(size = 14, colour = "black"), 
        panel.grid.minor = element_blank(),
         # remove the vertical grid lines
         panel.grid.major.x = element_blank() ,
         # explicitly set the horizontal lines (or they will disappear too)
         panel.grid.major.y = element_line( size=.2, color="black" ),
         legend.title = element_blank(),
        legend.position = c(0.25, 0.8),
        legend.direction = "horizontal"
         )

#ggsave("bcdist_tbx5amo.pdf")

#first 25 timepoints

ggplot(alldat25, aes(x = timepoint, y = mean, colour = condition)) + 
  #ylim(-40, 40) +
  geom_point(position=pd) +
  geom_errorbar(data = alldat25, aes(ymax = mean+sem, ymin = mean-sem), position = pd) +
  labs( y = expression(
    paste("Change in average bead-cell distance (", 
          mu, 
          "m)")), 
    x = "Timepoint (every 8 minutes)") +
  scale_colour_discrete(labels= c("ctrl (n=8)", "fgf8 (n=8)")) +
  theme_bw(base_size = 18) + 
  theme(axis.text = element_text(size = 14, colour = "black"), 
        panel.grid.minor = element_blank(),
        # remove the vertical grid lines
        panel.grid.major.x = element_blank() ,
        # explicitly set the horizontal lines (or they will disappear too)
        panel.grid.major.y = element_line( size=.2, color="black" ),
        legend.title = element_blank(),
        legend.position = c(0.7, 0.9),
        legend.direction = "horizontal"
  )

