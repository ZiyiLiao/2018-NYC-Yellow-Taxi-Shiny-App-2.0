# Project 2: Shiny App Development Version 2.0

### Output folder

The output directory contains analysis output, processed datasets, logs, or other processed things. Here, it contains processed data of 
pick-up numbers, tip percentage and dropoff information.

1. count_separated.rds: contains pick-up numbers information; 3 dimensional arry; the dimension of this data frame is 1:263 taxi zones, 1:24 hours in a day, and 1:2 refer to whether it is a business day or not. 

2. tips_separated.rds: contains tip percentage information; 3 dimensional arry;  the dimension of this data frame is 1:263 taxi zones, 1:24 hours in a day, and 1:2 refer to whether it is a business day or not. 

3. dropoff_frequency: large dataframe; variables: busi(whether it is a business day), hour(which hour during the day), PULocationID(pick-up location), DOLocationID(drop-off location), n (number of dropoffs in that drop-off location), freq (starting at pick-up location, what percentage of drop-off happens in that drop-off location conditioned on hour and busi).

4: shape.rds: contains taxi zone information. 
