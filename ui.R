library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)

simpleSpeedDating.df <- read.csv("data/simpleSpeedDating.df.csv", stringsAsFactors = FALSE)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("racial.group.1", label = h5("Select a racial group:"), 
                  choices = list("Black/African American",
                                 "European/Caucasian American",
                                 "Latino/Hispanic American",
                                 "Asian/Pacific Islander/Asian-American",
                                 "Other"), selected = "Black/African American"),
      selectInput("racial.group.2", label = h5("Select another racial group to compare:"), 
                  choices = list("Black/African American",
                                 "European/Caucasian American",
                                 "Latino/Hispanic American",
                                 "Asian/Pacific Islander/Asian-American",
                                 "Other"), selected = "European/Caucasian American"),
      radioButtons("interest.select", label = h5("Select an Interest:"),
                   choices = list("Attribute Rating", "Hobbies", "Importance of Race or Religion"),
                   selected = NULL, inline = FALSE
      )
    ),
    mainPanel()
  )
)

shinyUI(ui)