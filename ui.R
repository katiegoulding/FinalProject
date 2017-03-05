library(shiny)

speedDating.df <- read.csv("data/simpleSpeedDating.df.csv", stringsAsFactors = FALSE)

ui <- fluidPage(
  titlePanel(title = "Speed Dating Data"),
  p("Sean Campbell, Parker Singh, Katie Goulding, August Carow"),
  sidebarLayout(
    sidebarPanel(
      # Select Box for graph
        #'input.dataset === ""',
        selectInput("racial_group", label = h5("Select a racial group"), 
                    choices = list("Black/African American" = 1,
                                   "European/Caucasian American" = 2,
                                   "Latino/Hispanic American" = 3,
                                   "Asian/Pacific Islander/Asian-American" = 4,
                                   "Other" = 5), selected = 1),
        radioButtons("sex_select", label = h5("Select a Sex:"),
                     choices = list("All" = 1, "Female" = 2, "Male" = 3),
                     selected = NULL, inline = FALSE
        )
      ),
    
    mainPanel(
    )
  )
)

shinyUI(ui)