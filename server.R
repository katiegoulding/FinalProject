library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)

simpleSpeedDating.df <- read.csv("data/simpleSpeedDating.df.csv", stringsAsFactors = FALSE)

#View(simpleSpeedDating.df)

server <- function(input, output, session) {
  second.vis.data <- reactive({
    speed.dating.df <- simpleSpeedDating.df
    #Selecting racial groups
    speed.dating.df <- filter(speed.dating.df, Race == input$racial.group.1 | Race == input$racial.group.2)
    
    #Selecting interest
    if(input$interest.select == "Attribute Rating") {
      speed.dating.df <- select(speed.dating.df, Race, Sex, Preference.of.Partner.Attract:Preference.of.Partner.Shared.Interest)
    }
    if(input$interest.select == "Hobbies") {
      speed.dating.df <- select(speed.dating.df, Race, Sex, Sports:Yoga)
    }
    if(input$interest.select == "Importance of Race or Religion") {
      speed.dating.df <- select(speed.dating.df, Race, Sex, Importance.Same.Race, Importance.Same.Religion)
    }
    
    #Convert df to long format
    speed.dating.long <- gather(speed.dating.df,
                                key = interest,
                                value = rating,
                                3:ncol(speed.dating.df))
    
    #Get medians of the interests selected
    speed.dating.long <- group_by(speed.dating.long, Race, interest, Sex) %>%
      summarize("Median" = median(rating, na.rm = TRUE))
    return(speed.dating.long)
  })
  
  # add this for more hover details text=data()$my_text, hoverinfo = "text+x+y")
  
  yaxis.max <- reactive ({
    if(input$interest.select == "Attribute Rating") {
      return(20)
    }
    return(10)
  })
  
  output$second.vis.female <- renderPlotly({
      filter(second.vis.data(), Sex == 'Female') %>%
      plot_ly(x = ~interest, y = ~Median, type = "bar", color = ~Race) %>%
        layout(margin = 100, yaxis = list(range = c(0, yaxis.max())))
    })
  
  output$second.vis.male <- renderPlotly({
    filter(second.vis.data(), Sex == 'Male') %>%
      plot_ly(x = ~interest, y = ~Median, type = "bar", color = ~Race) %>%
      layout(margin = 100, yaxis = list(range = c(0, yaxis.max())))
  })
  
  
}

shinyServer(server)