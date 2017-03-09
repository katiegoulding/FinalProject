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
      h4(textOutput("second.vis.title"), em("Female")),
      plotlyOutput("second.vis.female"),
      h4(textOutput("second.vis.title.two"), em("Male")),
      plotlyOutput("second.vis.male"),
      h4("Intro:"),
      p("This interactive visualization allows the user to compare racial groups and their preferences on specific
        qualities of their partner.  The groups are broken down into attribute rating, hobbies, and importance of
        race and religion.  The attribute ratings display preference of partner ambition, attractiveness, fun,
        intelligence, shared interest, and sincerity.  The hobby category compares art, clubbing, gaming, sports,
        and yoga as general interests. Lastly, this visualization examines different racial groups’ ratings of the
        importance of race and religion in a potential partner. The visualization is further broken down into two graphs
        based on participants’ sex."),
      hr(),
      h4("How to:"),
      p("First, select two racial groups from the drop down menus in the top left,
        then consider filtering to select importance of race or religion, attributes, or hobbies. 
        Each time the widgets are changed both female and male graphs reflect that change."),
      hr(),
      h4("Method:"),
      p("We chose to find the median value in every category of each racial group's rating and display that on the graph. We wanted to
        ensure that the values we visualized were reflective of the population, rather than demonstrated the skewness of the data, which is why 
        we chose medians instead of means.
        For the ratings of Importance of Partner Attributes, the study gave participants one hundred points to distribute 
        among the areas to demonstrate their value. For the other two graphs participants simply rated the categories/statements
        out of ten."),
      hr(),
      h4("Insights:"),
      p("Our group focused on comparing racial groups and gender in this visualization. 
        We found out that amongst the different racial groups there is little to no change 
        in importance of race, religion, and attributes when doing a pretest on the factors
        that would contribute to a second date. It seems almost everyone thinks they don’t hold biases 
        towards people’s race and religion, but our data in the first visual draws doubt on this. There was, however, 
        a difference in the types of hobbies that racial groups have interests in.  For example, when comparing European/Caucasian 
        American to Asian/Pacific Islander/Asian-American we see striking differences in the interests in gaming and yoga.
	      The male and female ratings of partner attributes is where we see the largest disparity. 
        When comparing European/Caucasian American to Asian/Pacific Islander/Asian-American again, 
        we see that females rate partner attractiveness at a shocking median 23, 24 (respective to the ordering of 
        racial groups above). Males, however, rate for importance of partner attractiveness as 15/15 (respectively). 
        This insight comes as a surprise to our group. This difference is spread out across the male's interest in their 
        partner's sincerity, ambition, and shared interests. In conclusion, we found disparity amongst the interest in hobbies, 
        and partner attributes by sex, and a reported lack of importance in having the same race or religion as your partner.")
    )
  )
)

shinyUI(ui)