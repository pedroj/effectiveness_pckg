# The effectiveness package      
[![DOI](https://zenodo.org/badge/84199078.svg)](https://zenodo.org/badge/latestdoi/84199078)      

This is `effect.lndscp`, an `R` package for plotting the effectiveness landscape of mutualisms adding isolines of equal effectiveness values.

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

**References**       
Schupp, E.W., Jordano, P. &amp; Gómez, J.M. (2017). A general framework for effectiveness concepts in mutualisms. _Ecology Letters_, **00**, 000–000. In press. **doi**: 10.1111/ele.12764    
Schupp, E.W., Jordano, P. & Gómez, J.M. (2010) Seed dispersal effectiveness revisited: A conceptual review. _New Phytologist_, **188**, 333–353.       
Schupp, E.W. (1993) Quantity, quality and the effectiveness of seed dispersal by animals. In: _Frugivory and seed dispersal: ecological and evolutionary aspects_ (eds T.H. Fleming & A. Estrada), pp. 15–29. Springer, Dordrecht; The Netherlands.       
Jordano, P. & Schupp, E.W. (2000) Seed disperser effectiveness: The quantity component and patterns of seed rain for _Prunus mahaleb_. _Ecological Monographs_, **70**, 591–615.     



