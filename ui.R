##########################
# About & Team Dashboard              
# by Yue Lyu and Kehe Zhang                   
# ui.R file    



##########################
# library packages  


library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinybusy)
library(shinyalert)
library(shinythemes)
library(shinyjs)
library(shinyBS)



# set_thin_PROJ6_warnings(TRUE)

# Define UI for the application
shinyUI(
    fluidPage(
        
        useShinydashboard(),
        navbarPage("P2P", 
                   theme = "style/style.css",
                   footer = includeHTML("footer.html"),
                   fluid = TRUE, 
                   collapsible = TRUE,
                   header = tagList( useShinydashboard() ),

                   
                   
                   tabPanel("About", fluid = TRUE, icon = icon("info-circle"),
                            includeHTML("about.html"),
                            shinyjs::useShinyjs(),
                            tags$script(src = "plugins/scripts.js"),


                            
                            
                            fluidRow(
                              column(11,

                                     
                              )


                            )
                   ),
                   
                   
                   
                   
                   tabPanel("MA Mortality", fluid = TRUE, icon = icon("map-marked-alt"),
                            titlePanel("ZCTA level fatal opioid overdose rate in Massachusetts (MA)"),
                            tags$br(),
                            tags$h3("Interactive map with search bar"),
                            fluidRow(tags$img(height = 2, width = 2200, src = 'black_line.png')),
                            tags$h4("The interactive map has a search bar on the top left. The map can zoom into a Zip Code Tabulated Area (ZCTA) by entering a 5-digit Zip Code number, and the popup information 
                            includes total population, population aged 20 and greater, and death rate (in quintiles Q1- Q5, with Q5 the highest) in year 2010, 2015 and 2019.  
                            The plot on the right side compares the state average death rate and the selected Zip Code level death rate (in quintiles) by year."),
                            
                            # Show the interactive map with search bar
                            mainPanel(
                                fluidRow(
                                    splitLayout(cellWidths = c("100%", "90%"), 
                                                leafletOutput("Map",height=800), 
                                                column(plotOutput("Plot1", height=400), plotOutput("Plot2", height=400), width=5),
                                    )
                                )
                            )
                            
                            ),
                   

                   
                   tabPanel("Team", fluid = TRUE, icon = icon("user"),
                     includeHTML("team.html"),
                     tags$head(
                       tags$link(rel = "stylesheet",
                                 type = "text/css",
                                 href = "plugins/carousel.css"),
                       tags$script(src = "plugins/holder.js")
                       ),
                     tags$style(type="text/css",
                                ".shiny-output-error { visibility: hidden; }",
                                ".shiny-output-error:before { visibility: hidden; }"
                                )
                   
                     
                     
                     
                   )
                   

                   
                   

                   
                   
                   )
        )
)
