# Libraries we use in this report.
library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)

#Reading in the data frame
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
  
  #Creating a reactive data for plot based on widgets
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
  
  #Rendering data in plotly bar chart
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
        xaxis = list(title = "Race of Partner", tickangle = 25),
        yaxis = list(title = "Match Percentage"),
        showlegend = FALSE,
        margin = list(b = 150)
      )
  })

  #Creating a reactive variable for the second visualization
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
  
  #Adjusting the yaxis max for the graph
  yaxis.second.max <- reactive ({
    if(input$interest.select == "Importance of Partner Attributes") {
      return(25)
    }
    return(10)
  })
  
  #Adjusting the title for the second vis
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
  
  #Rendering the second vis title for male
  output$second.vis.title <- renderText({
    return(second.vis.title.react())
  })
  
  #Rendering the second vis title for female
  output$second.vis.title.two <- renderText({
    return(second.vis.title.react())
  })
  
  #Rendering the female plot
  output$second.vis.female <- renderPlotly({
      filter(second.vis.data(), Sex == 'Female') %>%
      plot_ly(x = ~interest, y = ~Median, type = "bar", color = ~Race) %>%
      layout(margin = list(b = 85), xaxis = list(title = ""), yaxis = list(title = "Median Rating", range = c(0, yaxis.second.max())))
    })
  
  #Rendering the male plot
  output$second.vis.male <- renderPlotly({
    filter(second.vis.data(), Sex == 'Male') %>%
      plot_ly(x = ~interest, y = ~Median, type = "bar", color = ~Race) %>%
      layout(margin = list(b = 85), xaxis = list(title = ""), yaxis = list(title = "Median Rating", range = c(0, yaxis.second.max())))
  })

  #Reactive data for the third vis
  third_vis_data <- reactive({
    speed.dating.df <- simpleSpeedDating.df

    #Cleaning data for third vis
    speed.dating.df <- group_by(speed.dating.df, Partner.ID, Sex) %>%
      summarize(mean1 = mean(Overall.Like), mean2 = mean(Final.Attractiveness.Rating), mean3 = mean(Final.Sincerity.Rating)) %>%
      mutate(overall.success = (mean1 + mean2 + mean3)/3) %>%
      drop_na

    names(speed.dating.df)[names(speed.dating.df) == "Partner.ID"] <- "ID"
    simpleSpeedDating.df$Attractiveness.5[is.na(simpleSpeedDating.df$Attractiveness.5)] <- mean(simpleSpeedDating.df$Attractiveness.5, na.rm = TRUE)
    simpleSpeedDating.df$Fun.5[is.na(simpleSpeedDating.df$Fun.5)] <- mean(simpleSpeedDating.df$Fun.5, na.rm = TRUE)
    simpleSpeedDating.df$Ambition.5[is.na(simpleSpeedDating.df$Ambition.5)] <- mean(simpleSpeedDating.df$Ambition.5, na.rm = TRUE)
    simpleSpeedDating.df$Intelligence.5[is.na(simpleSpeedDating.df$Intelligence.5)] <- mean(simpleSpeedDating.df$Intelligence.5, na.rm = TRUE)
    simpleSpeedDating.df$Sincerity.5[is.na(simpleSpeedDating.df$Sincerity.5)] <- mean(simpleSpeedDating.df$Sincerity.5, na.rm = TRUE)

    simpleSpeedDating.df$Expected.Matches[is.na(simpleSpeedDating.df$Expected.Matches)] <- mean(simpleSpeedDating.df$Expected.Matches, na.rm = TRUE)
    speed.dating.df <- merge(x = speed.dating.df, y = simpleSpeedDating.df[ , c("ID", "Expected.Matches", "Attractiveness.4", "Sincerity.4", "Intelligence.4", "Fun.4",
                                                                                "Ambition.4", "Attractiveness.5", "Sincerity.5", "Intelligence.5", "Fun.5", "Ambition.5")], by = "ID", na.rm = TRUE) %>%
                        unique()

    speed.dating.df$Expected.Matches <- (speed.dating.df$Expected.Matches) / 20
    speed.dating.df[, 8:17] <- speed.dating.df[, 8:17] / 10
    speed.dating.df$overall.success <- speed.dating.df$overall.success / 10
    speed.dating.df$overall.confidence <- (speed.dating.df$Attractiveness.4 + speed.dating.df$Sincerity.4 + speed.dating.df$Intelligence.4 +
                                             speed.dating.df$Fun.4 + speed.dating.df$Ambition.4 + speed.dating.df$Attractiveness.5 + speed.dating.df$Sincerity.5 + speed.dating.df$Intelligence.5 +
                                             speed.dating.df$Fun.5 + speed.dating.df$Ambition.5) / 10

    speed.dating.df <- filter(speed.dating.df, overall.confidence > input$confidence[1] & overall.confidence < input$confidence[2]) %>%
      filter(overall.success > input$success[1] & overall.success < input$success[2])

    return(speed.dating.df)
  })

  #Rendering the third vis plot
  output$third.vis <- renderPlotly({
    pal <- c("#006bfa", "#ede800")
    plot_ly(third_vis_data(), x = ~overall.confidence, y = ~overall.success, color = ~Sex, colors = pal, opacity = 0.7) %>%
          layout(yaxis = list(range = c(0, 1), title = "Success of Participant", dtick = .2, tick0 = 0),
                 xaxis = list(title = "Confidence of Participant", tick0 = 0, dtick = .2, range = c(0, 1)))
  })

  #Rendering the home graph plot
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
          layout(xaxis = x, yaxis = y, margin = list(b = 50, r = 30, l = 200))
    })
}

shinyServer(server)
