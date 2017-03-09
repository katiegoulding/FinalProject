library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)

simpleSpeedDating.df <-
  read.csv("data/simpleSpeedDating.df.csv", stringsAsFactors = FALSE)

#Change column names to make plot more readable to user
colnames(simpleSpeedDating.df)[which(names(simpleSpeedDating.df) == "Preference.of.Partner.Attract")] <- "Partner Attractiveness"
colnames(simpleSpeedDating.df)[which(names(simpleSpeedDating.df) == "Preference.of.Partner.Sincerity")] <- "Partner Sincerity"
colnames(simpleSpeedDating.df)[which(names(simpleSpeedDating.df) == "Preference.of.Partner.Intelligence")] <- "Partner Intelligence"
colnames(simpleSpeedDating.df)[which(names(simpleSpeedDating.df) == "Preference.of.Partner.Fun")] <- "Partner Fun"
colnames(simpleSpeedDating.df)[which(names(simpleSpeedDating.df) == "Preference.of.Partner.Ambition")] <- "Partner Ambition"
colnames(simpleSpeedDating.df)[which(names(simpleSpeedDating.df) == "Preference.of.Partner.Shared.Interest")] <- "Partner Shared Interest"
colnames(simpleSpeedDating.df)[which(names(simpleSpeedDating.df) == "Importance.Same.Race")] <- "Importance of Same Race"
colnames(simpleSpeedDating.df)[which(names(simpleSpeedDating.df) == "Importance.Same.Religion")] <- "Importance of Same Religion"

server <- function(input, output) {
  
  #Create reactive data for plot based on widgets
  first.vis.data <- reactive({
    first.vis.speedDating <- simpleSpeedDating.df
    
    if(input$met_before != "Both") {
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
    pal <- c("#ca0020", "#f4a582", "#f7f7f7", "#92c5de", "#0571b0")
    plot_ly(
      first.vis.data(),
      x = ~ Race.of.Partner,
      y = ~ Percentage,
      colors = pal,
      color = ~ Race.of.Partner,
      type = "bar"
    ) %>%
      layout(
        title = "Percentage Breakdown of Racial Group Matches",
        xaxis = list(title = "Race of Partner", tickangle = 25),
        yaxis = list(title = "Match Percentage"),
        showlegend = FALSE,
        margin = list(b = 150)
      )
  })

  second.vis.data <- reactive({
    speed.dating.df <- simpleSpeedDating.df
    #Selecting racial groups
    speed.dating.df <- filter(speed.dating.df, Race == input$racial.group.1 | Race == input$racial.group.2)
    
    #Selecting interest
    if(input$interest.select == "Importance of Partner Attributes") {
      speed.dating.df <- select(speed.dating.df, Race, Sex, `Partner Attractiveness`:`Partner Shared Interest`)

    }
    if(input$interest.select == "Participant's Interest in Hobbies") {
      speed.dating.df <- select(speed.dating.df, Race, Sex, Sports:Yoga)
    }
    if(input$interest.select == "Importance of Race or Religion") {
      speed.dating.df <- select(speed.dating.df, Race, Sex, `Importance of Same Race`, `Importance of Same Religion`)
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
  
  yaxis.second.max <- reactive ({
    if(input$interest.select == "Importance of Partner Attributes") {
      return(25)
    }
    return(10)
  })
  
  second.vis.title.react <- reactive({
    if(input$interest.select == "Importance of Partner Attributes") {
      return("Importance of Partner Attributes")
    }
    
    if(input$interest.select == "Participant's Interest in Hobbies") {
      return("Participant's Interest in Certain Hobbies")
    }
    
    if(input$interest.select == "Importance of Race or Religion") {
      return("Importance of Race or Religion to Participant")
    }
  })
  
  output$second.vis.title <- renderText({
    return(second.vis.title.react())
  })
  
  output$second.vis.title.two <- renderText({
    return(second.vis.title.react())
  })
  
  output$second.vis.female <- renderPlotly({
      filter(second.vis.data(), Sex == 'Female') %>%
      plot_ly(x = ~interest, y = ~Median, type = "bar", color = ~Race) %>%
      layout(margin = list(b = 150), xaxis = list(title = ""), yaxis = list(title = "Median Rating", range = c(0, yaxis.second.max())))
    })
  
  output$second.vis.male <- renderPlotly({
    filter(second.vis.data(), Sex == 'Male') %>%
      plot_ly(x = ~interest, y = ~Median, type = "bar", color = ~Race) %>%
      layout(margin = list(b = 150), xaxis = list(title = ""), yaxis = list(title = "Median Rating", range = c(0, yaxis.second.max())))
  })
  
  

}

shinyServer(server)