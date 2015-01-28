#server.R

source("helpers.R")

library(ggplot2)
library(rgdal)
library(RCurl)
library(gpclib)
library(maptools)

gpclibPermit()

national.spdf <- readShapeSpatial("data/afg_admbnd_adm0_pol.shp")
country.adm2.spdf <- readShapeSpatial("data/afg_admbnd_adm3_pol.shp")

country.adm1.df <- fortify(country.adm2.spdf, region = "PROV_NA_EN")

# Get names and id numbers corresponding to administrative areas
country.adm2.centroids.df <- data.frame(long = coordinates(country.adm2.spdf)[, 1], 
                                           lat = coordinates(country.adm2.spdf)[, 2]) 

country.adm2.centroids.df[, 'DIST_CODE'] <- country.adm2.spdf@data[,'DIST_CODE']
country.adm2.centroids.df[, 'DIST_NA_EN'] <- country.adm2.spdf@data[,'DIST_NA_EN']
country.adm2.centroids.df[, 'PROV_NA_EN'] <- country.adm2.spdf@data[,'PROV_NA_EN']

toplot0 <- fortify(national.spdf, region = "NAT_NA_ENG")

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
    province_list <- levels(as.factor(country.adm2.spdf@data[,'PROV_NA_EN']))
    selectInput("var1", "Select a Province", choices=province_list, selected=province_list[1], selectize = FALSE,multiple = TRUE)
  })
  
  output$district <- renderUI({
    district_list <- districtInput()
    checkboxGroupInput("var2", label="Select Districts", choices=district_list)
 })

   output$map <- renderPlot({
    toplot1 = plot1Input()
    if (length(input$var2) <= 0) {
      province_map(all=toplot0,toplot1, country = input$type, fill_prov = input$fill_prov)
    } else {
      toplot2 = plot2Input()
      centroids = centroidInput()
      district_map(all=toplot0,toplot1, toplot2, centroids, fill_prov = input$fill_prov,fill = input$fill, size = input$slider, country = input$type)
    }
  })
 output$downloadMap <- downloadHandler(
   filename <- "mapWebDownload.png",
   content = function(file) {
     device <- function(..., width, height) grDevices::png(..., width = 4, height = 4, res = 300, units = "in")
     ggsave(file, device=device)
   }
 )
})