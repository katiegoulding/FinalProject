library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)

# setwd("~/Desktop/INFO 201 Autumn 17 HW/FinalProject")
simpleSpeedDating.df <- read.csv("data/simpleSpeedDating.df.csv", stringsAsFactors = FALSE)


server <- function(input, output) {
  
 first.vis.data <- reactive({
   first.vis.speedDating <- simpleSpeedDating.df
   if(input$sex_select != "All") {
     first.vis.speedDating <- filter(first.vis.speedDating, Sex == input$sex_select)
   }
   
   first.vis.speedDating <- filter(first.vis.speedDating, Race == input$racial_group) %>%
                            group_by(Race.of.Partner, Match) %>%
                            summarize("Interactions" = n()) %>%
                            mutate("Total Interactions" = sum(Interactions)) %>%
                            filter(Match == "Yes" & Race.of.Partner != "NA") %>%
                            mutate("Percentage" = (Interactions / `Total Interactions`) * 100)
  
   
   
   return(first.vis.speedDating)
 })
 
output$first.vis <- renderPlotly({
  plot_ly(first.vis.data(), x = ~Race.of.Partner, y = ~Percentage, type = "bar") %>%
    layout(xaxis = list(title = "Race of Partner",tickangle = 45), yaxis = list(title = "Match Percentage"))
})
}
shinyServer(server)