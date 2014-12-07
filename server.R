#server.R

source("helpers.R")

library(ggplot2)
library(rgdal)
library(RCurl)

load("data/AFG_adm2.RData")
country.adm2.spdf <- get("gadm")

country.adm1.df <- fortify(country.adm2.spdf, region = "NAME_1")

# Get names and id numbers corresponding to administrative areas
country.adm2.centroids.df <- data.frame(long = coordinates(country.adm2.spdf)[, 1], 
                                           lat = coordinates(country.adm2.spdf)[, 2]) 

country.adm2.centroids.df[, 'ID_2'] <- country.adm2.spdf@data[,'ID_2']
country.adm2.centroids.df[, 'NAME_2'] <- country.adm2.spdf@data[,'NAME_2']
country.adm2.centroids.df[, 'NAME_1'] <- country.adm2.spdf@data[,'NAME_1']

toplot0 <- fortify(country.adm2.spdf, region = "NAME_0")

shinyServer(function(input, output) {
  
  dfInput <- reactive({
    getdf2(country.adm2.spdf, input$var1)
  })
  
  centroidInput <- reactive({
    getCentroids(country.adm2.centroids.df, input$var1, input$var2)
  })
  
  plot1Input <- reactive({
    getPlot1(country.adm1.df, input$var1)
  })
  
  districtInput <- reactive({
    getDistricts(dfInput())
  })
  
  plot2Input <- reactive({
   getPlot2(dfInput(), input$var2)
  })
  
  output$province <- renderUI({
    province_list <- levels(as.factor(country.adm2.spdf@data[,'NAME_1']))
    selectInput("var1", "Select a Province", choices=province_list, selected=province_list[1], selectize = FALSE)
  })
  
  output$district <- renderUI({
    district_list <- districtInput()
    checkboxGroupInput("var2", label="Select Districts", choices=district_list)
 })

   output$map <- renderPlot({
    toplot1 = plot1Input()
    if (length(input$var2) <= 0) {
      province_map(all=toplot0,toplot1, country = input$type)
    } else {
      toplot2 = plot2Input()
      centroids = centroidInput()
      district_map(all=toplot0,toplot1, toplot2, centroids, fill = input$fill, size = input$slider, country = input$type)
    }
  })
})