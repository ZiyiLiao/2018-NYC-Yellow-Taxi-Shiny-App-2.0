library(leaflet)
  navbarPage("NYC Yellow Taxi", id = "navigation",
             tabPanel("Statistical Map",
                      div(class="outer",
                          
                          tags$head(
                            #change the layout formats
                            includeCSS("styles.css"),
                            includeScript("gomap.js")
                          ),
                          
                          leafletOutput("map", width="100%", height="100%"),
                          
                          fixedPanel(id = "controls", class = "panel panel-default", 
                                     draggable = T, top = 60, right = 5,
                                     width = 160, height = 130,
                                     
                                     radioButtons("layers", label = h4("Layers"),
                                                  choices = list("Pick Up Numbers" = "count", "Tips" = "tips"), 
                                                  selected = "count")
                          ),
                          fixedPanel(id = "controls", class = "panel panel-default",
                                     draggable = TRUE, top = 60, left = 40,
                                     width = 330, height = "auto",
                                     h3("Panel"),
                                     
                                     
                                     selectInput("days", h4("Days"), c("All Day", "Business Day", "Non-business Day"),selected = "All Day"),
                                     
                                     checkboxInput(inputId = "showhr",
                                                   label = strong("Show hours"),
                                                   value = FALSE),
                                     
                                     conditionalPanel(condition = "input.showhr == false"
                                                      
                                     ),
                                     
                                     
                                     conditionalPanel(condition = "input.showhr == true",
                                                      sliderInput(inputId = "hr_adjust",
                                                                  label = "Choose the time of the day:",
                                                                  min = 0, max = 23, value = NULL, step = 1)
                                     ),
                                     plotOutput("districttimeplot", height = 180),
                                     helpText(   a("Instruction",
                                                   href="http://htmlpreview.github.io/?https://github.com/TZstatsADS/Spring2019-Proj2-grp9/blob/master/doc/instruction.html")
                                     )
                                     
                          )
                      )
             ),
             
             tabPanel("Interactive Map",
                      div(class="outer",
                          
                          tags$head(
                            #change the layout formats
                            includeCSS("styles.css"),
                            includeScript("gomap.js")
                          ),
                          
                          leafletOutput("Imap", width="100%", height="100%"),
                          
                          fixedPanel(id = "controls", class = "panel panel-default", 
                                     draggable = T, top = 60, right = 5,
                                     width = 160, height = 130,
                                     
                                     radioButtons("Ilayers", label = h4("Layers"),
                                                  choices = list("Pick Up Numbers" = "count"), 
                                                  selected = "count")
                          ),
                          fixedPanel(id = "controls", class = "panel panel-default",
                                     draggable = TRUE, top = 60, left = 40,
                                     width = 330, height = "auto",
                                     h3("Panel"),
                                     
                                     
                                     selectInput("Idays", h4("Days"), c("Business Day", "Non-business Day"),selected = "Business Day"),
                                     
                                     checkboxInput(inputId = "Ishowhr",
                                                   label = strong("Show hours"),
                                                   value = FALSE),
                                     
                                     conditionalPanel(condition = "input.Ishowhr == false"
                                                      
                                     ),
                                     
                                     
                                     conditionalPanel(condition = "input.Ishowhr == true",
                                                      sliderInput(inputId = "Ihr_adjust",
                                                                  label = "Choose the time of the day:",
                                                                  min = 0, max = 23, value = NULL, step = 1)

  
                                     )
                                     
                          )
                 )
         )
)