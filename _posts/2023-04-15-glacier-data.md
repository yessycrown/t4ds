---
title: Exploration of Glacier Data In R
layout: post
post-image: "https://www.nps.gov/npgallery/GetAsset/73DEAD5F-1DD8-B71C-07D706E33BB2C5C2/proxy/hires?"
description: Using what we've learned about topology, TDA, and data analysis more broadly, we
study the evolving shape of glaciers in Montana's Glacier National Park.
tags:
- persistence
- bottleneck distance
- grid filtration
---

## Overview

TODO: write brief summary

This session is co-presented by Brittany and Ben.

### Objectives

After this session, we hope that you will  be able to:

- TODO

## Getting Started

TODO

## TODO:content here

## MOVED from other tutorial
### Getting Started with GIS Data in R

For this tutorial we will use GIS data from Glacier National Park in Northwestern Montana.
The data can be downloaded from the USGS at [this address](https://www.sciencebase.gov/catalog/item/58af7022e4b01ccd54f9f542).

Let's begin by downloading the data from 1966:

![data](../assets/images/links.png)

For fun, click around a bit with the data you've downloaded. It is in shapefile format, which can be 
viewed with GIS software. One easy way to do this is with Google Earth. Google Earth Pro is free to 
download, and you import shapefiles (on Mac) with

```
file -> import
```

The glacier data should look something like this:

![google](../assets/images/googleearth.png)

After gaining some familiarity with the data that we're working with, let's start actually working with
the data in R. Open R Studio, and begin a new R script in your desired location.
Import the R 'Geospatial' Data Abstraction Library (RGDAL), and the Spatial Data library (SP), which we will use to upload and manipulate the shapefiles:

```
library(rgdal)
library(sp)
```

Import the 1966 glacier data using the corresponding `readOGR` method from RGDAL. You must use the 
absolute path of the directory storing the GIS data, and also give the prefix of the data in the layer 
argument. On a Mac, this is:

```
glaciers_66 <- readOGR(dsn = "/Users/you/INSERT YOUR PATH HERE/GNPglaciers_1966",
layer = "GNPglaciers_1966", verbose = FALSE)
```

(Note that the relative path `~/GNPglaciers_1966` won't work for the dsn argument)

View the first glacier you've uploaded using the `head` method:

```
first <- head(county, 1)
first
```

Notice that the data is pretty big! We have uploaded every glacier in GNP, so there's a lot in there.
You can view the first 5 glaciers if you want to get more of a sense of the complexity of our data.

```
first_five <- head(county, 5)
first_five
```

Notice that the fundamental glacier shape data is stored in polygon format.
The standard R command for plotting is carried along with GIS data as well.
Plot the first glacier to visualize it, it should look familiar to what you saw on Google Earth.

```
plot(first)
```

![glacier1](../assets/images/glacier1.png)


We can also go ahead and view all of the glaciers in GNP in the same way.

```
plot(glaciers_66)
```

![glacier2](../assets/images/glacier2.png)

Now, we can't do topological data analysis using polygon objects. Rather, we need to somehow obtain a 
point cloud indicative of each glacier. To do this, we can randomly sample 1000 points within each 
polygon using the SP library.

Let's try sampling points within the first glacier.

```
pts <- spsample(first,n=1000,"random")
pts
```

To plot this, we can convert the sampled points to a data frame format, and view the resulting point 
cloud. For ease of visibility, each point will be plotted as a small, filled in circle.

```
X <- as.data.frame(pts)
plot(X, pch=20, cex=.5)
```

Notice that we are starting to see the shape of the first glacier. Let's make a denser point cloud 
by sampling 10000 points instead.

```
pts <- spsample(first,n=10000,"random")
X <- as.data.frame(pts)
plot(X, pch=20, cex=.5)
```

![glacier3](../assets/images/glacier3.png)

TODO

## Wrapping Up

TODO
