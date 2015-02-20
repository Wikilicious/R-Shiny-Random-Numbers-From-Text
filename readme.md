# Generate Pseudo-Random Numbers From Text

Generating a reproducible random sequence of numbers (0-9) from text is quite complicated. The main problem is that letters in English text are not uniformly distributed e.g. the letter e is way more common than the letter z and we want a flat distribution. First, create a dictionary that maps a character to a number i.e. a=0, b=1, c=2, d=3, e=4, f=5, g=6, h=7, i=8, j=9, k=0, etc... Then, create a counter that increments by one every time. Finally, the complete algorithm is: Number = (Dictionary[letter] + counter) % 10
This is an R Shiny App
The app is running here: [https://delicious.shinyapps.io/Random_Numbers_From_Text/](https://delicious.shinyapps.io/Random_Numbers_From_Text/)