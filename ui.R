
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
library(rCharts)

shinyUI(
  navbarPage(
      "State GDP Explorer",
       tabPanel("GDP",
          sidebarPanel(
            selectInput("year", "Year:", 1997:2013),            
            uiOutput("industryControls")
          ),
          
          mainPanel(
            tabsetPanel(
              tabPanel('Map',
                       column(7,
                              plotOutput("gdpByState", width="auto")
                       )
                       
              ),
              tabPanel('Dataset',
                       dataTableOutput(outputId="table"),
                       downloadButton('downloadData', 'Download')
              )
            )
          )
       ),
       tabPanel("Help",mainPanel(includeMarkdown("help.md")))
  )
)
