library(tidyverse)
library(data.table)

setwd("C:\\Users\\sheng\\OneDrive\\CU Second Semester\\Applied Data Science\\Spring2019-Proj2-grp9")

test_tbl <- read_csv(".\\data\\2018_Yellow_Taxi_Trip_Data_test.csv")
test_tbl <- read_csv(".\\data\\2018_Yellow_Taxi_Trip_Data.csv", n_max = 10000000)

str(test_tbl)

test_tbl_plot <- test_tbl %>% 
  group_by(PULocationID, DOLocationID) %>%
  summarise(count = n()) %>%
  ungroup() %>%
  group_by(PULocationID) %>%
  top_n(.,5) %>%
  arrange(PULocationID) %>%
  filter(count>1)

ggplot(test_tbl_plot) +
  geom_point(aes(x=PULocationID, y=DOLocationID, size = count))

ggplot(test_tbl) +
  geom_hex(aes(x=PULocationID, y=DOLocationID)) + 
  scale_fill_gradient(low = "#cccccc", high = "#09005F")

selected <- c("tpep_pickup_datetime", "tpep_dropoff_datetime", "trip_distance", 
              "PULocationID", "DOLocationID", "total_amount")
data <- fread(".\\data\\2018_Yellow_Taxi_Trip_Data.csv", select = selected, nrows = 10000000)
ID <- fread(".\\data\\2018_Yellow_Taxi_Trip_Data.csv", select = "DOLocationID")
dummy <- data[, .(count=.N), 
              by=.(PULocationID, DOLocationID)][,.(DOLocationID, top_3 = sort(count,decreasing = T)), 
                                                              by=.(PULocationID)][,.(DOLocationID=DOLocationID[1:3], top_3 = top_3[1:3]), 
                                                                                  by=.(PULocationID)]


dummy1 <- data[, count:=.N,by=.(PULocationID, DOLocationID)][, order:=sort(-count),by=.(PULocationID, DOLocationID)][1:3]

time <- data[tpep_dropoff_datetime %like% ".+ 05:.+AM"]
ggplot(dummy) +
  geom_point(aes(x=PULocationID, y=DOLocationID, size = top_3))

ggplot(data) +
  geom_hex(aes(x=PULocationID, y=DOLocationID)) + 
  scale_fill_gradient(low = "#cccccc", high = "#09005F")
        
