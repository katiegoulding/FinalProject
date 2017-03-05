library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)
# Reads in cleansed data
simpleSpeedDating.df <- read.csv("data/simpleSpeedDating.df.csv")


######## SECOND HOMEPAGE VIS ########

count.per.sex <- select(simpleSpeedDating.df, ID, Sex) %>% 
                  unique() %>% 
                  group_by(Sex) %>% 
                  summarize(count = n()) %>% 
                  drop_na()
total.participants <- sum(count.per.sex$count)
# Creates df with percent breakdown
sex.df <- mutate(count.per.sex, ratio.sex = (count))
# Creates an x-axis title
x <- list(
  title = "Sex"
)
# Creates a y-axis title
y <- list(
  title = "Number of persons identified with respective gender"
)
# Creates a title for the sex bar graph ***does not work***
title.sex <- list(
  title = "Sex breakdown of all participants"
)
# Produces plotly bar graph of sex breakdown
sex.graph <- plot_ly(
  x = sex.df$Sex,
  y = sex.df$ratio.sex,
  name = "Participant Sex Breakdown",
  type = "bar",
  color = sex.df$Sex,
  showlegend = FALSE) %>% 
  layout(title = title.sex, xaxis = x, yaxis = y)


######## THIRD HOMEPAGE VIS ########

ui <- navbarPage(
  
  navbarPage("Speed Dating!",
             tabPanel("Home", plotlyOutput("race.graph"), p("home!")),
             tabPanel("Tool - Find Match",
                      sidebarLayout(
                        sidebarPanel(
                          
                          # Title for the sidebar for user understanding
                          h4("Some sort of title"),
                          br(),
                          checkboxGroupInput("race", "Race:",
                                             c("X" = "connect1",
                                               "Y" = "connect2",
                                               "Z" = "connect2")),
                          sliderInput('height', label="TEST", min=0,
                                      max=5, value = 5, step = 1),
                          sliderInput('attractiveness', label="Attractiveness", min=0,
                                      max=5, value = 5, step = 1),
                          sliderInput('age', label="Age", min=0,
                                      max=30, value = 20, step = 5),
                          br(),
                          checkboxGroupInput("sex", "Gender?:",
                                             c("X" = "one",
                                               "Y" = "two",
                                               "Z" = "three")),
                          helpText('Brief information about the data we
                                   are showing.')
                        ),
                        mainPanel(
                          p("this is main")
                          
                        )
                      )
             ),
             navbarMenu("More",
                        tabPanel("About Our Group",
                                 p("table")
                        ),
                        tabPanel("Write Up and Works Cited",
                                 dataTableOutput("table")
                        )
             )
  )
)

shinyUI(ui)