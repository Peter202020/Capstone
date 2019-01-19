

suppressPackageStartupMessages(c(library(tm),
                                 library(stringr),
                                 library(shinythemes),
                                 library(markdown),
                                 library(shiny),
                                 library(stylo)))

shinyUI(fluidPage(titlePanel(h2("Coursera - Capstone roject")),
        
        
        sidebarPanel(h3("Enter the word(s)"),
          textInput("typedtext","","")),
        
        
        
        mainPanel(h3("Written so far:"),
          textOutput("enteredtext"),
          (h3("Predicted word:")),
          textOutput("predictedWord"))
        

        
                  
  
  
)
        
        
        
        )
  