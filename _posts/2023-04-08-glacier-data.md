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

With the raw glacier data in hand, we can conduct segmentation over a grid.
Let's begin just by working with the Agassiz Glacier, at index 1.

Remember, GIS data often has crazy coordinates. Let's get a sense for them
by computing the points defining the Agassiz Glacier, and finding the bounds in
each column.

```
pts <- glaciers1966[1,]@polygons[[1]]@Polygons[[1]]@coords
bounds <- c(min(pts[,1]), max(pts[,1]), min(pts[,2]), max(pts[,2]))
bounds
```

## Wrapping Up

TODO
