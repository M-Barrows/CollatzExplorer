library(shiny)
library(visNetwork)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(plotly)
library(shinythemes)

shinyUI(
  navbarPage( "Collatz Exploration", theme = shinytheme("united"),
    tabPanel("Home",
      column(3,
        fluidRow(
          HTML('<p>The <a href="https://en.wikipedia.org/wiki/Collatz_conjecture" target="_blank">Collatz Conjecture</a>
               is a mathematical conjecture that states any positive integer can be reduced to 1 by repeatedly
               performing one of two operations. 
                 <ul>
                 <li>If Even: Divide the value by 2 </li>
                 <li>If Odd: Multiply the value by 3 and add 1 </li>
                 </ul>
               After the operation is performed, the value is reevaluated and the appropriate action taken. 
               </p>
               
               <p>
               This application, inspired by a <a href = "https://www.youtube.com/watch?v=EYLWxwo1Ed8" target="_blank">
               Coding Train video</a>, is designed to allow users to experiment with 
               this conjecture and visualize the resulting paths in various ways.
               </p>
               
               <p>
                On this page is an example of the last 13 steps that numbers 1-100 take before reaching a value of 1.
                You can use the "Playground" tab above to adjust various settings and see how they change the shape of the visuals.
               </p>')
        )
      ),
      column(9,
        visNetworkOutput("networkGraphHome",height = '90vh',width = '70vw'))
      ),
    tabPanel("Playground",
             column(6,
                    fluidRow(
                      column(5,
                             numericInput("iterations",
                                          "Numbers to calculate Collatz Length (1:n)",
                                          value = 100,
                                          min = 2,
                                          max = 10000,
                                          step = 10)
                             ),
                      column(5,
                             sliderInput("maxTreeDepth",
                                         "Max Tree Depth",
                                         value = 15,
                                         min = 1,
                                         max = 100,
                                         step = 1)
                             )
                      
                    ),
                    fluidRow(
                      column(5,
                             selectInput("direction",
                                         "Graph Direction",
                                         choices = c('UD','DU','LR','RL'),
                                         selected = c('UD'),
                                         multiple = F
                             )
                             ),
                      column(5,
                             selectInput("sort",
                                         "Graph Sort",
                                         choices = c('directed','hubsize'),
                                         selected = c('directed'),
                                         multiple = F
                             )
                             )
                      ),
                    fluidRow(
                      visNetworkOutput("networkGraph",height = '70vh'))
                    
             ),
             column(6,
                    fluidRow(
                        plotlyOutput("maxValuePlot",height = '45vh',width = '45vw')),
                    fluidRow(
                        plotlyOutput("chainLengthPlot",height = '45vh',width='45vw')
                    )
             )
    )
    )
        
    
  )

