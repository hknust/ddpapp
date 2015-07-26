library(shiny)
library(ggplot2)
library(data.table)
library(maps)
library(rCharts)
library(reshape2)
library(markdown)
library(mapproj)

states_map <- map_data("state")

load("data/state_gdp_final.RData")

industries <- sort(unique(gdp$Description))

shinyServer(function(input, output) {
  gdp.agg <- reactive({
    ss <- subset(gdp, Year == as.numeric(input$year) & Description %in% input$industries, select=c(GeoName,Gdp))
    temp <- aggregate(Gdp ~ GeoName, data=ss, FUN=sum)
    temp[is.na(temp)] <- 0
    temp$GeoName <- tolower(temp$GeoName)
    temp
  })
  
  output$gdpByState <- renderPlot({
    data <- gdp.agg()
    
    title <- paste("GDP by State in ", input$year, "(Million USD)")
    p <- ggplot(data, aes(map_id = GeoName))
    p <- p + geom_map(aes(fill = Gdp), map = states_map, colour='black')  + expand_limits(x = states_map$long, y = states_map$lat)
    p <- p + coord_map() + theme_bw() + scale_fill_continuous(low="blue", high="hotpink") 
    p <- p + labs(x = "Long", y = "Lat", title = title)
    print(p)
  }, width=800, height=600)
  
  output$industryControls <- renderUI({
    if(1) {
      checkboxGroupInput('industries', 'Industries', industries, selected=industries)
    }
  })
  
  dataTable <- reactive({
    gdp
  })
  
  output$table <- renderDataTable(
    {dataTable()}, options = list(bFilter = FALSE, iDisplayLength = 50))
  
  output$downloadData <- downloadHandler(
    filename = 'data.csv',
    content = function(file) {
      write.csv(dataTable(), file, row.names=FALSE)
    }
  )
})