#--------------------------------------------------------------------
# Based on a dataset of Prunus mahaleb frugivores.
# In this example we build the effectiveness landscape just for the
# quantitative component, plotting its two subcomponents, visitation
# rate and per-visit effectiveness.
#
require(effect.lndscp)
data(prunus)
effectiveness_plot(prunus$visits, prunus$eff_per_vis,
  pts.shape = prunus$group, label = prunus$animal, nlines = 10,
  myxlab = "No. visits/10h",
  myylab = "Effectiveness/vis (No. fruits handled)"
)
#--------------------------------------------------------------------

#--------------------------------------------------------------------
# Based on a dataset of Cecropia glaziovii frugivores.
# This effectiveness_plot function has repel labels activated.
data(cecropia)
effectiveness_plot(cecropia$totvis, cecropia$totbic,
  pts.shape = cecropia$fam, label = cecropia$code, nlines = 10,
  myxlab = "No. visits/10h",
  myylab = "Effectiveness/vis (No. fruits handled)"
)
#--------------------------------------------------------------------
# EUPHONIA
# Illustrating the use of error bars in effcetiveness plots.
E_viola <- subset(Euphonia, species == "Euphonia violacea")
E_chloro <- subset(Euphonia, species == "Euphonia chlorotica")

Eupho <- effectiveness_plot(
  q1 = Euphonia$QTY, q2 = Euphonia$energy_fruit,
  q1.error = Euphonia$QTY_SE, q2.error = NULL, italic = T,
  pts.shape = Euphonia$species, pts.color = Euphonia$species,
  label = Euphonia$plant, nlines = 9,
  lines.breaks = c(3, 7, 29, 43, 61, 81, 106, 136, 182, 231),
  lines.color = "light grey", pts.size = 3,
  myxlab = "QTY component - feeding frequency (fruits/h)",
  myylab = "QLY component - energy (KJ/fruit)"
)
Eupho + scale_colour_manual(values = c("gray43", "gray83")) +
  geom_point(shape = Euphonia$species, colour = "black", size = 3)
#--------------------------------------------------------------------
