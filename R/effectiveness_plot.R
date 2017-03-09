# Tests --------------------------------------------------------------------
devtools::install_github('hadley/ggplot2', force=T)
devtools::install_github('thomasp85/ggforce', force=T)
devtools::install_github('thomasp85/ggraph', force=T)
devtools::install_github('slowkow/ggrepel', force=T)

effectiveness_plot(prunus$visits, prunus$eff_per_vis, 
    prunus$group, prunus$animal, 10, 
    myxlab= "No. visits/10h", 
    myylab="Effectiveness/vis (No. fruits handled)")

effectiveness_plot(cecropia$totvis,cecropia$totbic, 
    cecropia$fam, cecropia$code, 10, 
    myxlab= "No. visits/10h", 
    myylab="No. fruit pecks/visit")


# The function -------------------------------------------------------------
#' Function to plot effectiveness landscapes.
#' 
#' @import ggplot2
#'
#' @param q1 the "quantitative component", to plot on the X axis. 
#' @param q2 the "qualitative component", to plot on the Y axis.
#' @param group a grouping variable to set point shapes (e.g., family).
#' @param label a label for the individual points (e.g., spcies acronym).
#' @param nlines specify the number of isolines.
#' @param myxlab optional label for axis X.
#' @param myylab optional label for axis Y.
#'
#' @details The script plots effectiveness landscapes as described in Schupp, E. W., Jordano, P. and Gómez, J.M. 2010. Seed dispersal effectiveness revisited: a conceptual review. New Phytologist 188: 333-353.
#' 
#' @return A ggplot2 object.
#' @export
#'
#' @examples
#' # Based on a dataset of Prunus mahaleb frugivores.
#' # In this example we build the effectiveness landscape just for the 
#' # quantitative component, plotting its two subcomponents, visitation 
#' # rate and per-visit effectiveness.
#'---------------------------------------------------------------------------'
effectiveness_plot<- function(q1, q2, group=NA, label= NA, nlines=10,
    myxlab= "QtComp", myylab= "QltComp")    {
    # q1 is the component to plot on X axis
    # q2 is the component to plot on Y axis
    # group is a group label
    # label is a taxa label
    require(devtools)
    require(ggplot2)
    require(ggrepel)
    #
    d<-as.data.frame(cbind(q1, q2, group, label))
    names(d)
    nlines <- nlines+1 # number of isolines wanted
    # slope of a straight line linking (left,bottom) to (right,above) 
    # corners of the graphic
    alfa <- max(d$q2)/max(d$q1)
    # sequence of (nlines) regular spaced x values for the isoclines
    xval <- seq(0, max(d$q1), 
        length.out=(nlines+1))[2:(nlines+1)] 
    isoc <- (xval*xval*alfa) # values of the isoclines
    vis1<-seq(0, max(d$q1), length.out= 1000)
    #
    pp<- as.data.frame(vis1) # Build dataset for within loop plot.
    for(i in 1:nlines)
    {
        pp<- cbind(pp, isoc[i]/vis1)
    }    
    # Main plot ------------------------------------------------------------
    # mytheme_bw.R
    # devtools::source_gist("https://gist.github.com/b843fbafa3af8f408972")
    devtools::source_gist("b843fbafa3af8f408972", filename = "mytheme_bw.R")
    #
    p1<- ggplot(d, aes(x= q1, y= q2)) + 
         geom_point(shape= group, size= 3) +
         geom_text_repel(aes(x= q1, y= q2), size= 3, label= label, 
                         nudge_y= 0.5,
                         segment.size= 0.2, segment.alpha= 0.75) +
    #    geom_text(size= 2, label= label, hjust= 0.5, vjust= 2.2) +
         mytheme_bw()
    # Repel labels
    # ggplot(d) +
    # geom_point(aes(q1, q2), color = 'red') +
    #    geom_text_repel(aes(wt, mpg, label = rownames(mtcars))) +
    #    theme_classic(base_size = 16)
    #
    # Adding isolines ------------------------------------------------------
    labelx<- rep(0.8*max(q1), nlines)
    labely<- as.vector(t(pp[800,1:nlines+1]))
    
    for(i in 1:nlines+1){ 
        #labely<- isoc[i]/(0.8*max(sde$eff_per_vis)
        #    labely<- pp[,i][800]
        p1= p1 + geom_line(aes(x, y), 
            data= data.frame(x= pp$vis1, y= pp[,i]), 
            col="blue", size = 0.25, alpha= 0.6) + 
            ylim(0, max(q2)) +
            xlab(paste(myxlab)) + 
            ylab(paste(myylab))  # +
        #        geom_text(aes(), data= NULL, x= labelx, y= labely, 
        #            label = paste("QC = ", round(isoc[i], digits=1)),
        #            size = 4, colour = "red")
    }
    p1 + annotate("text", x= labelx, y= labely,
        label=paste("QC= ", round(isoc,1)), 
        size=4, colour="red", hjust=0) 
}

