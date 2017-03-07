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
        x <- list(
          title = "Race/Gender"
        )
        # Creates a y-axis title
        y <- list(
          title = "Percent"
        )
        # Creates a title for the race bar graph ***does not work***
        #title.race <- list(
        #  title = "Race Percent Breakdown of All Participants"
        #)
        # Produces plotly bar graph of racial breakdown
        race.graph <- plot_ly(
          x = race.df$Race,
          y = race.df$percent.race,
          name = "Participant Racial Breakdown",
          type = "bar",
          color = race.df$Sex,
          showlegend = TRUE) %>% 
          #layout(title = title.race, xaxis = x, yaxis = y, margin = list(b = 150, r = 30))
          layout(xaxis = x, yaxis = y, margin = list(b = 150, r = 30))
    })

  

    
    output$sex.graph <- renderPlotly({
      count.per.sex <- select(simpleSpeedDating.df, ID, Sex) %>% 
        unique() %>% 
        group_by(Sex) %>% 
        summarize(count = n()) %>% 
        drop_na()
      total.participants <- sum(count.per.sex$count)
      # Creates df with percent breakdown
      sex.df <- mutate(count.per.sex, ratio.sex = (count))
      # Creates an x-axis title
      x <- list(
        title = "Sex"
      )
      # Creates a y-axis title
      y <- list(
        title = "Number of persons identified with respective gender"
      )
      # Creates a title for the sex bar graph ***does not work***
      title.sex <- list(
        title = "Sex breakdown of all participants"
      )
      # Produces plotly bar graph of sex breakdown
      sex.graph <- plot_ly(
        x = sex.df$Sex,
        y = sex.df$ratio.sex,
        name = "Participant Sex Breakdown",
        type = "bar",
        color = sex.df$Sex,
        showlegend = FALSE) %>% 
        layout(title = title.sex, xaxis = x, yaxis = y)
      })
      
    
    
}
shinyServer(server)