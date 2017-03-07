library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)

simpleSpeedDating.df <- read.csv("data/simpleSpeedDating.df.csv", stringsAsFactors = FALSE)

#View(simpleSpeedDating.df)

#Change column names to make plot more readable to user
colnames(simpleSpeedDating.df)[which(names(simpleSpeedDating.df) == "Preference.of.Partner.Attract")] <- "Partner Attractiveness"
colnames(simpleSpeedDating.df)[which(names(simpleSpeedDating.df) == "Preference.of.Partner.Sincerity")] <- "Partner Sincerity"
colnames(simpleSpeedDating.df)[which(names(simpleSpeedDating.df) == "Preference.of.Partner.Intelligence")] <- "Partner Intelligence"
colnames(simpleSpeedDating.df)[which(names(simpleSpeedDating.df) == "Preference.of.Partner.Fun")] <- "Partner Fun"
colnames(simpleSpeedDating.df)[which(names(simpleSpeedDating.df) == "Preference.of.Partner.Ambition")] <- "Partner Ambition"
colnames(simpleSpeedDating.df)[which(names(simpleSpeedDating.df) == "Preference.of.Partner.Shared.Interest")] <- "Partner Shared Interest"
colnames(simpleSpeedDating.df)[which(names(simpleSpeedDating.df) == "Importance.Same.Race")] <- "Importance of Same Race"
colnames(simpleSpeedDating.df)[which(names(simpleSpeedDating.df) == "Importance.Same.Religion")] <- "Importance of Same Religion"

server <- function(input, output, session) {
  second.vis.data <- reactive({
    speed.dating.df <- simpleSpeedDating.df
    #Selecting racial groups
    speed.dating.df <- filter(speed.dating.df, Race == input$racial.group.1 | Race == input$racial.group.2)
    
    #Selecting interest
    if(input$interest.select == "Attribute Rating") {
      speed.dating.df <- select(speed.dating.df, Race, `Partner Attractiveness`:`Partner Shared Interest`)
    }
    if(input$interest.select == "Hobbies") {
      speed.dating.df <- select(speed.dating.df, Race, Sports:Yoga)
    }
    if(input$interest.select == "Importance of Race or Religion") {
      speed.dating.df <- select(speed.dating.df, Race, `Importance of Same Race`, `Importance of Same Religion`)
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


  #x <- list(
  #  title = "TESTTTTt",
  #  titlefont = NULL
  #)

# add this for more hover details text=data()$my_text, hoverinfo = "text+x+y")

  yaxis.max <- reactive ({
    if(input$interest.select == "Attribute Rating") {
      return(20)
    }
    return(10)
  })
  
  
 output$second.vis <- renderPlotly({
   plot_ly(second.vis.data(), x = ~interest, y = ~Median, type = "bar", color = ~Race) %>%
   layout(margin = list(b = 150, r = 100), yaxis = list(range = c(0, yaxis.max())))
 })


}

shinyServer(server)


