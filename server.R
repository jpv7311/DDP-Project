library(shiny)
shinyServer(
      function(input, output) {
            #readung user inputs
            EventsExpected <- reactive({as.numeric(input$id1)})
            EventsObserved <- reactive({as.numeric(input$id2)})
            SignificanceLevel <- reactive({as.numeric(input$id3)*0.01})
            
            #defines data for charts - events, Poisson PDF and CDF values
            events <- reactive({ 0:max(2*EventsExpected(),EventsObserved()) })
            PoissonPDF <- reactive({ dpois(events(),EventsExpected()) })
            PoissonCDF <- reactive({ 
                  PoissonCDFtemp <- rep(0,length(events()))
                  for(i in 1:length(events())) {
                        if(i==1) {
                              PoissonCDFtemp[i] <- PoissonPDF()[i]
                        } else {
                              PoissonCDFtemp[i] <- PoissonCDFtemp[i-1]+PoissonPDF()[i]  
                        }  
                  }
                  PoissonCDF <- PoissonCDFtemp
            })
            # calculating Poisson test
            PoissonTest <- reactive({
                  if(EventsObserved()>=EventsExpected()){
                        H1tested <- "less"     
                  } else {
                        H1tested <- "greater"         
                  }
                  PoissonTest <- poisson.test(EventsExpected(), T = 1, r = EventsObserved(),
                         alternative = c(H1tested),conf.level = 1-SignificanceLevel()) 
            })
            #reading pvalue of test results
            pValue <- reactive({
                  pValue <- PoissonTest()$p.value
            })
            #reading limit value for one-sided test to plot this on charts
            ConfInt <- reactive({
                  ConfIntTemp <- PoissonTest()$conf.int
                  if(EventsObserved()>=EventsExpected()){
                        ConfInt <- ConfIntTemp[2]    
                  } else {
                        ConfInt <- ConfIntTemp[1]        
                  }
            })
            # returning test p-value
            output$outputX1 <- renderText({
                  paste('Test p-value = ',pValue())
            })
            # returning test result
            output$outputX2 <- renderText({
                  if(pValue()<SignificanceLevel()){
                        'There is statistical difference between observed and expected number of events.'
                  } else {
                        'There is no statistical difference between observed and expected number of events.'            
                  } 
            })
            # plot of Poisson PDF
            output$PDFplot <- renderPlot({
                  plot(events(),PoissonPDF(),type = "h", main = "Poisson PDF",xlab = "Number of events",ylab = "Probability")
                  abline(v=EventsObserved()+0.001,col=3,lwd=0.5)
                  abline(v=ConfInt(),col=2,lwd=0.5)
            })
            # plot of Poisson CDF
            output$CDFplot <- renderPlot({
                  plot(events(),PoissonCDF(),type = "s", main = "Poisson CDF",xlab = "Number of events",ylab = "Probability")
                  abline(v=EventsObserved(),col=3,lwd=0.5)
                  abline(v=ConfInt(),col=2,lwd=0.5)
            })
        }
)