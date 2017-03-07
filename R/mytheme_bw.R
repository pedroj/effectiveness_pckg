mytheme_bw <- function (base_size = 12, base_family = "") 
{
    theme_grey(base_size = base_size, base_family = base_family) %+replace% 
        theme(axis.text = element_text(size = rel(0.8)), 
              axis.ticks = element_line(colour = "black"), 
              legend.key = element_rect(colour = "grey80"), 
              panel.background = element_rect(fill = "white", colour = NA), 
                panel.border = element_rect(fill = NA, colour = "black"), 
                panel.grid.major = element_line(colour = "grey90", size = 0.2), 
                panel.grid.minor = element_line(colour = "grey98", size = 0.4), 
                strip.background = element_rect(fill = "grey80", 
                colour = "grey50", size = 0.2))
}
