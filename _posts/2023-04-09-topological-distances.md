---
title: Topological Distances
layout: post
post-image: "https://www.nps.gov/npgallery/GetAsset/F7EDAA43-1DD8-B71C-07722F94F9AAEB4C/proxy/hires?"
description: We now understand the fundamentals of TDA, and persistence diagrams. But how do we compare the results of two filtrations? This will be covered in the following tutorials.
tags:
- persistence
- bottleneck distance
- grid filtration
---

## Overview

To begin our first Saturday session, we will review what we learned yesterday about TDA.
We will discuss methods to compare differing topological filtrations. In doing so,
we give a quantifiable, stable way to discuss differences in shape.


This session is co-presented by Brittany and Ben.

### Objectives

After this session, we hope that you will be able to:

> - Feel confident using simple filtrations in topological data analysis
> - Understand the idea of stability in a metric
> - Understand the bottleneck distance between persistence diagrams
> - Feel confident using the bottleneck distance in R

## Getting Started

To start day 2, we'll begin with a warm-up exercise to refresh on the topics we covered on day 1.

Let's create a toy example, similar to the one we saw at the end of session 3, and conduct a height filtration.

Recall at the end of yesterday, we did a directional filtration (with respect to height) on the following simplicial complex,
that had three vertices and two edges:

![]("https://comptag.github.io/t4ds/assets/images/simp.jpg")

Let's create a new R script for this session, and call it `TDA-Distance`. We'll get started by creating that
original example simplicial complex in R.

```
# create vertices
a <- 1; b=2; c=3;
# edges
ac <- c(1,2); cb=c(2,3)
# a complex is a list of simplices
vcplx <- list(a,b,c,ac,cb)
```

We'll assign coordinates to this simplicial complex, like the example we saw yesterday.

```
x <-c(0,1/2,1)
y <- c(0,1,0)
vcoords <- cbind(x,y)
```

And then assign function values on the vertices.

```
vvals <- c(0,0,1)
```

Do you remember how to compute a directional filtration on this data, with respect to the
function we just assigned? Do that now.

<details>
<summary style="color:red">See the Answer</summary>
<br>
<pre style="background-color:lightcoral">
<code>
vfilt <- funFiltration(vvals,vcplx)
vdiag <- filtrationDiag(vfilt,maxdimension=2)
vidag$diagram
</code>
</pre>
</details>

Next, we'll create one more simplicial complex to work with as an example.
You know how to do it! Try creating a simplicial complex with 4 vertices and two edges,
whose heights correspond to the following figure:

![]("https://comptag.github.io/t4ds/assets/images/simp2.jpg")

<details>
<summary style="color:red">See the Answer</summary>
<br>
<pre style="background-color:lightcoral">
<code>
# create vertices
a <- 1; b=2; c=3; d=4
# edges
ac <- c(1,2); cb=c(2,3)
# a complex is a list of simplices
vcplx <- list(a,b,c,d,ac,cb)

vvals <- c(0,0,1,2)
</code>
</pre>
</details>



## TODO:content here

TODO

## Wrapping Up

TODO
