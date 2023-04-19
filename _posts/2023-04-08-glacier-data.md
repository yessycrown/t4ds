---
title: Exploration of Glacier Data In R
layout: post
post-image: "https://www.nps.gov/npgallery/GetAsset/73DEAD5F-1DD8-B71C-07D706E33BB2C5C2/proxy/hires?"
description: Using what we've learned about topology, TDA, and data analysis more broadly, we study the evolving shape of glaciers in Montana's Glacier National Park.
tags:
- persistence
- bottleneck distance
- grid filtration
---

## Overview

In this session, we'll combine the theoretical ideas and simple
R tutorials with an exciting application area in GIS: the changing
shape of glaciers. We will study the differences in shape of the
glaciers in Glacier National Park over time, and compare our findings
to other metrics of glacier health.

This session is co-presented by Brittany and Ben.

### Objectives

After this session, we hope that you will be able to:

> - Use theoretical ideas in topology for domain-specific applications
> - Interpret the changing shape of Montana's glaciers
> - Compare and contrast shape differences with changes in glacial health


## Getting Started with Glacier Data in R

For this tutorial we will use GIS data from Glacier National Park in Northwestern Montana.
The data can be downloaded from the USGS at [this address](https://www.sciencebase.gov/catalog/item/58af7022e4b01ccd54f9f542).

If you have Google Earth Pro installed on your computer (it is free to download), you can
view shapefiles overlayed on Earth. Consider downloading the data locally,
and playing around with it in Google Earth:

![data](../assets/images/links.png)

Once downloaded, the data can be imported with:

```
file -> import
```

In Google Earth, the glacier data should look something like this:

![google](../assets/images/googleearth.png)

After (hopefully) gaining some familiarity with the data, let's start actually working with
the data in R. Open R Studio cloud, and create a new R script. Call it something
like, `Glacier-TDA`.
As before, we will use the `RGDAL` and `SP` libraries to upload and manipulate shapefiles:

```
library(rgdal)
library(sp)
```

Import the 1966 glacier data directly from the internet using `download.file` and then `system`
to unzip the .zip file.

```
download.file("https://www.sciencebase.gov/catalog/file/get/58af7532e4b01ccd54f9f5d3?facet=GNPglaciers_1966",destfile = "/cloud/project/Glaciers.zip")
system("unzip /cloud/project/MontanaCounties.zip")
```

Then read in the downloaded `.shp` file using `readOGR`.

```
glaciers1966 <- readOGR(dsn="/cloud/project/GNPglaciers_1966.shp")
```


View the first glacier you've uploaded using the `head` method:

```
glaciers1966[1,]
```

Notice that the data is pretty big! We have uploaded every glacier in GNP, so there's a lot going on.
You can view the first 5 glaciers if you want to get more of a sense of the complexity of our data.

```
first_five <- head(glaciers1966, 5)
first_five
```

Notice that the fundamental glacier shape data is stored in polygon format.
The standard R command for plotting is carried along with GIS data as well.
Plot the first glacier to visualize it.(If you have Google Earth, it should look familiar to what you saw there.)

```
glaciers1966[1,]
```

![glacier1](../assets/images/glacier1.png)


We can also go ahead and view all of the glaciers in GNP in the same way.

```
plot(glaciers1966)
```

![glacier2](../assets/images/glacier2.png)

---

### Segmentation of Raw GIS Data

For 5-10 minutes, using what you know about filtrations,
discuss amongst yourselves how we might transform our GIS data in order to study its topology.
What options do we have? Could these options introduce error?

---

With the raw glacier data in hand, let's try creating a grid of points lying within the polygon.

We'll start out just with the first glacier in GNP on our list, and then move to a bigger
set of glaciers. As a warmup exercise, see if you can find the
name of `glaciers1966[1,]`, the first glacier in our dataframe.

<details>
<summary style="color:red">See the Answer</summary>
<br>
<pre style="background-color:lightcoral">
<code>
> names(glaciers1966)
 [1] "RECNO"      "X_COORD"    "Y_COORD"    "GLACNAME"   "CLASSIFICA"
 [6] "YEAR"       "SOURCE_SCA" "SOURCE"     "COMMENT"    "Shape_Leng"
[11] "Area1966"   "OWNERSHIP"  "OBJECTID"  
> glaciers1966[1,]$GLACNAME
[1] "Agassiz Glacier"
</code>
</pre>
</details>

Do you remember how to sample within a spatial polygon? Recall from yesterday,
we sampled from within counties in Montana randomly. See if you can sample randomly
1000 points from the Agassiz Glacier, and save this in the `randGlac` variable.

<details>
<summary style="color:red">See the Answer</summary>
<br>
<pre style="background-color:lightcoral">
<code>
randGlac <- spsample(glaciers1966[1,], n=1000,"random")
</code>
</pre>
</details>

Now, let's quickly visualize our random sample:

```
plot(randGlac)
```

<details>
<summary style="color:blue">Expected Output</summary>
<br>
<pre>
<img src="https://comptag.github.io/t4ds/assets/images/agassizrandom.jpg" alt="agassiz random plot">
</pre>
</details>

As might have arisen in your discussions, we could take a random sample from the
Agassiz glacier. However, this would introduce additional imprecision and randomness to
our data, which we don't necessarily want. A better idea is to get a uniform grid
from within our polygon, and use TDA (namely, a grid filtration) on that.

Let's get sample a uniform grid of 4000 points from within our polygon. Luckily, the `spsample`
function has the option to get a `regular` sample.

```
unifGlac <- spsample(glaciers1966[1,], n=4000, "regular")
```

Indeed, if we plot this we get a clean grid:

```
plot(unifGlac, pch=20, cex=.25)
```

<details>
<summary style="color:blue">Expected Output</summary>
<br>
<pre>
<img src="https://comptag.github.io/t4ds/assets/images/agassizgrid.jpg" alt="agassiz random plot">
</pre>
</details>



And, we get something nice to do TDA with.
That is, we can do a grid filtration by assigning the same height to each point in the grid,
and get the resulting persistence diagram using the `gridDiag` function.

The last thing we'll need before we can do this is to figure out the bounds of our 
rid. See if you can figure out how to do this, using what you know about dataframes in R.
Remember that you can find the points defining the corners of a polygon with the following syntax:

```
glaciers1966[1,]@polygons[[1]]@Polygons[[1]]@coords
```


<details>
<summary style="color:red">See the Answer</summary>
<br>
<pre style="background-color:lightcoral">
<code>
> # compute points on Agassiz Glacier
> pts <- glaciers1966[1,]@polygons[[1]]@Polygons[[1]]@coords
> xlim <- c(min(pts[,1]), max(pts[,1]))
> ylim <- c(min(pts[,2]), max(pts[,2]))
> lim <- cbind(xlim, ylim)
> lim
         xlim    ylim
[1,] 268044.4 5423908
[2,] 269715.9 5426157
</code>
</pre>
</details>

We also need to know the distance between points in our grid.
Find this just by quick inspection:

```
head(unifGlac, 10)
```

It looks like our points have distance 20, meaning that the grid distance parameter
`by` will be 40.

Now we have everything we need to conduct a grid filtration on the Agassiz glacier.
Let's see what the persistence diagram looks like when doing so.
To start, try the following:

```
Diag1 <- gridDiag(as.data.frame(unifGlac), distFct, lim = lim, by=40, sublevel = TRUE, printProgress = TRUE)
```

And then plot the resulting persistence diagram:

```
plot(Diag1[["diagram"]])
```



## Wrapping Up

TODO
