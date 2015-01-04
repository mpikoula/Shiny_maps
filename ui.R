# ui.R

shinyUI(fluidPage(
  titlePanel("Administrative Maps"),
  sidebarLayout(
    sidebarPanel(
      fluidRow(
      helpText("Highlight province maps according to specified districts")
      ),
      fluidRow(
        uiOutput("province"), uiOutput("district"), downloadButton('downloadMap', 'Download Map'))
    ),
    mainPanel(
      fluidRow(
        div("Beta version. Expires 07 Dec 2015", style = "color:red")
      ),
      fluidRow(
      checkboxInput("type", label = "Country-wide Map", value=FALSE),
      selectInput("fill", "Colour", choices=list("red", "blue", "green", "yellow", "violet", "grey", "cyan"), selectize = FALSE),
      sliderInput("slider", 
                  label="Select district name text size",
                  min = 1, max = 20, value = 3),
      plotOutput("map")
      )
      )
    )
))
    