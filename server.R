library(shiny)
library(visNetwork)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(plotly)

`%notin%` <<- Negate(`%in%`)
# networkPath <- data.frame(currentVal = 1,nextVal = 1,length=1)

getColatzLength <- function(x){
    count <- 0
    while(x > 1 ){
        count <- count + 1
        if(x %% 2 == 0){
            x <- x/2
        }
        else{
            x <- x*3 +1
        }
    }
    return(count)
}

getColatzMax <- function(x){
    max <- x
    while(x > 1 ){
        if(x > max){max <- x}
        if(x %% 2 == 0){
            x <- x/2
        }
        else{
            x <- x*3 +1
        }
    }
    return(max)
}

createColatzMap <- function(x){
    path <- data.frame(currentVal = 1,nextVal = 1,length=1,max=1)
    for (i in 1:x){
        while(i > 1 && i %notin% path$currentVal){
            if(i %% 2 == 0){
                path<-rbind(path,c(i,i/2,getColatzLength(i),getColatzMax(i)))
                i <- i/2
            }
            else{
                path<-rbind(path,c(i,i*3+1,getColatzLength(i),getColatzMax(i)))
                i <- i*3 +1
            }
        }
    }
    return(path)
}
networkPathHome <- createColatzMap(150)

shinyServer(function(input, output, session) {
    
    networkPath <- reactive({createColatzMap(input$iterations)})
    
    observe({
        val <- input$iterations
        updateSliderInput(session,"maxTreeDepth",
                          value = 20,
                                    min = 2, 
                                    max = max(networkPath()$length))
    })

    output$networkGraph <- renderVisNetwork({
        nodes <- data.frame(id = networkPath()[networkPath()$length<=input$maxTreeDepth,"currentVal"], label = networkPath()[networkPath()$length<=input$maxTreeDepth,"currentVal"])
        edges <- networkPath() %>% filter(length <= input$maxTreeDepth) %>% select(from = currentVal, to = nextVal)
        visNetwork(nodes,edges) %>%
            visHierarchicalLayout(direction = input$direction
                                  , sortMethod = input$sort
                                  , nodeSpacing = 500)
    })
    output$networkGraphHome <- renderVisNetwork({
        nodes <- data.frame(id = networkPathHome[networkPathHome$length<=13,"currentVal"], label = networkPathHome[networkPathHome$length<=13,"currentVal"])
        edges <- networkPathHome %>% filter(length <= 13) %>% select(from = currentVal, to = nextVal)
        visNetwork(nodes,edges) %>%
            visHierarchicalLayout(direction = "UD"
                                  , sortMethod = "directed"
                                  , nodeSpacing = 500)
    })
    output$maxValuePlot <- renderPlotly({
        p<- networkPath() %>%
            select(`Starting Value` = currentVal, Max = max) %>%
        ggplot(aes(`Starting Value`,Max)) + 
            geom_point(alpha=0.2 ) + 
            ylab("Maximum Value") + 
            theme(
                plot.title = element_blank(),
                axis.title.x = element_blank())+ 
            theme_hc()+ 
            scale_colour_hc()
            
        ggplotly(p)
    })
    output$chainLengthPlot <- renderPlotly({
        p <-networkPath() %>%
            select(`Starting Value` = currentVal, `Chain Length` = length) %>%
            ggplot(aes(`Starting Value`,`Chain Length`)) + 
            geom_point(alpha=0.2) + 
            ylab("Chain Length") + xlab("Starting Value") + 
            theme(plot.title = element_blank()) +
            theme_hc()+ 
            scale_colour_hc()
        
        ggplotly(p)
            
    })
})

