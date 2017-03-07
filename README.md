# The effectiveness package
An `R` package for plotting the effectiveness landscape of mutualisms adding isolines of equal effectiveness values.

![Effectiveness](http://pedroj.github.io/effectiveness/images/effectiveness_prunus.png)


Usage:
```r
devtools::install_github("pedroj/effectiveness_pckg")
library(effect.lndscp)
# PJ example. Based on a dataset of Prunus mahaleb frugivores.
# Get the data from my GitHub repository.
link = "https://raw.githubusercontent.com/pedroj/effectiveness/master/data.txt"
file = "data.txt"
if(!file.exists(file)) download(link, file, mode = "wb")
M <- read.table(file, sep = "\t", dec = ".", 
                header = TRUE, na.strings="NA")
 
# Run the function.
effectiveness(M$visits, M$eff_per_vis, M$group, M$animal, 10, 
      myxlab= "No. visits/10h", 
      myylab="Effectiveness/vis (No. fruits handled)")
```

Effectiveness landscapes are the two-dimensional representation of the possible combinations of the quantity and the quality of mutualistic services (seed dispersal, pollination) and with elevational contours representing isoclines of effectiveness. These representations can be 2D bivariate plots of multiplicative effects of any of the seed dispersal (SDE) or pollination (PE) effectiveness components. This is a repository of code used to produce these plots.

For additional details please visit the web page [here](http://pedroj.github.com/effectiveness/).
