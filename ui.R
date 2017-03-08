library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)

simpleSpeedDating.df <- read.csv("data/simpleSpeedDating.df.csv", stringsAsFactors = FALSE)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput("confidence", label = h5("Select confidence range:"), min = 0,  max = 1, value = c(0, 1)
      ),
      
      sliderInput("success", label = h5("Select success range:"), min = 0,  max = 1, value = c(0, 1)
      )
    ),
    mainPanel(
      h1("Confidence vs. Success"),
      
      plotlyOutput("third.vis"),
      
      h5("This graph plots the participant's confidence of meeting a potential mate against their success level. 
         At the beginning of this study, and after every four minute date, participants filled out a survey rating 
         their date on attributes (attractiveness, fun, ambition, intelligence, and sincerity) and asked questions 
         of seeing them again. In determining a participant's confidence and success level, we utilized the responses
         to this survey and created a composite score. "),
      h3(strong("Confidence Level")),
      h5("To determine the confidence level of each participant, we used the responses to three questions from the
         survey described above. The questions are the following:"),
      h5("1.  Out of the 20 people you will meet, how many do you expect will be interested in dating you?"),
      h5("2.  How do you think you measure up? (on a scale of 1-10)"),
      h5("3.  How do you think others perceive you? (on a scale of 1-10 (1=awful, 10=great))"),
      
      h5("For question 1, we connected that the greater the response number (a greater number of people they expected 
         to match with), the more confident the participant is. Similarly, for question 2 and 3, the higher the 
         response rating, the higher the confidence level. We then proceeded to take the mean of the responses and
         utilize that as our composite score for confidence level."),
      h3(strong("Success Level")),
      h5("In determining the success level of participants, we looked at how the participants they paired with rated 
         the other on three questions:"),
      h5("1.  Overall, how much do you like this person? (on a scale of 1-10 (1=do not like, 10=like a lot)"),
      h5("2.  Rate their attractiveness (on a scale of 1-10 (1=awful, 10=great)"),
      h5("3.  Rate their sincerity (on a scale of 1-10 (1=awful, 10=great)"),
      
      h5("For each question, we calculated the mean score per participant. Then, we calculated the mean of the three mean scores. 
         The resulting value determined the success score for each participant."),
      
      h3(strong("Summary")),
      h5("We plotted the composite confidence and success scores, allowing our audience to notice the clustering of participants
        who were seemingly more confident than successful.")
      )
  )
)



shinyUI(ui)