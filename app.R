library(shiny)
library(shinydashboard)
library(dplyr)
library(reshape2)
library(ggplot2)
setwd("~/Desktop/raster/shiny/") 
data <-  read.csv("~/Desktop/raster/shiny/base.csv")
colnames(data) <- c('Localidad', '2009', '2010', '2011', '2012', '2013', '2014', '2015', '2016', '2017')
data <- melt(data, id = 'Localidad')
colnames(data) <- c('Localidad', 'year', 'value')
data$Localidad <- as.character(data$Localidad)
data$year <- as.numeric(as.character(data$year))
data$value <- as.numeric(data$value)
localidades <- unique(data$Localidad)
#ggplot(data) + geom_line(aes(year, value, col = Localidad)) + theme(legend.position="none")

ui <- dashboardPage(
  dashboardHeader(title = "CORE DM"),
  dashboardSidebar(
    checkboxGroupInput("checkbox", "Localities to show:",
                                      localidades, selected = localidades[1])),
  dashboardBody(
    fluidRow(
      box(width = 8, plotOutput("plot", height = 250))
      ),
    fluidRow(
      box(width = 8, title = "Controls", 
          sliderInput("slider", "Date range:", min = 2008, max = 2018, value = c(2008, 2018)))
    )
  )
  
)

server <- function(input, output){
  output$plot <-renderPlot({
    ggplot(data[data$Localidad %in% input$checkbox & data$year>= input$slider[1] & data$year <= input$slider[2],], aes(x = year)) + 
      geom_line(aes(y = value, col = Localidad)) + labs(title = "Time series chart", y = "Cases")
  })
}

shinyApp(ui, server)
