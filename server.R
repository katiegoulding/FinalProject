library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)

# setwd("~/Desktop/INFO 201 Autumn 17 HW/FinalProject")
simpleSpeedDating.df <-
  read.csv("data/simpleSpeedDating.df.csv", stringsAsFactors = FALSE)

server <- function(input, output) {
  #Create reactive data for plot based on widgets
  first.vis.data <- reactive({
    first.vis.speedDating <- simpleSpeedDating.df
    
    if(input$met_before != "Before") {
      if(input$met_before == "Have Met Before") {
        first.vis.speedDating <- filter(first.vis.speedDating, Met.Before == 1)
      } else {
        first.vis.speedDating <- filter(first.vis.speedDating, Met.Before == 2)
      }
    }
    
    #Filter data based on sex
    if (input$sex_select != "All") {
      first.vis.speedDating <-
        filter(first.vis.speedDating, Sex == input$sex_select)
    }
    
    #Gathers the percentage of matches for selected racial group
    first.vis.speedDating <-
      filter(first.vis.speedDating, Race == input$racial_group) %>%
      group_by(Race.of.Partner, Match) %>%
      summarize("Interactions" = n()) %>%
      mutate("Total Interactions" = sum(Interactions)) %>%
      filter(Match == "Yes" &
               Race.of.Partner != "NA") %>%
      mutate("Percentage" = (Interactions / `Total Interactions`) * 100)
    return(first.vis.speedDating)
  })
  
  #Render data in plotly bar  chart
  output$first.vis <- renderPlotly({
    plot_ly(
      first.vis.data(),
      x = ~ Race.of.Partner,
      y = ~ Percentage,
      type = "bar"
    ) %>%
      layout(
        title = "Percentage Breakdown of Racial Group Matches",
        xaxis = list(title = "Race of Partner", tickangle = 25),
        yaxis = list(title = "Match Percentage"),
        margin = list(b = 150)
      )
  })
  
}
shinyServer(server)