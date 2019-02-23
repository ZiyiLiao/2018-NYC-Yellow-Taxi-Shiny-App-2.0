library(sp)
library(rgdal)

library(leaflet)
library(leaflet.extras)
library(htmltools)

library(tidyverse)
library(RColorBrewer)

Dropoff <- readRDS(".\\output\\dropoff_frequency.rds")
Count <- readRDS(".\\output\\count_separated.rds")
Fpd <- readRDS(".\\output\\fpd_separated.rds")
Tips <- readRDS(".\\output\\tip.rds")

count <- Count %>% as_tibble() %>% 
  mutate(PULocationID = as.integer(PULocationID)) %>% 
  group_by(PULocationID) %>%
  summarise(PUCount = sum(n))

Shape <- readRDS('.\\output\\shape.rds') %>% 
  spTransform(CRS("+init=epsg:4326")) %>% merge(., count, by.x="LocationID", by.y = "PULocationID")



Background <- leaflet() %>% 
  addSearchOSM() %>%
  addResetMapButton() %>%
  addTiles(group = "OSM") %>%
  addProviderTiles("Esri", group="Ersi")  %>%
  setView(lat=40.7128, lng=-74.0059, zoom=10) %>%
  addLayersControl(baseGroups=c("OSM", "Esri"))

PUCount_pal <- colorNumeric("YlOrRd", domain = log(Shape@data$PUCount+1))

Background %>% addPolygons(data=Shape, weight=1, fillOpacity = .5, 
                           color = ~PUCount_pal(log(PUCount)),  group = "Temp", 
                           label = ~paste0("Number of Count: ", PUCount),
                           highlightOptions = highlightOptions(weight = 3, color = "white", bringToFront = TRUE))

