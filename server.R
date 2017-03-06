library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)

simpleSpeedDating.df <- read.csv("data/simpleSpeedDating.df.csv", stringsAsFactors = FALSE)

expected.matches <- select(simpleSpeedDating.df, ID, Expected.Matches) %>% 
  unique() %>% 
  drop_na() #
  group_by(Race) %>% 
  summarize(count = n()) %>% 
  drop_na()

  
  #expected.matches$Expected.Matches[is.na(expected.matches$Expected.Matches)] <- mean(expected.matches$Expected.Matches)
  
  
  speed.dating.df <- group_by(simpleSpeedDating.df, Partner.ID) %>% 
    summarize(mean1 = mean(Overall.Like), mean2 = mean(Final.Attractiveness.Rating), mean3 = mean(Final.Sincerity.Rating)) %>% 
    mutate(overall.success = (mean1 + mean2 + mean3)/3) %>% 
    drop_na
  View(speed.dating.df) 
  
server <- function(input, output) {
  
  third_vis_data <- reactive({
    speed.dating.df <- simpleSpeedDating.df
    speed.dating.df <- group_by(speed.dating.df, Partner.ID) %>% 
                        summarize(mean1 = mean(Overall.Like), mean2 = mean(Final.Attractiveness.Rating), mean3 = mean(Final.Sincerity.Rating)) %>% 
                        mutate(overall.success = (mean1 + mean2 + mean3)/3) %>% 
                        drop_na
    
    
    
    names(speed.dating.df)[names(speed.dating.df) == "Partner.ID"] <- "ID"
    speed.dating.df <- merge(x = speed.dating.df, y = simpleSpeedDating.df[ , c("ID", "Expected.Matches", "Attractiveness.4", "Sincerity.4", "Intelligence.4", "Fun.4", "Ambition.4", "Attractiveness.5", "Sincerity.5", "Intelligence.5", "Fun.5", "Ambition.5")], by = "ID", na.rm = TRUE) %>% 
      unique()
    
    speed.dating.df$Expected.Matches.x <- (speed.dating.df$Expected.Matches.x)/20
    
    speed.dating.df$Attractiveness.4.x[speed.dating.df$Attractiveness.4.x <= 10] <- (speed.dating.df$Attractiveness.4.x[speed.dating.df$Attractiveness.4.x <= 10])/10
    filter(speed.dating.df, "Attractiveness.4.x" < 10 | "Sincerity.4.x" < 10 | "Intelligence.4.x" < 10 | "Fun.4.x" < 10 | "Ambition.4.x" < 10)  
    View(less.ten)
    })
 
}

shinyServer(server)
