library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)

simpleSpeedDating.df <- read.csv("data/simpleSpeedDating.df.csv", stringsAsFactors = FALSE)

server <- function(input, output) {

  third_vis_data <- reactive({
    speed.dating.df <- simpleSpeedDating.df

    speed.dating.df <- group_by(speed.dating.df, Partner.ID, Sex) %>%
      summarize(mean1 = mean(Overall.Like), mean2 = mean(Final.Attractiveness.Rating), mean3 = mean(Final.Sincerity.Rating)) %>%
      mutate(overall.success = (mean1 + mean2 + mean3)/3) %>%
      drop_na
    View(speed.dating.df)

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

  output$third.vis <- renderPlotly({
    pal <- c("#006bfa", "#ede800")
    plot_ly(third_vis_data(), x = ~overall.confidence, y = ~overall.success, color = ~Sex, colors = pal, opacity = 0.7) %>%
          layout(yaxis = list(range = c(0, 1), title = "Success of Participant", dtick = .2, tick0 = 0),
                 xaxis = list(title = "Confidence of Participant", tick0 = 0, dtick = .2, range = c(0, 1)))
  })


}

shinyServer(server)
