library(rgdal)
library(sp)
library(raster)
# read input
glaciers_66 <- readOGR(dsn = "/Users/ben/Repos/CompTaG/T4DS/GNPglaciers_1966",
layer = "GNPglaciers_1966", verbose = FALSE)
first <- head(glaciers_66, 1)
first
# get a feel for the data a bit
names(first)
dim(glaciers_66)
glaciers_66[1,]
names(glaciers_66)
unique(glaciers_66$GLACNAME)

# if we need to get pts on boundary
coords <- first@polygons[[1]]@Polygons[[1]]@coords
coords
plot(coords)

# if we need to test pts in polygon
point.in.polygon(1,2,coords[,1],coords[,2])
point.in.polygon(269000,5424500,coords[,1],coords[,2])
                 

which.

first_five <- head(glaciers_66, 5)
first_five
plot(first)
plot(glaciers_66)
pts <- spsample(first,n=1000,"random")
X <- as.data.frame(pts)
plot(X, pch=20, cex=.5)
pts <- spsample(first,n=10000,"random")
X <- as.data.frame(pts)
plot(X, pch=20, cex=.5)
length(glaciers_66)
glaciers_66[3]
length(first_five)
first_five[1]
glaciers_66[6,]
for (i in length(first_five)){
  plot(glaciers_66[i,])
}
plot(glaciers_66[5,])

first_five[1]

library(TDA)
# rips
maxdimension <- 1
maxscale <- 400

FltRips <- ripsFiltration(X = X, maxdimension = maxdimension,
                          maxscale = maxscale, dist = "euclidean", library = "GUDHI",
                          printProgress = TRUE)

# plot rips filtration

DiagLim <- 400
maxdimension <- 1

## rips diagram
Diag <- ripsDiag(X, maxdimension, DiagLim, printProgress = TRUE)
par(mfrow = c(1, 3))
plot(Diag[["diagram"]])
plot(Diag[["diagram"]], rotated = TRUE)
plot(Diag[["diagram"]], barcode = TRUE)


## grid diag
n <- 300
XX <- circleUnif(n)
XX

## Ranges of the grid
Xlim <- c(-1.8, 1.8)
Ylim <- c(-1.6, 1.6)
lim <- cbind(Xlim, Ylim)
by <- 0.05

h <- .3  #bandwidth for the function kde

#Distance Function Diagram of the sublevel sets
Diag1 <- gridDiag(XX, distFct, lim = lim, by = by, sublevel = TRUE,
                  printProgress = TRUE) 
Diag2 <- gridDiag(XX, kde, lim = lim, by = by, sublevel = FALSE,
                  library = "Dionysus", location = TRUE, printProgress = TRUE, h = h)
#plot
par(mfrow = c(2, 2))
plot(XX, cex = 0.5, pch = 19)
title(main = "Data")
plot(Diag1[["diagram"]])
title(main = "Distance Function Diagram")
plot(Diag2[["diagram"]])
title(main = "Density Persistence Diagram")
one <- which(Diag2[["diagram"]][, 1] == 1)
plot(XX, col = 2, main = "Representative loop of grid points")
for (i in seq(along = one)) {
  points(Diag2[["birthLocation"]][one[i], , drop = FALSE], pch = 15, cex = 3,
         col = i)
  points(Diag2[["deathLocation"]][one[i], , drop = FALSE], pch = 17, cex = 3,
         col = i)
  for (j in seq_len(dim(Diag2[["cycleLocation"]][[one[i]]])[1])) {
    lines(Diag2[["cycleLocation"]][[one[i]]][j, , ], pch = 19, cex = 1, col = i)
  }
}
