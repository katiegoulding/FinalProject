library(shiny)
library(dplyr)
library(plotly)
library(ggplot2)

simpleSpeedDating.df <-
  read.csv("data/simpleSpeedDating.df.csv", stringsAsFactors = FALSE)

ui <- navbarPage(
    navbarPage(
    "Speed Dating Data App & Report",
    tabPanel("Home",
             h2("Speed Dating Data App & Report"),
             hr(),
             h4("Race and Gender Breakdown of Participants"),
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
               
               mainPanel(h3("Percentage Breakdown of Racial Group Matches"),
                         plotlyOutput("first.vis"), 
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
    tabPanel("Characteristics",
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
        h3(textOutput("second.vis.title"), em("Female")),
        plotlyOutput("second.vis.female"),
        h3(textOutput("second.vis.title.two"), em("Male")),
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
    ),
    tabPanel("Confidence & Success",
      sidebarLayout(
        sidebarPanel(
      sliderInput("confidence", label = h5("Select confidence range:"), min = 0.35,  max = 0.97, value = c(0.35, 0.97)
      ),
      sliderInput("success", label = h5("Select success range:"), min = 0.45,  max = 0.85, value = c(0.45, 0.85)
      )
    ),
    mainPanel(
      h3("Confidence vs. Success"),
      plotlyOutput("third.vis"),
      h4("Intro:"),
      p("This graph plots the participant's confidence of meeting a potential mate against their success level.
         At the beginning of this study, and after every four minute date, participants filled out a survey rating
         their date on attributes (attractiveness, fun, ambition, intelligence, and sincerity) and asked questions
         of seeing them again. In determining a participant's confidence and success level, we utilized the responses
         to this survey and created a composite score."),
      hr(),
      h4("How to:"),
      p("Simply use the sliders to set the range of confidence and success you'd like to view on the graph."),
      hr(),
      h4("Method:"),
      h5("Confidence Level"),
      p("To determine the confidence level of each participant, we used the responses to three questions from the
         survey described above. The questions are the following:"),
      p("1.  Out of the 20 people you will meet, how many do you expect will be interested in dating you?"),
      p("2.  How do you think you measure up? (on a scale of 1-10)"),
      p("3.  How do you think others perceive you? (on a scale of 1-10 (1=awful, 10=great))"),

      p("For question 1, we connected that the greater the response number (a greater number of people they expected
         to match with), the more confident the participant is. Similarly, for question 2 and 3, the higher the
         response rating, the higher the confidence level. We then proceeded to take the mean of the responses and
         utilize that as our composite score for confidence level."),
      h5("Success Level"),
      p("In determining the success level of participants, we looked at how the participants they paired with rated
         the other on three questions:"),
      p("1.  Overall, how much do you like this person? (on a scale of 1-10 (1=do not like, 10=like a lot)"),
      p("2.  Rate their attractiveness (on a scale of 1-10 (1=awful, 10=great)"),
      p("3.  Rate their sincerity (on a scale of 1-10 (1=awful, 10=great)"),

      p("For each question, we calculated the mean score per participant. Then, we calculated the mean of the three mean scores.
         The resulting value determined the success score for each participant."),
      hr(),
      h4("Insights"),
      p("Looking at the plotted composite confidence and success scores, we are able to see the large amount of clustering that occurred.  
         This clustering shows that a majority of the participants are slightly more confident than are successful.")
      )
    )
    ),
   tabPanel("Citations",
      h3("Source of the study:"),
      tags$a(href="http://faculty.chicagobooth.edu/emir.kamenica/documents/genderDifferences.pdf", "Link to Columbia University study"),
      hr(),
      p("Thank you! Katie Goulding, Sean Campbell, Parker Singh, August Carow")
   )
  )
)

shinyUI(ui)
