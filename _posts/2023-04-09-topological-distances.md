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

Now that we have our second simplicial complex, and a function on its vertices,
you can do one more height filtration!

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

Pause for a moment and think about the result of this filtration.
The example is simple enough; try walking through it. Does
it match what you expected?

---

## Distances in Topological Data Analysis

Now that we have our hands on two different filtrations,
a natural question emerges. How do I differentiate between them?
Indeed, the shape in these two sets of data is clearly topologically different!

The main focus of this session will be defining distance in TDA.
Namely, we will define a distance between persistence diagrams.

Let's briefly think about what a persistence diagram is.
Really, it's nothing more than a set of points, and a diagonal.

---

### Distance Between Sets of Points

First, we will think about distance between two sets of points in $\mathbb{R}^2$.
Consider the finite sets $A,B \subset \mathbb{R}^2$. If we wanted to define distance between
$A$ and $B$, we could think about the weight of the optimal pairing between points in $A$
and points in $B$.

That is, for $\Gamma$, the set of all bijections $f: A \to B$, we have

$d(A,B) = \text{min}_{f \in \Gamma} \text{max}_{a \in A}d(a-f(a))$

Let's visualize this with an example, where $A$ is in red and $B$ is in blue:

![](https://comptag.github.io/t4ds/assets/images/pts.jpg)

With this example, can you visualize what we might do to find the
optimal pairing between $A$ and $B$?

<details>
<summary style="color:red">See the Answer</summary>
<br>
<pre style="background-color:lightcoral">
<img src="https://comptag.github.io/t4ds/assets/images/pts-pairs.jpg " alt="pts pairs">
</pre>
</details>

Finally, the *weight* of such a pairing is the largest distance between pairs.
See if you can pick this out in our example.

<details>
<summary style="color:red">See the Answer</summary>
<br>
<pre style="background-color:lightcoral">
<img src="https://comptag.github.io/t4ds/assets/images/pts-weight.jpg " alt="pts pairs">
</pre>
</details>


### Incorporating Persistence Diagrams

We can use the same idea for persistence diagrams.
That is, given two persistence diagrams `PD1` and `PD2`,
we compute the optimal matching between points, and find its weight.

However, there should be one glaring issue that comes to mind in doing this.
*What if PD1 and PD2 have a different number of points?* Indeed, then a bijection
would not be possible, and our distance is not well-defined.

To handle this issue, we consider the diagonal on persistence diagrams
as having infinite cardinality. If a bijection is not possible, "leftover"
points are paired with the diagonal. Then, the so-called *bottleneck distance*
between persistence diagrams is defined as follows:

$d_B(PD1, PD2) = 

## Wrapping Up

TODO
