
#' Function to plot effectiveness landscapes, with repel labels option.
#' 
#' @import ggplot2
#' @import ggrepel
#' @importFrom classInt classIntervals
#' 
#' @param q1 Numeric vector representing the "quantitative component", to plot on the X axis. 
#' @param q2 Numeric vector representing the "qualitative component", to plot on the Y axis.
#' @param q1.error Optional. Numeric vector to be used as error bars for \code{q1}.
#' @param q2.error Optional. Numeric vector to be used as error bars for \code{q2}.
#' @param pts.shape Optional. A grouping variable (< 7 groups) to set point shapes (e.g., family).
#' @param pts.color Optional. A grouping variable to set point colours (e.g., family).
#' @param pts.size Optional. Size of points.
#' @param label Optional. A character vector of the same length as \code{q1} and \code{q2} providing a label for the individual points (e.g., species acronym). Note that \code{label} may be NA for some points (useful to avoid overplotting of labels).
#' @param label.size Size of point labels.
#' @param italic Logical. Use italic font for labels? 
#' @param show.lines Logical. Show effectiveness isolines? (default is TRUE).
#' @param nlines Specify the number of isolines.
#' @param lines.breaks Either a numeric vector giving break points for the contour lines, or a \code{"style"} (e.g. \code{"quantile"}, \code{"equal"}, or \code{"pretty"}) to choose optimal breaks using \code{\link[classInt]{classIntervals}}. Note that using "pretty" will override \code{nlines}, as the number of lines will be determined algorithmically. See \code{\link[classInt]{classIntervals}} for more details.
#' @param lines.color Color of the isolines.
#' @param myxlab optional label for axis X.
#' @param myylab optional label for axis Y.
#'
#' @details The script plots effectiveness landscapes as described in Schupp, E. W., Jordano, P. and Gómez, J.M. 2010. Seed dispersal effectiveness revisited: a conceptual review. New Phytologist 188: 333-353.
#' 
#' @return A ggplot2 object, which can be later modified (see examples).
#' @export
#'
#' @examples
#' #------------------------------------------------------------------------
#' # Based on a dataset of Cecropia glaziovii frugivores.
#' # In this example we build the effectiveness landscape just for the 
#' # quantitative component, plotting its two subcomponents, visitation 
#' # rate and per-visit effectiveness.
#' #------------------------------------------------------------------------
#' data(cecropia)
#' effectiveness_plot(q1 = cecropia$totvis, q2 = cecropia$totbic, 
#'     myxlab= "No. visits/10h", 
#'     myylab="Effectiveness/vis (No. fruits handled)")
#' #------------------------------------------------------------------------
#' 
#' ## Avoiding label overplotting ##
#' ## e.g. showing only names of species with high effectiveness
#' labels = cecropia$code
#' labels[4:length(cecropia$code)] <- NA
#' effectiveness_plot(q1 = cecropia$totvis, q2 = cecropia$totbic, 
#'     label = labels, 
#'     myxlab= "No. visits/10h", 
#'     myylab="Effectiveness/vis (No. fruits handled)")
#'     
#'     
#' ################################################
#' 
#' ## Modify plot ##
#' myplot <- effectiveness_plot(q1 = cecropia$totvis, q2 = cecropia$totbic, 
#'     label = labels, nlines = 10, 
#'     myxlab= "No. visits/10h", 
#'     myylab="Effectiveness/vis (No. fruits handled)")
#' myplot + theme_minimal()
#' 
#'
effectiveness_plot <- function(q1, q2, 
                               q1.error = NULL, q2.error = NULL, 
                               pts.shape = NULL, pts.color = NULL, pts.size = 2,
                               label = NA, label.size = 3, italic = FALSE, 
                               show.lines = TRUE, nlines = 6,
                               lines.breaks = "quantile", lines.color = "grey50", 
                               myxlab= "QtComp", myylab= "QltComp")    {

    
    ## Some checks before starting the work...
    
    if (length(q1) != length(q2)) stop("q1 and q2 must have equal length")
    

    
    ### General elements ###
    
    d <- data.frame(x = q1, y = q2, label = label)  
    
    effplot <- 
        ggplot(data = d, aes(x, y)) + 
        mytheme_bw() +
        labs(x = myxlab, y = myylab) +
        theme(legend.title = element_blank())
    
    
    
    ##### Plotting contour lines ####
    
    if (show.lines) {
        
        ### Fabricate contour lines ###
        
        ## Define lower and upper bounds ##
        x.lower <- ifelse(is.null(q1.error), 0, min(0, q1 - q1.error, na.rm = TRUE))
        x.upper <- ifelse(is.null(q1.error), max(q1), max(q1, q1 + q1.error, na.rm = TRUE))
        y.lower <- ifelse(is.null(q2.error), 0, min(0, q2 - q2.error, na.rm = TRUE))
        y.upper <- ifelse(is.null(q2.error), max(q2), max(q2, q2 + q2.error, na.rm = TRUE))
        
        ## Calculate values ##
        df <- expand.grid(x = seq(x.lower - 0.05*x.lower, x.upper + 0.05*x.upper, length.out = 500),
                          y = seq(y.lower - 0.05*y.lower, y.upper + 0.05*y.upper, length.out = 500))
        df$z <- df$x * df$y
        
        ## Define line breaks ##
        ## If not provided, using classIntervals to get nice breaks:
        ## e.g. style = "pretty" give nice rounded numbers for breaks (often ignoring nlines)
        ## style = "quantile" cover better the plot, but values are not rounded (uglier)
        ## there are other alternatives, see ?classIntervals
        
        if (is.numeric(lines.breaks)) {
            if (length(lines.breaks) != (nlines + 1)) stop("Length of lines.breaks does not match the specified number of lines (nlines + 1)")
            lbreaks <- lines.breaks
        }
        
        if (is.character(lines.breaks)) {
            lbreaks <- classInt::classIntervals(df$z, n = nlines + 1, 
                                                style = lines.breaks)$brks
        }
        
        

        
        #### Preparing curve labels ####
        brk <- lbreaks[-c(1, length(lbreaks))]
        xlabel <- rep(max(df$x) + 0.05*max(df$x), times = length(brk))
        ylabel <- brk/xlabel
        # trying pretty labels:
        if (is.numeric(lines.breaks)) lines.labels <- as.character(brk) else
            lines.labels <- ifelse(brk > 10, as.character(round(brk)), 
                                   as.character(signif(brk, digits = 2)))
        xy.labels <- data.frame(x = xlabel, y = ylabel, label = lines.labels)
        xy.labels <- subset(xy.labels, y > y.lower)
        
        
        ### Add lines to plot ###
        effplot <- effplot +
            geom_contour(aes(x, y, z = z), data = df, colour = lines.color, breaks = lbreaks, size = 0.3) + 
            geom_text(aes(x, y, label = label), data = xy.labels)
        
        
    } 
    
    
    
    ### Error bars ###
    
    if (!is.null(q1.error)) {
        
        d <- data.frame(d, x.error = q1.error)
        #d$x.error[is.na(d$x.error)] <- 0
        effplot <- effplot + 
            geom_errorbarh(aes(xmin = x - x.error, xmax = x + x.error), data = d)
    }
    
    if (!is.null(q2.error)) {
        
        d <- data.frame(d, y.error = q2.error)
        #d$y.error[is.na(d$y.error)] <- 0
        effplot <- effplot + 
            geom_errorbar(aes(ymin = y - y.error, ymax = y + y.error), data = d)
    }
    
    
    
    
    
    ### Draw points ###
    
    if (is.null(pts.color) & is.null(pts.shape)) {
        effplot <- effplot +
            geom_point(size = pts.size)
    }
    
    if (is.null(pts.color) & !is.null(pts.shape)) {
        d <- data.frame(d, pts.shape)
        effplot <- effplot +
            geom_point(aes(shape = pts.shape), data = d, size = pts.size)
    }
    
    if (!is.null(pts.color) & is.null(pts.shape)) {
        d <- data.frame(d, pts.color)
        effplot <- effplot +
            geom_point(aes(colour = pts.color), data = d, size = pts.size)
    }
    
    if (!is.null(pts.color) & !is.null(pts.shape)) {
        d <- data.frame(d, pts.shape, pts.color)
        effplot <- effplot +
            geom_point(aes(color = pts.color, shape = pts.shape), 
                       data = d, size = pts.size)
    }
    
        

    ### Add point labels with ggrepel ###
    
    if (any(!is.na(label))) {
        
        effplot <- effplot +
            geom_text_repel(aes(x, y), data = d, size = label.size, label = label, 
                           # nudge_y = 0.5, 
                            segment.size = 0.2, segment.alpha = 0.75,
                            fontface = ifelse(isTRUE(italic), "italic", "plain")) 
    }
    
    
    ## Print and return ggplot object
    effplot
    
}

