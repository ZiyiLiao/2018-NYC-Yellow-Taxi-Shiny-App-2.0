# Project 2: Shiny App Development Version 2.0

### Output folder

The output directory contains analysis output, processed datasets, logs, or other processed things. Here, it contains processed data of taxi Counts, Fare per distance, Tips and Pickup and Drop-off information.

1. Count: the dimension of this data frame is 1:263 taxi zones, 1:24 hours in a day, and 1:2 refer to whether it is a business day or not. And then count for the pick up frequency in a certain taxi zone/hour/day.

2.  Fdp (Fare per distance): the dimension of this data frame is also 1:263 taxi zones, 1:24 hours in a day, and 1:2 refer to business/ non-business day. Then count for the fare per mile in a given pick up taxi zone/hour/day. 

3. Tips: the dimension of this data frame is 1:263 taxi zones, and 1:2 refer to whether it is a business day or not. And then calculate the tips percentage  (i.e. tips amount / trip fare ) in a given pick up taxi zone/day.

4.  Dropoff: Distinguished by business/ non-business day and 24 hours, count for the total trips made in a given pick up taxi zone to a given drop off taxi zone.
