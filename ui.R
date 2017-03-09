library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)
# Reads in cleansed data
simpleSpeedDating.df <- read.csv("data/simpleSpeedDating.df.csv", stringsAsFactors = FALSE)


######## SECOND HOMEPAGE VIS ########


ui <- navbarPage(
  navbarPage("Speed Dating!",
             tabPanel("Home", 
                      h3("Race and Gender Breakdown of Participants"),
                      plotlyOutput("race.graph"),
                      p("The dataset that this report interacts with has been collected from Columbia Business School professors Ray Fisman and Sheena Iyengar.
                      The report contains information from 551 participants that performed a number of randomized four minute speed dates.  During the date they
                      were asked to rank their date on a variety of factors, and after the date was completed, they indicated whether they would want to see their date again.
                      If each date indicated yes, then they would be sent each other's email addresses the following day, this was to make the study have potential real world implications.
                      As noted by the creators of the study, “we made a special effort to ensure that our design creates a setting similar to that provided by the private firms operating in this market.
                      They were also asked to rate their date on six attributes: Attractiveness, Sincerity, Intelligence, Fun, Ambition, and Shared Interests (Fisman and Iyengar)”  		
                      This report focuses on finding new insights not covered in Fisman and Iyengar’s report.  Disclaimer:  All responses are from Columbia University graduate students, thus,
                      we can expect different proportions of racial groups, socioeconomic status, and more to be represented differently compared to the United States population.
                      Additionally we recognize that 75% of the students involved in this study are from the United States.  There is a total of 551 participants and 4 distinct racial groups,
                      with an additional “Other” category included. 55% of the participants are European / Caucasian.")
             ),
             tabPanel("Tool - Find Match",
                      sidebarLayout(
                        sidebarPanel(
                          
                          # Title for the sidebar for user understanding
                          h4("Home"),
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
             
             tabPanel("Citations",
                      h1("Source of the study:"),
                      tags$a(href="http://faculty.chicagobooth.edu/emir.kamenica/documents/genderDifferences.pdf", "Link to Columbia University study")                      
                      
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