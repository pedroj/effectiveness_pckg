# Tentando colocar as isolinhas de maneira automatica

# NOT-Log scaled axes. Data for Archontophoenix
sde <- read.table("/media/windows/Users/ber/Documents/Documentos_ber/Atividades 2013/Doutorado/Disciplinas/Frugivoria_Mauro/R codes/data/sde.txt", header=T, sep="\t", dec=".", na.strings="NA")

# This are some lines that may be transformed into option of the function
nlines = 10 # number of isolines wanted
xyextremes = c(0, 0, max(sde$vish), max(sde$frutot)) # (x,y) coordinates of the left bottom cornes of the plot, concatenated with the (x,y) coordinates of the top right corner of the plot
#xyextremes <- c(1,2,1.5,9.5)
#xyextremes <- c(0,0.3,0.5,2.2)
lines.in.subplot = TRUE # TRUE if we want (nlines) in the subplot; FALSE if we want (nlines) in the whole plot; this option does not make any difference when we plot the whole plot area
labels = TRUE

# Plotting
plot(sde$vish,sde$frutot,xlab="Visit rate",
     ylab="No. fruits/visit (total handled)", 
     main="Quantitative component",ylim=c(xyextremes[2],xyextremes[4]), xlim=c(xyextremes[1],xyextremes[3]),type="n")
#, col = terrain.colors(4:8)[qc$plant]
#text(vis, frv, plant, cex=0.6, pos=4, col="red")
points(sde$vish,sde$frutot,
       pch=c(1,2,4,6,7)[sde$fam])
#legend("topleft", title="Family",
#       c("Mimidae","Psittacidae","Thraupidae","Turdidae","Tyrannidae"), pch=c(1,2,4,6,7),horiz=F,ncol=1)

alfa <- (xyextremes[4]-xyextremes[2])/(xyextremes[3]-xyextremes[1]) # slope of a straight line linking (left,bottom) to (right,above) corners of the graphic
beta <- xyextremes[2] - alfa*xyextremes[1]
if(lines.in.subplot == T)
{
  xval <- seq(0, max(sde$vish), length.out=(nlines+1))[2:(nlines+1)] # sequence of (nlines) regular spaced x values for the isoclines
} else {
  xval <- seq(xyextremes[1], xyextremes[3], length.out=(nlines+1))[2:(nlines+1)] # sequence of (nlines) regular spaced x values for the isoclines inside the subplot
}
isoc <- (xval*(xval*alfa+beta)) # values of the isoclines

vis1<-seq(trunc(xyextremes[1]),ceiling(xyextremes[3]),length.out=1000)
for(i in 1:nlines)
{
  lines(vis1, isoc[i]/vis1)
  if(labels == T) text(0.9*(xyextremes[3]-xyextremes[1])+xyextremes[1], isoc[i]/(0.9*(xyextremes[3]-xyextremes[1])+xyextremes[1]), paste("QC = ", round(isoc[i], digits=1)), col="red")
}