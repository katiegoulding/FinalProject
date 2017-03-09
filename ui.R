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
                   choices = list("Importance of Partner Attributes", "Participant's Interest in Hobbies", "Importance of Race or Religion"),
                   selected = NULL, inline = FALSE
      )
    ),
    mainPanel(
      #Plot second visualization
      h3("Importance of Partner Attributes Female"),
      plotlyOutput("second.vis.female"),
      h3("Importance of Partner Attributes Male"),
      plotlyOutput("second.vis.male"),
      p("	This interactive visualization allows the user to compare racial groups and their preferences on specific qualities of their partner.  
        The groups are broken down into attribute rating, hobbies, and importance of race and religion.  The attribute rating focuses on preference 
        of partner ambition, attractiveness, fun, intelligence, shared interest, and sincerity.  The hobby category compares art, clubbing, gaming, 
        sports, and yoga as general interests.  Lastly, this visualization performs a comparison on race and how it effects the importance of race 
        and religion in seeing the person on another date.  The visualization is further broken down into two graphs based on gender.")
    )
  )
)

shinyUI(ui)