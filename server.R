gapTest <- function (randNums) {
  gapCount <- c(0)
  gap <- 1
  firstZ <- FALSE
  for (num in randNums) {
    if (num == 0) {
      if (firstZ) {
        if (is.na(gapCount[gap])) {
          gapCount[gap] <- 1
        }
        else {
          gapCount[gap] <- gapCount[gap] + 1
        }
      }
      gap <- 1
      firstZ <- TRUE
    }
    else {
      gap <- gap + 1
    }
  }
  return(gapCount)
}


lettersToNumbers <- function(text) {
  map <<- new.env()
  chars <- c(letters, LETTERS, 0:9, '!','@','#','$','%','^','&','*','?','.',',',' ','+','-')
  for (i in 0:(length(chars) - 1)) {
    num <- i %% 10
    index <- i + 1
    map[[chars[index]]] <- num
  }
  nums <- c()
  text <- gsub('()=', '', text)
  counter <<- 0
  i <- 1
  for (letter in strsplit(substr(text, 1, 50000), '')[[1]]) {
    mapNum <- map[[letter]]
    if (!is.null(mapNum)) {
      num <- (mapNum + counter) %% 10
      counter <<- counter + 1
      nums[i] <- num
      i <- i + 1
    }
  }
  if (length(nums) > 0) {return(nums)}
  0
}


makeNums <- function(text='') {
  nums <- c()
  cacheText <- ''
  setText <- function(checkText) {
    if (checkText != cacheText) {
      cacheText <<- checkText
      nums <<- lettersToNumbers(cacheText)
    }
  }
  getNums <- function() nums
  list(setText=setText, getNums=getNums)
}


shinyServer(
  function(input, output) {
    numsCache <- makeNums()
    output$randNums <- renderText({ 
      if (!input$showNums) return()
      numsCache$setText(input$foo)
      nums <- numsCache$getNums()
      toString(nums)
    })
    output$freqHist <- renderPlot({
      numsCache$setText(input$foo)
      nums <- numsCache$getNums()
      hist(nums, xlab='Number', ylab='Frequency', col='lightblue',main='Frequency Histogram', breaks=0:10, 
           right=F, sub='Distribution of Digits (Red line is the expected value)')
      abline(a=length(nums)/10, b=0, col='red')
    })
    output$gapHist <- renderPlot({
      numsCache$setText(input$foo)
      nums <- numsCache$getNums()
      gapFx <- function(x) {(0.1*0.9^x) * length(nums) / 10}
      x <- seq(0, 30, 1)
      gapTheo <- lapply(x, gapFx) 
      gapFreq <- gapTest(nums)
      bins <- length(gapFreq)
      barplot(gapFreq, col='lightblue', xlim=c(0,30), main='Histogram of Digits Between Zeros', 
              sub='Gap Test (Red line is the expected value)', xlab='Digits in Between Zeros', ylab='Frequency')
      axis(1, seq(0,bins))
      lines(x, gapTheo, col='red')
    })
    output$stats <- renderUI({
      numsCache$setText(input$foo)
      nums <- numsCache$getNums()
      t <- table(nums)
      if (length(t) == 10 && length(nums) >= 50) {
        chiSq <- chisq.test(t)
        rChSq <- chiSq$statistic / chiSq$parameter
        pv <- chiSq$p.value
        df <- chiSq$parameter
        chi <- chiSq$statistic
        text <- HTML(sprintf('<font size="3">&chi;<sup>2</sup>/df = %.03f, &nbsp; df = %d, &nbsp; &chi;<sup>2</sup> = %.03f, &nbsp; p-value = 
                             %.03f &nbsp; Digits: %d</font>', rChSq, df, chi, chiSq$p.value, length(nums)))          
      }
      else {text <- HTML('<font color="red"> Need more than 50 digits to compute accurate statistics.</font>')}
      return (text)
    })
      # Code for other tab
      output$rfreqHist <- renderPlot({
        set.seed(nchar(input$foo))
        nums <- sample(0:9, nchar(input$foo), replace=T)
        hist(nums, xlab='Number', ylab='Frequency', col='lightblue',main='Frequency Histogram', breaks=0:10, 
             right=F, sub='Distribution of Digits (Red line is the expected value)')
        abline(a=length(nums)/10, b=0, col='red')
      })
      output$rgapHist <- renderPlot({
        set.seed(nchar(input$foo))
        nums <- sample(0:9, nchar(input$foo), replace=T)
        gapFx <- function(x) {(0.1*0.9^x) * length(nums) / 10}
        x <- seq(0, 30, 1)
        gapTheo <- lapply(x, gapFx) 
        gapFreq <- gapTest(nums)
        bins <- length(gapFreq)
        barplot(gapFreq, col='lightblue', xlim=c(0,30), main='Histogram of Digits Between Zeros', 
                sub='Gap Test (Red line is the expected value)', xlab='Digits in Between Zeros', ylab='Frequency')
        axis(1, seq(0,bins))
        lines(x, gapTheo, col='red')
      })
      output$rstats <- renderUI({
        set.seed(nchar(input$foo))
        nums <- sample(0:9, nchar(input$foo), replace=T)
        t <- table(nums)
        if (length(t) == 10 && length(nums) >= 50) {
          chiSq <- chisq.test(t)
          rChSq <- chiSq$statistic / chiSq$parameter
          pv <- chiSq$p.value
          df <- chiSq$parameter
          chi <- chiSq$statistic
          text <- HTML(sprintf('<font size="3">&chi;<sup>2</sup>/df = %.03f, &nbsp; df = %d, &nbsp; &chi;<sup>2</sup> = %.03f, &nbsp; p-value = 
                             %.03f &nbsp; Digits: %d</font>', rChSq, df, chi, chiSq$p.value, length(nums)))          
        }
        else {text <- HTML('<font color="red"> Need more than 50 digits to compute accurate statistics.</font>')}
        return (text)
    })
  }
)


