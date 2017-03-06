library(shiny)
library(dplyr)
library(plotly)
library(ggplot2)

simpleSpeedDating.df <-
  read.csv("data/simpleSpeedDating.df.csv", stringsAsFactors = FALSE)

ui <- fluidPage(
  titlePanel(title = "Speed Dating Data"),
  p("Sean Campbell, Parker Singh, Katie Goulding, August Carow"),
  sidebarLayout(
    sidebarPanel(
      # Select Box for graph
      #'input.dataset === ""',
      #Dropdown menu to select racial group
      selectInput(
        "racial_group",
        label = h5("Select a racial group"),
        choices = list(
          "Black/African American",
          "European/Caucasian American",
          "Latino/Hispanic American",
          "Asian/Pacific Islander/Asian-American",
          "Other"
        ),
        selected = "Black/African American"
      ),
      #Radio buttons to select gender
      radioButtons(
        "sex_select",
        label = h5("Select a Sex:"),
        choices = list("All", "Female", "Male"),
        selected = NULL,
        inline = FALSE
      )
    ),
    
    mainPanel(plotlyOutput("first.vis"))
  )
)

shinyUI(ui)