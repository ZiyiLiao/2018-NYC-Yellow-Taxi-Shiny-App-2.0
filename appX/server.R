library(rgeos)
library(sp)
library(rgdal)
library(leaflet)
library(leaflet.extras)
library(shiny)
library(ggplot2)
library(dplyr)
library(data.table)
library(RColorBrewer)
library(sp)
library(htmltools)

setwd('../')

# graphical parameters

# load data
Shape <- readOGR('data/taxi_zones', 'taxi_zones') %>% 
  spTransform(CRS("+init=epsg:4326"))

Count <- readRDS('output/count_separated.rds')
Fpd <- readRDS('output/fpd_separated.rds')
Tips <- readRDS('output/tip.rds')
Dropoff <- readRDS('output/dropoff_frequency.rds')

# Server
server <- function(input,output, session){
  
  output$map <- renderLeaflet({
    
    # calculate intermediate data
    if (input$days == "All Day"){
      count_temp = Count %>% apply(c(1,2), sum)
      fpd_temp = Fpd %>% apply(c(1,2), mean, na.rm = T)
    }else{
      count_temp = Count[ , , (input$days == "Business Day") + 1]
      fpd_temp = Fpd[ , , (input$days == "Business Day") + 1]
    }

    if (!input$showhr){
      Shape@data$count = count_temp %>% apply(1, sum)
      Shape@data$fpd = fpd_temp %>% apply(1, mean, na.rm = T)
    }else{
      Shape@data$count = count_temp[, input$hr_adjust+1]
      Shape@data$fpd = fpd_temp[, input$hr_adjust+1]
      dropoff_temp = Dropoff %>% filter(busi == (input$days == "Business Day"),
                                        hour == input$hr_adjust + 1)
    }
    
    
    
    Background <- leaflet() %>% 
      addSearchOSM() %>%
      addResetMapButton() %>%
      addTiles(group = "OSM") %>%
      addProviderTiles("CartoDB", group="CartoDB")  %>%
      setView(lat=40.7128, lng=-74.0059, zoom=12) %>%
      addLayersControl(baseGroups=c("CartoDB", "OSM"))
    
    count_pal <- colorNumeric("YlOrRd", domain = Shape@data$count)
    
    Background %>%
      addPolygons(data=Shape, weight=1, fillOpacity = .5,
                  color = ~count_pal(count), 
                  label = ~paste0("Number of counts: ", count),
                  highlightOptions = highlightOptions(weight = 3,
                                              color = "white", bringToFront = TRUE))
  })
  
}