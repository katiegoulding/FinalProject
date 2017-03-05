library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)

# setwd("~/Desktop/INFO 201 Autumn 17 HW/FinalProject")
speed.data <- read.csv("data/simpleSpeedDating.df.csv")
View(speed.data)

server <- function(input, output) {
  
  function(input, output) {

    output$table <- renderDataTable({
      speed.data
    })
    
          # Creates a new df with "count" column, which counts the number of
          # participants who identified with each race
          count.per.race <- select(simpleSpeedDating.df, ID, Race) %>% 
            unique() %>% 
            group_by(Race) %>% 
            summarize(count = n()) %>% 
            drop_na()
          # Number of total participants
          total.participants <- sum(count.per.race$count)
          # Creates df with percent breakdown
          race.df <- mutate(count.per.race, percent.race = round(count/total.participants * 100, 2))
    
    output$race.graph <- renderPlotly({

      # Creates an x-axis title
      x <- list(
        title = "Race"
      )
      # Creates a y-axis title
      y <- list(
        title = "Percent"
      )
      # Creates a title for the race bar graph ***does not work***
      title.race <- list(
        title = "Race percent breakdown of all participants"
      )
      # Produces plotly bar graph of racial breakdown
      race.graph <- plot_ly(
        x = race.df$Race,
        y = race.df$percent.race,
        name = "Participant Racial Breakdown",
        type = "bar",
        color = race.df$Race,
        showlegend = FALSE) %>% 
        layout(title = title.race, xaxis = x, yaxis = y)
    })
  }
}
shinyServer(server)