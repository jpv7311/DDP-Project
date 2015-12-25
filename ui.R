library(shiny)
shinyUI(pageWithSidebar(
      headerPanel("Poisson - statistical test"),
      sidebarPanel(
            h4('Description'),
            p('This shiny application provides statistical test based on Poisson distribution - if observed 
              number of events is statistically different than expected.'),
            p('For example production line in manufacture produces 5 defects per 1 hour on average.
             Recently production line produced 8 defects in 1 hour. Can one say that this is statistically
              different than 5 defects per hour and we observe some process change?'),
            a("Poisson distribution - Wikipedia",href='https://en.wikipedia.org/wiki/Poisson_distribution'),
            h4('User input'),
            numericInput('id1', 'Number of expected events', 10, min = 1, max = 500, step = 1),
            numericInput('id2', 'Number of observed events', 20, min = 0, max = 200, step = 1),
            sliderInput('id3', 'Test significance level [%]',value = 5, min = 1, max = 20, step = 1),
            # submitButton('Calculate'),
            h4('-------------------------------------------------------------'),
            h4('Test results'),
            br(),
            textOutput("outputX2"),
            textOutput("outputX1"),
            br(),
            p('* Green and red lines on PDF and CDF charts represent observed number of events
              and limit for one-sided test.',style = "color:blue")
      ),
      mainPanel(
            plotOutput('PDFplot',width = "600px",height = "400px"),
            plotOutput('CDFplot',width = "600px",height = "400px")
      )
))