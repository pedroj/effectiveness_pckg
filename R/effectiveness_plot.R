
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
#' @param label Optional. A character vector of the same length as \code{q1} and \code{q2} providing a label for the individual points (e.g., species acronym). Note that \code{label} may be NA for some points (useful to avoid overplotting of labels).
#' @param show.lines Logical. Show effectiveness isolines? (default is TRUE).
#' @param nlines Specify the number of isolines.
#' @param lines.breaks Either a numeric vector given break points for the contour lines, or \code{"pretty"} or \code{"quantile"} to choose optimal breaks using \code{link[classInt]{classIntervals}}. Note that using "pretty" will override nlines, as the number of lines will be determined algorithmically. 
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
                               pts.shape = NULL, pts.color = NULL, 
                               label = NA, 
                               show.lines = TRUE, nlines = 6,
                               lines.breaks = "quantile", lines.color = "grey50", 
                               myxlab= "QtComp", myylab= "QltComp")    {

    
    ## Some checks before starting the work...
    
    if (length(q1) != length(q2)) stop("q1 and q2 must have equal length")
    

    
    ### General elements ###
    
    d <- data.frame(x = q1, y = q2, label = label)  
    
    effplot <- 
        ggplot() + 
        mytheme_bw() +
        labs(x = myxlab, y = myylab) 
    
    
    
    ### Error bars ###
    
    if (!is.null(q1.error)) {
        
        d <- data.frame(d, x.error = q1.error)
        effplot <- effplot + 
            geom_errorbarh(aes(x = x, y = y, xmin = x - x.error, xmax = x + x.error), data = d)
    }
    
    if (!is.null(q2.error)) {
        
        d <- data.frame(d, y.error = q2.error)
        effplot <- effplot + 
            geom_errorbar(aes(x = x, y = y, ymin = y - y.error, ymax = y + y.error), data = d)
    }
    
    
    
    
    
    ### Draw points ###
    
    if (is.null(pts.color) & is.null(pts.shape)) {
        effplot <- effplot +
            geom_point(aes(x, y), data = d, size = 2)
    }
    
    if (is.null(pts.color) & !is.null(pts.shape)) {
        d <- data.frame(d, pts.shape)
        effplot <- effplot +
            geom_point(aes(x, y, shape = pts.shape), data = d, size = 2)
    }
    
    if (!is.null(pts.color) & is.null(pts.shape)) {
        d <- data.frame(d, pts.color)
        effplot <- effplot +
            geom_point(aes(x, y, colour = pts.color), data = d, size = 2)
    }
    
    if (!is.null(pts.color) & !is.null(pts.shape)) {
        d <- data.frame(d, pts.shape, pts.color)
        effplot <- effplot +
            geom_point(aes(x, y, color = pts.color, shape = pts.shape), 
                       data = d, size = 2)
    }
    
        

    
    
    ##### Plotting contour lines ####

    if (show.lines) {
        
        ### Fabricate contour lines ###
        
        ## Define lower and upper bounds ##
        x.lower <- ifelse(is.null(q1.error), min(q1), min(q1) - q1.error)
        x.upper <- ifelse(is.null(q1.error), max(q1), max(q1) + q1.error)
        y.lower <- ifelse(is.null(q2.error), min(q2), min(q2) - q2.error)
        y.upper <- ifelse(is.null(q2.error), max(q2), max(q2) + q2.error)
        
        ## Calculate values ##
        df <- expand.grid(x = seq(x.lower - 0.05*x.lower, x.upper + 0.05*x.upper, length.out = 500),
                          y = seq(y.lower - 0.05*y.lower, y.upper + 0.05*y.upper, length.out = 500))
        df$z <- df$x * df$y
        
        ## Define line breaks ##
        ## If not provided, using classIntervals to get nice breaks:
        ## style = "pretty" give nice rounded numbers for breaks (often ignoring nlines)
        ## style = "quantile" cover better the plot, but values are not rounded (uglier)
        if (lines.breaks == "quantile") {
            lbreaks <- classInt::classIntervals(df$z, n = nlines + 1, style = "quantile")$brks
        }
        
        if (lines.breaks == "pretty") {
            lbreaks <- classInt::classIntervals(df$z, n = nlines + 1, style = "pretty")$brks  
        }
        
        if (is.numeric(lines.breaks)) {
            if (length(lines.breaks) != (nlines + 1)) stop("Length of lines.breaks does not match the specified number of lines (nlines + 1)")
            lbreaks <- lines.breaks
        }
        
        
        
        #### Preparing curve labels ####
        brk <- lbreaks[-c(1, length(lbreaks))]
        xlabel <- rep(max(df$x) + 0.05*max(df$x), times = length(brk))
        ylabel <- brk/xlabel
        xy.labels <- data.frame(x = xlabel, y = ylabel,
                                label = as.character(round(brk)))
        
        
        ### Add lines to plot ###
        effplot <- effplot +
            geom_contour(aes(x, y, z = z), data = df, colour = lines.color, breaks = lbreaks) + 
            geom_text(aes(x, y, label = label), data = xy.labels)
        
        
    } 
    
    
    
    ### Add point labels with ggrepel ###
    
    if (any(!is.na(label))) {
        
        effplot <- effplot +
            geom_text_repel(aes(x, y), data = d, size = 3, label = label, 
                            nudge_y = 0.5, 
                            segment.size = 0.2, segment.alpha = 0.75) 
    }
    
    
    ## Print and return ggplot object
    effplot
    
}

