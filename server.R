library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)

# setwd("~/Desktop/INFO 201 Autumn 17 HW/FinalProject")
simpleSpeedDating.df <- read.csv("data/simpleSpeedDating.df.csv", stringsAsFactors = FALSE)

server <- function(input, output) {

    output$race.graph <- renderPlotly({
        
        # Creates a new df with "count" column, which counts the number of
        # participants who identified with each race
        count.per.race <- select(simpleSpeedDating.df, ID, Race, Sex) %>% 
          unique() %>% 
          group_by(Race, Sex) %>% 
          summarize(count = n()) %>% 
          drop_na()
        # Number of total participants
        total.participants <- sum(count.per.race$count)
        # Creates df with percent breakdown
        race.df <- mutate(count.per.race, percent.race = round(count/total.participants * 100, 2))
        # Creates an x-axis title
        y <- list(
          title = ""
        )
        # Creates a y-axis title
        x <- list(
          title = "Percent"
        )
        # Creates a title for the race bar graph ***does not work***
        #title.race <- list(
        #  title = "Race Percent Breakdown of All Participants"
        #)
        
        pal <- c("#006bfa", "#ede800")
        
        # Produces plotly bar graph of racial breakdown
        race.graph <- plot_ly(
          x = race.df$percent.race,
          y = race.df$Race,
          name = "Participant Racial Breakdown",
          type = "bar",
          orientation = "h",
          color = race.df$Sex,
          colors = pal,
          showlegend = TRUE) %>% 
          #layout(title = title.race, xaxis = x, yaxis = y, margin = list(b = 150, r = 30))
          layout(xaxis = x, yaxis = y, margin = list(b = 150, r = 30, l = 200))
    })
    
}
shinyServer(server)