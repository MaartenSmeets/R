#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    x <- data.frame("x" = faithful[, 2]) 
    # draw the histogram with the specified number of bins
    ggplot(x) +
        geom_histogram(aes(x = x), binwidth = input$bins, fill = "red", colour = "black")
    
  })
  
})
