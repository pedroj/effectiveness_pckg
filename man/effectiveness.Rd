\name{effectiveness}
\alias{effectiveness}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Function to plot effectiveness landscapes
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
effectiveness(q1, q2, group = NA, label = NA, nlines = 10, myxlab = "QtComp", myylab = "QltComp")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{q1}{
A vector with the quantity component, to be plotted as the X axis.
}
  \item{q2}{
A vector with the quality component, to be plotted as the Y axis.
}
  \item{group}{
A grouping variable to set point shapes (e.g., to group species by family).
}
  \item{label}{
Label of the plot.
}
  \item{nlines}{
The number of isolines to be plotted. Default is 10.
}
  \item{myxlab}{
Label for the X axis. Default is 'QtComp'.
}
  \item{myylab}{
Label for the Y axis. Default is 'QltComp'.
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
Schupp, E. W., Jordano, P. and Gomez, J.M. 2010. Seed dispersal effectiveness revisited: a conceptual review. New Phytologist 188: 333-353.
}
\author{
Pedro Jordano
}
\note{
The code for automatically plotting isolines of effectiveness landscapes is based on code for plotting effectiveness landscapes by Pedro Jordano and code for automatic calculation of isolines by Bernardo Santos.
3 December 2013. UNESP, Rio Claro, Brazil. 
First version 12 Jan 2009. Revised 3 December 2013.
New revision 23 January 2015.
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
devtools::use_package("downloader")
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
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~effectiveness }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~mutualism }% __ONLY ONE__ keyword per line
\keyword{ecological interactions}
\keyword{graphics}