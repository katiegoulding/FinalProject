library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)

simpleSpeedDating.df <- read.csv("data/simpleSpeedDating.df.csv", stringsAsFactors = FALSE)

server <- function(input, output, session) {
  data <- reactive({
    speed.dating.df <- simpleSpeedDating.df
    #Selecting racial groups
    speed.dating.df <- filter(speed.dating.df, Race == input$racial.group.1 | Race == input$racial.group.2)
    
    #Selecting interest
    if(input$interest.select == "Attribute Rating") {
      speed.dating.df <- select(speed.dating.df, Race, Preference.of.Partner.Attract:Preference.of.Partner.Shared.Interest)
    }
    if(input$interest.select == "Hobbies") {
      speed.dating.df <- select(speed.dating.df, Race, Sports:Yoga)
    }
    if(input$interest.select == "Importance of Race or Religion") {
      speed.dating.df <- select(speed.dating.df, Race, Importance.Same.Race, Importance.Same.Religion)
    }
    
    #Convert df to long format
    speed.dating.long <- gather(speed.dating.df,
                                key = interest,
                                value = rating,
                                2:ncol(speed.dating.df))
    
    #Get medians of the interests selected
    speed.dating.long <- group_by(speed.dating.long, Race, interest) %>%
                         summarize("Median" = median(rating, na.rm = TRUE))
    
    return(speed.dating.long)
  })
  
  yaxis.max <- reactive ({
    if(input$interest.select == "Attribute Rating") {
      return(20)
    }
    return(10)
  })
  
 output$second.vis <- renderPlotly({
   plot_ly(data(), x = ~interest, y = ~Median, type = "bar", color = ~Race) %>%
   layout(margin = 100, yaxis = list(range = c(0, yaxis.max())))
 })
 

 
 
 
 
}

shinyServer(server)
