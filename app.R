library(maps)
library(mapproj)
source("helpers.R")

counties <- readRDS("data/counties.rds")
# percent_map(counties$black, color = "brown", legend.title = "% Black", max = 100, min = 0)


# User interface ----
ui <- fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with information from the 2010 US Census."),
      
      selectInput("var", label = "Choose a variable to display",
                  choices = c("Percent White", "Percent Black",
                              "Percent Asian", "Percent Hispanic"),
                  selected = "Percent White"),
      sliderInput("range", label = "Range of interest:",
                  min = 0, max = 100, value = c(0,100))
      
    ),
    mainPanel(plotOutput("map"))
  )
)

# Server logic ----
server <- function(input, output) {
  output$map <- renderPlot({
    data <- switch(input$var, 
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)
    color <- switch(input$var,
                    "Percent White" = "darkgreen",
                    "Percent Hispanic" = "red",
                    "Percent Asian" = "yellow",
                    "Percent Black" = "brown")
    title <- switch(input$var,
                    "Percent White" = "% White",
                    "Percent Hispanic" = "% Hispanic",
                    "Percent Asian" = "% Asian",
                    "Percent Black" = "% Black")
    
    percent_map(data, color = color, legend.title = title,max = input$range[2], min = input$range[1])
  })
}

# Run app ----
shinyApp(ui, server)
