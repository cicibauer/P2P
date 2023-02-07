##########################
# About & Team Dashboard              
# by Yue Lyu                     
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
                            titlePanel("MA Mortality"),
                            fluidRow(
                                
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
