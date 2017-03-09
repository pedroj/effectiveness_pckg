# The effectiveness package
An `R` package for plotting the effectiveness landscape of mutualisms adding isolines of equal effectiveness values.

![Effectiveness](http://pedroj.github.io/effectiveness/images/effectiveness_cecropia.png)


Usage:
```r
# Installation.
devtools::install_github("pedroj/effectiveness_pckg")
library(effect.lndscp)

#------------------------------------------------------------------------
# Based on a dataset of Prunus mahaleb frugivores.
# In this example we build the effectiveness landscape just for the 
# quantitative component, plotting its two subcomponents, visitation 
# rate and per-visit effectiveness.
#
data(prunus)
effectiveness(prunus$visits, prunus$eff_per_vis, 
   prunus$group, prunus$animal, 10, 
   myxlab= "No. visits/10h", 
   myylab="Effectiveness/vis (No. fruits handled)")
#------------------------------------------------------------------------
# Based on a dataset of Cecropia glaziovii frugivores.
# This effectiveness_plot function has repel labels activated.
data(cecropia)
effectiveness_plot(cecropia$totvis, cecropia$totbic, 
    cecropia$fam, cecropia$code, 10, 
    myxlab= "No. visits/10h", 
    myylab="Effectiveness/vis (No. fruits handled)")

```

Effectiveness landscapes are the two-dimensional representation of the possible combinations of the quantity and the quality of mutualistic services (seed dispersal, pollination) and with elevational contours representing isoclines of effectiveness. These representations can be 2D bivariate plots of multiplicative effects of any of the seed dispersal (SDE) or pollination (PE) effectiveness components. This is a repository of code used to produce these plots.

For additional details please visit the web page [here](http://pedroj.github.com/effectiveness/).
