# ui.R

shinyUI(fluidPage(
  titlePanel("Administrative Maps"),
  sidebarLayout(
    sidebarPanel(
      fluidRow(
      helpText("Highlight province maps according to specified districts")
      ),
      fluidRow(
        uiOutput("province"), uiOutput("district")),
      fluidRow(
      sliderInput("slider", 
                label="Select district name text size",
                min = 1, max = 20, value = 3)
      )),
    mainPanel(
      fluidRow(
      checkboxInput("type", label = "Country-wide Map", value=TRUE),
      selectInput("fill", "Colour", choices=list("red", "blue", "green", "yellow", "violet", "grey", "cyan"), selectize = FALSE)
      #plotOutput("map")
      )
      )
    )
))
    