#' Quantitative component of effectiveness for Prunus mahaleb-frugivorous birds interactions.
#'
#' Data from a study on Prunus mahaleb (Rosaceae) seed dispersal by frugivorous
#' animals in SE Spain.
#' Variables include:
#' # Visitation data come from 107.3 h direct watches.
#' abundance-          Mean no. birds censused/km, averaged for two study years.
#' visits-             Mean no. visitis recorded to fruiting trees (/10 h).
#' prop_visits-        Proportion of total visits recorded (feeding records)
#'                     contributed by species. Relative to the total no. 
#'                     records in two study years.
#' eff_per_vis-        Mean no. fruits swallowed per visit (successfully 
#'                     dispersed seeds).
#' eff_total-          Visit rate * eff_per_vis*prop fruits swallowed.
#' prop_disp_service-  Proportion of total dispersal service contributed by
#'                     species.
#'
#' @docType data
#' 
#' @usage data(prunus)
#'
#' @format A dataset (dataframe).
#'
#' @keywords datasets
#'
#' @references Schupp, E. W., Jordano, P. and Gomez, J.M. 2010. Seed dispersal effectiveness revisited: a conceptual review. New Phytologist 188: 333-353.
#'
#' @source \href{https://raw.githubusercontent.com/pedroj/effectiveness/master/data.txt}{Data txt archive}
#'
"prunus"