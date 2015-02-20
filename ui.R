
shinyUI(pageWithSidebar(
  headerPanel("Generate Pseudo-Random Numbers From Text"),
  sidebarPanel(
    p('Enter text to generate numbers. (limit=50,000 characters)'),
    tags$textarea(id="foo", rows=15, cols=40, "Paste or write some text here. \nYou could just copy & paste the text on the right."),
    checkboxInput('showNums', 'Show Generated Numbers', FALSE),
    p('(Numbers will be at the bottom)'),
    HTML('<hr>'),
    HTML('<br>'),
    HTML('<br>'),
    HTML('App by: <b>Thomaz L Santana</b>'),
    p('www.thomaz.me'),
    HTML('<br>'),
    p('Source Code'),
    p('github.com/Wikilicious/R-Shiny-Random-Numbers-From-Text')

  ),
  mainPanel(
    tabsetPanel(
    # MAIN TAB
    tabPanel('Main',
    p("Generating a reproducible random sequence of numbers (0-9) from text is quite complicated. The main problem is that letters in English text are not uniformly distributed e.g. the letter ‘e’ is way more common than the letter ‘z’ and we want a flat distribution. First, create a dictionary that maps a character to a number i.e. a=0, b=1, c=2, d=3, e=4, f=5, g=6, h=7, i=8, j=9, k=0, etc... Then, create a counter that increments by one every time. Finally, the complete algorithm is: Number = (Dictionary[letter] + counter) % 10"),
    HTML('<br>'),
    plotOutput('freqHist'),
    
    uiOutput("stats"),
    HTML('<br>'),
    p(HTML('Interpreting the results: A reduced chi-squared (&chi;<sup>2</sup>/df) of about 1 is ideal, greater than ~2 is extremely bad, and less than ~0.25 is suspicious (possibly forged/manicured data.) The p-value is the percentage of the time you can expect &chi;<sup>2</sup> to as large or larger. Loosely speaking, you could think of the p-value as the probability the distribution was created by a truly random process.  ')),
    HTML('<br>'),
    HTML('<hr>'),
    plotOutput('gapHist'),
    HTML('<br>'),
    HTML('<hr>'),
    textOutput("randNums"),
    HTML('<hr>')
      ), 
    # Close main tab
    # open new tab
    tabPanel("Compair R's Random Numbers", 
             HTML('<br>'),
             p("Uses sample(0:9, nchar(textInput), replace=T) i.e. generates a random number for every charecter in the text. Note: This is not generating random numbers from the text. It is just taking the length of the text and generating that many numbers."),
             HTML('<br>'),
             plotOutput('rfreqHist'),
             uiOutput("rstats"),
             HTML('<br>'),
             p(HTML('Interpreting the results: A reduced chi-squared (&chi;<sup>2</sup>/df) of about 1 is ideal, greater than ~2 is extremely bad, and less than ~0.25 is suspicious (possibly forged/manicured data.) The p-value is the percentage of the time you can expect &chi;<sup>2</sup> to as large or larger. Loosely speaking, you could think of the p-value as the probability the distribution was created by a truly random process.  ')),
             HTML('<br>'),
             HTML('<hr>'),
             plotOutput('rgapHist'),
             HTML('<br>'),
             HTML('<hr>')
             )
    # close tab
    # close tabset
    )
  )
))