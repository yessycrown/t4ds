---
title: Data Wrangling in R
layout: post
post-image: "https://www.nps.gov/npgallery/GetAsset/F28095AF-155D-451F-673713EBF5C09EE6/proxy/hires?"
description: A basic intro to R, and the beginning of the topological data analysis pipeline with GIS data from Glacier National Park
tags:
- gis
---

---
## Overview

After this session, we hope you will take away the following:

### Objectives
> - Learn how to read data into R
> - Learn basic R functionalities and data structures
> - Visualize data with R
> - Be able to use R on GIS data
> - Understand early stages of the data analysis pipeline, by playing with data
> - Prepare GIS data for the topological data analysis pipeline

---

## Getting Started

Before we really get going with topology and topological data analysis, 
we first need a basic understanding of how to handle data in R.

We will be working with R online in [R Studio Cloud](https://login.rstudio.cloud/),
though if you'd prefer to work in R Studio locally that is fine too. Create an account,
this is probably easiest using your google account, and start working in the `posit cloud`.

Once in your workspace, begin by clicking `new project` and selecting an `RStudio` project.
Name the project whatever you'd like, perhaps something like `R-Intro`. Then use
`File -> New File -> R Script` to create a new R script.

### Reading data into R

Let's get started with some basic CSV data. It turns out, there is a really easy command
to import csv data in R, and we can even do it directly from a webpage.
In this workshop, we like glaciers a lot,
and we can download some glacier data natively in R as follows:

```
glacier_csv <- 'https://pkgstore.datahub.io/core/glacier-mass-balance/glaciers_csv/data/c04ec0dab848ef8f9b179a2cca11b616/glaciers_csv.csv'

# this data has a header, so we set header=TRUE to keep it out of the rest of our data
glacier_data <- read.csv(file=glacier_csv, header = TRUE)

```

Go ahead and take a look at the result by running:

```
glacier_data
```

And see what class the data is with:

```
class(glacier_data)
```

<details>
<summary>Expected Output</summary>
<br>
<pre>
<code>
> glacier_data <- read.csv(file=glacier_csv, header = TRUE)
> glacier_data
   Year Mean.cumulative.mass.balance Number.of.observations
1  1945                        0.000                     NA
2  1946                       -1.130                      1
3  1947                       -3.190                      1
4  1948                       -3.190                      1
5  1949                       -3.820                      3
6  1950                       -4.887                      3
7  1951                       -5.217                      3
8  1952                       -5.707                      3
9  1953                       -6.341                      7
10 1954                       -6.825                      6
11 1955                       -6.575                      7
12 1956                       -6.814                      7
13 1957                       -6.989                      9
14 1958                       -7.693                      9
15 1959                       -8.325                     11
16 1960                       -8.688                     14
17 1961                       -8.935                     15
18 1962                       -9.109                     20
19 1963                       -9.567                     22
20 1964                       -9.699                     22
21 1965                       -9.298                     24
22 1966                       -9.436                     27
23 1967                       -9.303                     29
24 1968                       -9.219                     31
25 1969                       -9.732                     31
26 1970                      -10.128                     32
27 1971                      -10.288                     32
28 1972                      -10.441                     32
29 1973                      -10.538                     32
30 1974                      -10.613                     32
31 1975                      -10.534                     33
32 1976                      -10.633                     35
33 1977                      -10.682                     37
34 1978                      -10.754                     37
35 1979                      -11.127                     37
36 1980                      -11.318                     36
37 1981                      -11.394                     35
38 1982                      -11.849                     36
39 1983                      -11.846                     37
40 1984                      -11.902                     37
41 1985                      -12.238                     37
42 1986                      -12.782                     37
43 1987                      -12.795                     37
44 1988                      -13.260                     37
45 1989                      -13.343                     37
46 1990                      -13.687                     37
47 1991                      -14.255                     37
48 1992                      -14.501                     36
49 1993                      -14.695                     37
50 1994                      -15.276                     37
51 1995                      -15.486                     37
52 1996                      -15.890                     37
53 1997                      -16.487                     37
54 1998                      -17.310                     37
55 1999                      -17.697                     37
56 2000                      -17.727                     37
57 2001                      -18.032                     37
58 2002                      -18.726                     37
59 2003                      -19.984                     37
60 2004                      -20.703                     37
61 2005                      -21.405                     37
62 2006                      -22.595                     37
63 2007                      -23.255                     37
64 2008                      -23.776                     37
65 2009                      -24.459                     37
66 2010                      -25.158                     37
67 2011                      -26.294                     37
68 2012                      -26.930                     36
69 2013                      -27.817                     31
70 2014                      -28.652                     24
> class(glacier_data)
[1] "data.frame"
</code>
</pre>
</details>

Data frames are a central concept in R programming, and the next section shows us some of the things
we can do with them.


### Fundamental data structures in R

We can get a sense of the size of our data running:

```
dim(glacier_data)
```

<details>
<summary style="color:blue">Expected Output</summary>
<br>
<pre>
<code style="background-color:lightblue">
> dim(glacier_data)
[1] 70  3
</code>
</pre>
</details>

Telling us that our data has 70 rows, and 3 columns. We can grab
entries by row, column index as follows:

```
# row 1, column 1
glacier_data[1,1]

# row 27, column 3
glacier_data[27,3]
```

Note that in R, indices start at 1, and not at 0!
If we're working with large data and want to get a feel for things, the
`head` method is quite useful:

```
# grab the first 5 rows of glacier_data
head(glacier_data, 5)
```

We can pull multiple entries out
of a dataframe with `c()` the ``combine" method in R as well, that is,

```
# grab rows 2,3,5 and columns 2,3
glacier_data[c(2, 3, 5), c(2, 3)]
```

If we want contiguous rows and columns, we can also use:

```
# grab rows 4 through 10, and all 3 columns
glacier_data[4:10, 1:3]
```

Finally, if we want all rows or all columns,
we can leave indices blank:

```
# grab only row 2
glacier_data[2,]
```

Therein lies R data manipulation in a nutshell!

### Fundamental visualizations in R

As the language of choice for statisticians, it should come as no surprise that one can also
easily get statistical summaries from data.

Basic functions like `min`, `max`, `sd`, and `mean` allow us to grab statistical properties from our
data. For example:

```
# get min cumulative mass balance
min(glacier_data[,2])

# get mean
mean(glacier_data[,2])
```

For a more comprehensive summary, we can use the `summary` function.

```
summary(glacier_data)
```



## Working with GIS Data in R

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


### Preparing Data for the Topological Data Analysis Pipeline

