library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)

simpleSpeedDating.df <- read.csv("data/simpleSpeedDating.df.csv", stringsAsFactors = FALSE)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput("confidence", label = h5("Select confidence range:"), min = 0.35,  max = 0.97, value = c(0.35, 0.97)
      ),

      sliderInput("success", label = h5("Select success range:"), min = 0.45,  max = 0.85, value = c(0.45, 0.85)
      )
    ),
    mainPanel(
      h4("Confidence vs. Success"),

      plotlyOutput("third.vis"),
      h4("Intro:"),
      p("This graph plots the participant's confidence of meeting a potential mate against their success level.
         At the beginning of this study, and after every four minute date, participants filled out a survey rating
         their date on attributes (attractiveness, fun, ambition, intelligence, and sincerity) and asked questions
         of seeing them again. In determining a participant's confidence and success level, we utilized the responses
         to this survey and created a composite score."),
      hr(),
      h4("How to:"),
      p("Simply use the sliders to set the range of confidence and success you'd like to view on the graph."),
      hr(),
      h4("Method:"),
      h5("Confidence Level"),
      p("To determine the confidence level of each participant, we used the responses to three questions from the
         survey described above. The questions are the following:"),
      p("1.  Out of the 20 people you will meet, how many do you expect will be interested in dating you?"),
      p("2.  How do you think you measure up? (on a scale of 1-10)"),
      p("3.  How do you think others perceive you? (on a scale of 1-10 (1=awful, 10=great))"),

      p("For question 1, we connected that the greater the response number (a greater number of people they expected
         to match with), the more confident the participant is. Similarly, for question 2 and 3, the higher the
         response rating, the higher the confidence level. We then proceeded to take the mean of the responses and
         utilize that as our composite score for confidence level."),
      h5("Success Level"),
      p("In determining the success level of participants, we looked at how the participants they paired with rated
         the other on three questions:"),
      p("1.  Overall, how much do you like this person? (on a scale of 1-10 (1=do not like, 10=like a lot)"),
      p("2.  Rate their attractiveness (on a scale of 1-10 (1=awful, 10=great)"),
      p("3.  Rate their sincerity (on a scale of 1-10 (1=awful, 10=great)"),

      p("For each question, we calculated the mean score per participant. Then, we calculated the mean of the three mean scores.
         The resulting value determined the success score for each participant."),
      hr(),
      h4("Insights"),
      p("Looking at the plotted composite confidence and success scores, we are able to see the large amount of clustering that occurred.  
         This clustering shows that a majority of the participants are slightly more confident than are successful.")
      )
  )
)



shinyUI(ui)
