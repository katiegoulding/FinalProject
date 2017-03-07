library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)

simpleSpeedDating.df <- read.csv("data/simpleSpeedDating.df.csv", stringsAsFactors = FALSE)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      #Dropdown menu to select a racial group
      selectInput("racial.group.1", label = h5("Select a racial group:"), 
                  choices = list("Black/African American",
                                 "European/Caucasian American",
                                 "Latino/Hispanic American",
                                 "Asian/Pacific Islander/Asian-American",
                                 "Other"), selected = "Black/African American"),
      #Dropdown menu to select another racial group to compare to the first racial group
      selectInput("racial.group.2", label = h5("Select another racial group to compare:"), 
                  choices = list("Black/African American",
                                 "European/Caucasian American",
                                 "Latino/Hispanic American",
                                 "Asian/Pacific Islander/Asian-American",
                                 "Other"), selected = "European/Caucasian American"),
      #Radiobuttons to select the interest to view
      radioButtons("interest.select", label = h5("Select an Interest:"),
                   choices = list("Attribute Rating", "Hobbies", "Importance of Race or Religion"),
                   selected = NULL, inline = FALSE
      )
    ),
    mainPanel(
      #Plot second visualization
      plotlyOutput("second.vis.female"),
      plotlyOutput("second.vis.male")
      
    )
  )
)

shinyUI(ui)