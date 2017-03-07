#---------------------------------------------------------------------------
# effectiveness
# Function to plot effectiveness landscapes.
#---------------------------------------------------------------------------
# autoisolines: Code for automatically plotting isolines of
# effectiveness landscapes.
# Based on code for plotting effectiveness landscapes by Pedro 
# Jordano and code for automatic calculation of isolines 
# by Bernardo Santos.
# 3 December 2013. UNESP, Rio Claro, Brazil. Pedro Jordano.
#---------------------------------------------------------------------------
## First version 12 Jan 2009. Revised 3 December 2013.
## New revision 23 January 2015.
#---------------------------------------------------------------------------
# DESCRIPTION:
# The script plots effectiveness landscapes as described in
# Schupp, E. W., Jordano, P. and Gómez, J.M. 2010. Seed dispersal
# effectiveness revisited: a conceptual review. New Phytologist
# 188: 333-353.
#---------------------------------------------------------------------------
# Options:
#   q1, the "quantitative component", to plot on the X axis. 
#   q2, the "qualitative component", to plot on the Y axis.
#   group=NA, a grouping variable to set point shapes (e.g., family).
#   label= NA, a label for the individual points (e.g., spcies acronym).
#   nlines=10, specify the number of isolines.
#   myxlab= "QtComp", optional label for axis X.
#   myylab= "QltComp", optional label for axis Y.
# 
# Example:
# effectiveness(sde$visits, sde$eff_per_vis, sde$group, sde$animal, 10, 
#               myxlab= "No. visits/10h", 
#               myylab="Effectiveness/vis (No. fruits handled)")
# effectiveness(cgla$totvis, cgla$totbic, cgla$fam, cgla$code, 15, 
#               myxlab= "Total no. visits", 
#               myylab="No. fruits pecked/vis")
#---------------------------------------------------------------------------
#
effectiveness<- function(q1, q2, group=NA, label= NA, nlines=10,
                        myxlab= "QtComp", myylab= "QltComp")    {
    # q1 is the component to plot on X axis
    # q2 is the component to plot on Y axis
    # group is a group label
    # label is a taxa label
    require(devtools)
    require(ggplot2)
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
    p1<- ggplot(d, aes(x=q1, y=q2)) + 
        geom_point(shape= group, size=5) +
        geom_text(size= 4, label= label, hjust= 0.5, vjust= 1.9) +
        mytheme_bw()
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
#---------------------------------------------------------------------------
