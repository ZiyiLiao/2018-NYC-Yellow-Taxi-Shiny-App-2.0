shinyUI(
  navbarPage("NYC Yellow Taxi", id = "navigation",
             tabPanel("Interactive Map",
                      id = "plot",
                      div(class="outer",
                          
                          tags$head(
                            #change the layout formats
                            includeCSS("styles.css"),
                            includeScript("gomap.js")
                          ),
                          
                          leafletOutput("map", width="100%", height="100%"),
                          
                          fixedPanel(id = "controls", class = "panel panel-default", 
                                     draggable = T, top = 60, left = "auto", right = 5, bottom = "auto",
                                     width = 160, height = 130,
                                     
                                     radioButtons("layers", label = "Layers",
                                                  choices = list("Count Number" = "count", "Fare Per Distance" = "FPD","Tips" = "Tips"), 
                                                  selected = "count")
                          ),
                          fixedPanel(id = "controls", class = "panel panel-default",
                                     draggable = TRUE, top = 60, left = 5, right = "auto", bottom = "auto",
                                     width = 330, height = "auto",
                                     h3("Panel"),
                                     
                                     
                                     selectInput("days", h4("Days"), c("All Day", "Business Day", "Not Business Day"),selected = "All Day"),
                                     
                                     sliderInput(inputId = "hr_adjust", label = h4("Show Hour:"),
                                                 min = 0, max = 23, value = NULL, step = 1
                                                 # ,animate=animationOptions(interval = 500)
                                     )
                                     # ,helpText("Click play button to see dynamic flow data")
                                     ,
                                     
                                     # histogram ?  
                                     plotOutput("districttimeplot", height = 280),
                                     helpText(   a("Analysis",
                                                   href="https://github.com/TZstatsADS/Spr2017-proj2-grp2/blob/master/doc/analysis.html")
                                     )
                          )
                      )
             )
  )
)