library(shiny)
library(dplyr)

library(sp)
library(rgeos)
library(rgdal)

library(leaflet)
library(leaflet.extras)

library(ggplot2)
library(RColorBrewer)



setwd('../')

# graphical parameters
color <- list(color1 = c('#F2D7D5','#D98880', '#CD6155', '#C0392B', '#922B21','#641E16'),
             color2 = c('#e6f5ff','#abdcff', '#70c4ff', '#0087e6', '#005998','#00365d'))

bin <- list(bin1 = c(0,100,1000,10000,100000,1000000,10000000), 
           bin2 = c(0,0.05,0.1,0.15,0.2,0.25,9900))

label <- list(label1 = c("<100","100-1000","1000~10,000","10,000~100,000","100,000~1,000,000","1,000,000~10,000,000"),
             label2 = c("0-0.05","0.05-0.1","0.1-0.15","0.15-0.2","0.2-0.25","0.25+"))

title <- list(t1 = "Pick Up Numbers", 
             t2 = "Tip Percentage")

Background <- leaflet() %>% 
  addSearchOSM() %>%
  addResetMapButton() %>%
  addTiles(group = "OSM") %>%
  addProviderTiles("CartoDB", group="CartoDB")  %>%
  setView(lat=40.7130, lng=-74.0059, zoom=11) %>%
  addLayersControl(baseGroups=c("CartoDB", "OSM"))

# load data
Shape <- readOGR('data/taxi_zones', 'taxi_zones') %>% 
  spTransform(CRS("+init=epsg:4326"))

Count <- readRDS('output/count_separated.rds')
Tips <- readRDS('output/tips_separated.rds')
Dropoff <- readRDS('output/dropoff_frequency.rds')



# Server
shinyServer(function(input, output,session) { 
  
  # save the input variables we want to use in the observe function below
  click <- reactive({
    
    # select the input your want
    days <- input$Idays
    event <- input$Imap_shape_click
    hour <- input$Ihr_adjust
    
    # return the input you want
    return(list(data = event, days = days, hour = hour ))
    
  })
  
  # create statistical map output
  output$map <- renderLeaflet({
    
    # calculate intermediate data
    if (input$days == "All Day"){
      count_temp <- Count %>% apply(c(1,2), sum)
      tips_temp <- Tips %>% apply(c(1,2), mean, na.rm = T)
    }else{
      count_temp <- Count[ , , (input$days == "Business Day") + 1]
      tips_temp <- Tips[ , , (input$days == "Business Day") + 1]
    }

    if (!input$showhr){
      Shape@data$count <- count_temp %>% apply(1, sum)
      Shape@data$tips <- tips_temp %>% apply(1, mean, na.rm = T)
    }else{
      Shape@data$count <- count_temp[, input$hr_adjust+1]
      Shape@data$tips <- tips_temp[, input$hr_adjust+1]
    }
    
    # determine which layer to work with
    if (input$layers == "count"){
      pal1 = colorBin(color[[1]], bins = bin[[1]])
      
      Background %>%
        addPolygons(data=Shape, weight=1, fillOpacity = .5,
                    fillColor = ~pal1(count), 
                    label = ~paste0(zone," , Number of counts: ", count),
                    highlightOptions = highlightOptions(weight = 3,
                                  color = "white", bringToFront = TRUE)) %>%
        addLegend(position = "bottomright",
                  colors = color[[1]],
                  labels = label[[1]],
                  opacity = 0.6,
                  title = title[[1]])
      
    }
    else if (input$layers == "tips"){
      pal2 <- colorBin(color[[2]], bins = bin[[2]])
      
      Background %>%
        addPolygons(data=Shape, weight=1, fillOpacity = .5,
                    fillColor = ~pal2(tips), 
                    label = ~paste0(zone," , Tip Percentage: ", tips),
                    highlightOptions = highlightOptions(weight = 3,
                                              color = "white", bringToFront = TRUE)) %>%
        addLegend(position = "bottomright",
                  colors = color[[2]],
                  labels = label[[2]],
                  opacity = 0.6,
                  title = title[[2]])
      
    }
  
  })
  
  # create interactive map output
  output$Imap <- renderLeaflet({
    # create a basic layer that has no information

    IBackground <- Background %>%
      addPolygons(data=Shape, weight=1, fillOpacity = .5,color = "grey",
                  highlightOptions = highlightOptions(weight = 3,
                                      color = "white", bringToFront = TRUE))
    
  })
  
  # create observe for interactive map based on click information
  observe({
    event <- click()$data
    if (is.null(event))
      return()
    
    days <- click()$days
    hr_adjusted <- click()$hour + 1
    
    # get the ID of the polygon that you click on
    lnglat = data.frame(Longitude = event$lng, Latitude = event$lat)
    coordinates(lnglat) <- ~ Longitude + Latitude
    proj4string(lnglat) <- CRS("+proj=longlat")
    lnglat <- spTransform(lnglat, proj4string(Shape))
    click_info <- over(lnglat, Shape)
    click_ID <- click_info$LocationID
    
    # get the top_3 destination if pick up from the clicked polygon
    top3_info <- Dropoff %>% 
      filter(busi == (days == 'Business Day'), 
             hour == hr_adjusted,
             PULocationID == click_ID) %>% 
      arrange(desc(n)) %>% 
      top_n(3) %>% 
      filter(n > 0)

    print(1)
    # add top3_info to IBackground
    
    leafletProxy("Imap") %>%
      clearGroup(group = "Once Plot") %>%
      addPolygons(data = Shape[Shape$LocationID==top3_info$DOLocationID, ], 
                  weight = 1, fillOpacity = .5,color = "red",
                 highlightOptions = highlightOptions(weight = 3, color = "white", bringToFront = TRUE),
                 group = "Once Plot"
      )
    print(2)
    
  })
  
})