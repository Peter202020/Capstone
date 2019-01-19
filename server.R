#load necessary packages
suppressPackageStartupMessages(c(library(shinythemes),
                                 library(shiny),
                                 library(tm),
                                 library(stringr),
                                 library(markdown),
                                 library(stylo)))

# read text files
quadGramFile <- readRDS(file = "data4.RData")
triGramFile <- readRDS(file = "data3.RData")
biGramFile <- readRDS(file = "data2.RData")

# clean input simultaneously as text is being entered
transformInput <- function(typedtext) {
  tempTxt <- tolower(typedtext)
  tempTxt <- removeNumbers(tempTxt)
  tempTxt <- removePunctuation(tempTxt)
    tempTxt <- str_replace_all(tempTxt, "[^[:alnum:]]", " ")
  tempTxt <- stripWhitespace(tempTxt)
  
  tempTxt <- txt.to.words.ext(tempTxt,
                              language = "English.all",
                              preserve.case = TRUE)
  
  return(tempTxt)
}

# funtion that predicts a next word
predictedWord <- function(numWords, textInput) {
  if (numWords >= 3) {
    textInput <- textInput[(numWords - 2):numWords]
  }
  else if (numWords == 2) {
    textInput <- c(NA, textInput)
  }
  else {
    textInput <- c(NA, NA, textInput)
  }
  
  wPred <-
    as.character(quadGramFile[quadGramFile$unigram == textInput[1] &
                                quadGramFile$bigram  == textInput[2] &
                                quadGramFile$trigram == textInput[3], ][1, ]$quadgram)
  
  if (is.na(wPred)) {
    wPred <-
      as.character(triGramFile[triGramFile$unigram == textInput[2] &
                                 triGramFile$bigram == textInput[3], ][1, ]$trigram)
    
    if (is.na(wPred)) {
      wPred <-
        as.character(biGramFile[biGramFile$unigram == textInput[3], ][1, ]$bigram)
    }
  }
  print(wPred)
  
}


# shinyServer to set outputs
shinyServer(function(input, output) {
  wordPrediction <- reactive({
    typedtext <- input$typedtext
    textInput <- transformInput(typedtext)
    numWords <- length(textInput)
    wordPrediction <- predictedWord(numWords, textInput)
  })
  
  output$predictedWord <- renderPrint(wordPrediction())
  output$enteredtext <-
    renderText({
      input$typedtext
    }, quoted = FALSE)
})