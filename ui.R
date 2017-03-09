library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)
# Reads in cleansed data
simpleSpeedDating.df <- read.csv("data/simpleSpeedDating.df.csv", stringsAsFactors = FALSE)


ui <- navbarPage(
  navbarPage("Speed Dating!",
             tabPanel("Home", 
                      h3("Race and Gender Breakdown of Participants"),
                      plotlyOutput("race.graph"),
                      h4("Intro:"),
                      p("The dataset that this report interacts with has been collected from Columbia Business School in 2004 by professors Ray Fisman and Sheena Iyengar.
                      The report contains information from 551 participants that performed a number of randomized four minute speed dates.  During the date they
                      were asked to rank their date on a variety of factors, and after the date was completed, they indicated whether they would want to see their date again.
                      If each date indicated yes, then they would be sent each other's email addresses the following day. This email address incentive was to make the study have potential real world implications.
                      As noted by the creators of the study, “we made a special effort to ensure that our design creates a setting similar to that provided by the private firms operating in this market.
                      They were also asked to rate their date on six attributes: Attractiveness, Sincerity, Intelligence, Fun, Ambition, and Shared Interests (Fisman and Iyengar)”  		
                      This report focuses on finding new insights not covered in Fisman and Iyengar’s report.  Disclaimer #1:  All responses are from Columbia University graduate students, thus,
                      we can expect different proportions of racial groups and socioeconomic status. Additionally, we recognize that 75% of the students involved in this study are from the United States. There is a total of 551 participants and 4 distinct racial groups,
                      with an additional “Other” category included. It is critical to understand that the trends in this report do not represent greater populations.
                      These insights can be helpful to understand how a contained group of people interact, especially in romantic circumstances, rather than to create broad stereotypes of groups.
                        Disclaimer #2: This study was conducted under the assumption of gender as a binary, misleading the audience to further catergorize gender.")
             ),
             tabPanel("Citations",
                      h1("Source of the study:"),
                      tags$a(href="http://faculty.chicagobooth.edu/emir.kamenica/documents/genderDifferences.pdf", "Link to Columbia University study")                      
                      
                      )
  )
)

shinyUI(ui)