library(shiny)
library(dplyr)
library(plotly)
library(ggplot2)

simpleSpeedDating.df <-
  read.csv("data/simpleSpeedDating.df.csv", stringsAsFactors = FALSE)

ui <- navbarPage(
    navbarPage(
    "Speed Dating!",
    tabPanel("Home"),
    tabPanel("Match Percentage",
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
                 #Radio buttons to select if the Matches have met before
                 radioButtons(
                   "met_before",
                   label = h5("Matches Met Before:"),
                   choices = list("Both", "Have Met Before", "Have Not Met Before"),
                   selected = "Both"
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
               
               
               mainPanel(plotlyOutput("first.vis"), 
                         h4("Intro:"),
                         p("This interactive visualization allows the user to look at the
                           percentage of matches that a specific racial group had with other racial groups in the study."),
                         hr(),
                         h4("How to:"),
                         p("First, select a racial group from the drop down menu in the top left, and consider further filters:
                           select whether or not the participants have met before, select to view either males or females,
                           or both sexes so as to review match percentages with additional insights."),
                         hr(),
                         h4("Method:"),
                         p("To calculate match percentages we found the total number of “interactions” or “meetings” between each racial group,
                           and considered that as the “total interactions” for each racial group pair. Then, we gathered the reported matches 
                           within those interactions and considered that as our “total matches.”
                           Finally, we created ratios of total matches to total interactions for each racial group pair."),
                         hr(),
                         h4("Insights"),
                         p("Our group wasn’t sure what to expect when viewing match percentages among participants. 
                           Initially, we only thought to examine how people of certain races matched with one another. 
                           Though, the graphs that correspond with that query are misleading. For example, in the graph that demonstrates
                           African American participants’ matching rates, it appears that they match the most with people of their own race.
                           Without looking further, one might conclude that people flat-out prefer people of their own race. This suspiciously
                           simple finding pushed us to look further. We decided to filter matching percentages by whether or not participants had
                           met before. This would be a much better base from which to compare matches; people who had not met before did not have the
                           same chance of matching as people who already knew each other, so they shouldn’t be combined. The results of this new
                           filter were interesting: there was significantly less variation of match percentage when the participants were strangers,
                           but greater variation when the participants did know each other. So perhaps, in the end, it is not the racial group that
                           determines who someone would date, but rather who they know (though these things can be connected).
                           It’s important to note that this is a population is a relatively small group of Colombia students (550),
                           and that some of the racial groups have less than a hundred participants, or even less than fifty.
                           Thus, it is critical to understand that the trends in this report do not represent greater populations.
                           These insights can be helpful to understand how a contained group of people interact, especially in romantic
                           circumstances, rather than to create broad stereotypes of groups.")
                         )
               )
    ),
    tabPanel("Characteristics"),
    tabPanel("Confidence & Success")
  )
)

shinyUI(ui)