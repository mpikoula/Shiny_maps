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

shinyServer(function(input, output) {
  
  dfInput <- reactive({
    getdf2(country.adm2.spdf, input$var1)
  })
  
#   centroidInput <- reactive({
#     getCentroids(country.adm2.centroids.df, input$var2)
#   })
  
#   plot1Input <- reactive({
#     getPlot1(country.adm1.df, $input$var1)
#   })
  districtInput <- reactive({
    getDistricts(dfInput())
  })
  #plot2Input <- reactive({
  #  getPlot2(districtInput()[1], districtInput()[2])
  #})
  
  output$province <- renderUI({
    province_list <- levels(as.factor(country.adm2.spdf@data[,'NAME_1']))
    selectInput("var1", "Select a Province", choices=province_list, selected=province_list[1], selectize = FALSE)
  })
  
  output$district <- renderUI({
    district_list <- districtInput()
    checkboxGroupInput("var2", label="Select Districts", choices=district_list)
 })
#   output$district <- renderText({
#     print(districtInput())
#   })
  #output$map <- renderPlot({
    #data<- switch(input$var,
    #    "Percent White" = counties$white,
    #    "Percent Black" = counties$black,
    #    "Percent Hispanic" = counties$hispanic,
    #    "Percent Asian" = counties$asian)
    #color <- switch(input$var, 
    #                "Percent White" = "darkgreen",
    #                "Percent Black" = "black",
    #                "Percent Hispanic" = "darkorange",
    #                "Percent Asian" = "darkviolet")
    #legend <- switch(input$var, 
    #                 "Percent White" = "% White",
    #                 "Percent Black" = "% Black",
    #                 "Percent Hispanic" = "% Hispanic",
    #                 "Percent Asian" = "% Asian")
    #province_map(province, districts, centroids, fill, size = input$slider)
  #})
})