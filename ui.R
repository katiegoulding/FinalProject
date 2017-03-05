library(shiny)

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
                                   "Asian/Pacific Islander/Asian-American",
                                   "Other"), selected = 1),
        radioButtons("sex_select", label = h5("Select a Sex:"),
                     choices = list("Male" = 1, "Female" = 2, "All" = 3),
                     selected = NULL, inline = FALSE
        )
      ),
    
    mainPanel(
    )
  )
  
  navbarPage("Speed Dating!",
             tabPanel("Home"),
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
                          plotOutput("plot")
                        )
                        )
                        ),
             navbarMenu("More",
                        tabPanel("About Our Group",
                                 dataTableOutput("table")
                        ),
                        tabPanel("Write Up and Works Cited",
                                 dataTableOutput("table")
                        )
             )
  )
)

shinyUI(ui)