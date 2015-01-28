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
        div("Trial version. Expires 31 Jan 2015", style = "color:red")
      ),
      fluidRow(
      checkboxInput("type", label = "Country-wide Map", value=FALSE),
      selectInput("fill_prov", "Province Colour", choices=list("red", "blue", "green", "yellow", "violet", "grey", "cyan"), selectize = FALSE),
      selectInput("fill", "District Colour", choices=list("red", "blue", "green", "yellow", "violet", "grey", "cyan"), selectize = FALSE),
      sliderInput("slider", 
                  label="Select district name text size",
                  min = 1, max = 20, value = 3),
      plotOutput("map")
      )
      )
    )
))
    