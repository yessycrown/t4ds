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

Let's create a simple example, similar to the one we saw at the end of session 3, and conduct a height filtration.

Recall at the end of yesterday, we did a directional filtration (with respect to height) on the following simplicial complex,
that had three vertices and two edges:

![]("https://comptag.github.io/t4ds/assets/images/simp.jpg")

We'll start out by doing something similar, but on a new complex.

Let's create a new R script for this session, and call it `TDA-Distance`. Begin by creating an example
simplicial complex in R.

```
cplx <- list(1,2,3,4,5,6,c(1,2),c(2,3),c(2,4),c(3,4),c(4,5),c(5,6))
```

As a warm up exercise, try drawing the simplicial complex that results from the above code. (You hopefully
should've received paper)

<details>
<summary style="color:red">See the Answer</summary>
<br>
<pre style="background-color:lightcoral">
<img src="https://comptag.github.io/t4ds/assets/images/cplx.jpg " alt="complex">
</pre>
</details>

We'll assign coordinates to this simplicial complex, like the example we saw yesterday.

```
x <-c(0,1,2,3,4,5,6)
y <- c(0,0,1,0,0,0)
cplxcoords <- cbind(x,y)
```

And then assign function values on the vertices.

```
cplxf1 <- c(0,0,2,0,1,0)
cplxf2 <- c(2,4,1,3,1,5)
```

Now that we have a a function on a complex, do you remember how to compute a directional filtration on this data? Try doing that now
for each function on the vertices, `cplxf1` and `cplxf2`.

<details>
<summary style="color:red">See the Answer</summary>
<br>
<pre style="background-color:lightcoral">
<code>
filt1 <- funFiltration(cplxf1,cplx)
diag1 <- filtrationDiag(filt1,maxdimension=2)
diag1$diagram
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
a <- 1; b <- 2; c <- 3; d <- 4
# edges
ac <- c(1,2); cb <- c(2,3)
# a complex is a list of simplices
vcplx2 <- list(a,b,c,d,ac,cb)

vvals2 <- c(0,0,1,2)
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
vfilt2 <- funFiltration(vvals2, vcplx2)
vdiag2 <- filtrationDiag(vfilt2, maxdimension=2)
vidag2$diagram
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
$d(A,B) = \min_{f \in \Gamma} \max_{a \in A}||a-f(a)||_2$.

Recall that $x-y_2$ denotes the Euclidean distance between $x$ and $y$.

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
That is, given two persistence diagrams $PD_1$ and $PD_2$,
we compute the optimal matching between points, and find its weight.

However, there should be one glaring issue that comes to mind in doing this.
*What if PD1 and PD2 have a different number of points?* Indeed, then a bijection
would not be possible, and our distance is not well-defined.

To handle this issue, we consider the diagonal on persistence diagrams.
If a bijection is not possible, any "leftover"
points are paired with the diagonal. Let $\Gamma$ be the set of all
partial matchings from $PD_1$ to $PD_2$. Then, the so-called *bottleneck distance*
between persistence diagrams can be defined by
$d_B(PD_1, PD_2) = \inf_{f \in \Gamma} \sup_{p \in PD_1}||p - f(p)||_{\infty}$

<details>
<summary style="color:blue">A Quick Refresher on Infinity Norms</summary>
<br>
<pre style="background-color:lightblue">
If you haven't seen the infinity norm or need a refresher, it is defined by taking
the maximum element in a vector: $||X||_{\infty} = \max_{x \in X}$.
</pre>
</details>

Let's take a look at our example from before.
With these two height filtrations in hand, we can define the bottleneck
distance between them in R.

Begin by taking a look at each persistence diagram.

```
vdiag1$diagram
plot(vdiag1[["diagram"]])
```

<details>
<summary style="color:blue">Expected Output</summary>
<br>
<pre style="background-color:lightblue">
<code>
> vdiag1$diagram
     dimension Birth Death
[1,]         0     0   Inf
[2,]         0     0     1
</code>
</pre>
</details>

<details>
<summary style="color:blue">Expected Output</summary>
<br>
<pre style="background-color:lightblue">
<img src="https://comptag.github.io/t4ds/assets/images/pdheight1.jpg " alt="pts pairs">
</pre>
</details>

```
vdiag2$diagram
plot(vdiag2[["diagram"]])
```

<details>
<summary style="color:blue">Expected Output</summary>
<br>
<pre style="background-color:lightblue">
<code>
> vdiag2$diagram
     dimension Birth Death
[1,]         0     2   Inf
[2,]         0     0   Inf
[3,]         0     0     1
</code>
</pre>
</details>

<details>
<summary style="color:blue">Expected Output</summary>
<br>
<pre style="background-color:lightblue">
<img src="https://comptag.github.io/t4ds/assets/images/pdheight2.jpg " alt="pts pairs">
</pre>
</details>

Clearly, the findings differ between `vdiag1` and `vdiag2`. See if you can figure out what the optimal matching would
be in this simple example. (HINT: Make sure you remember that the point on the persistence diagram born at time 0 and
dying at time 1 has multiplicity 2.)

<details>
<summary style="color:red">See the Answer</summary>
<br>
<pre style="background-color:lightcoral">
The optimal matching in this setting will pair 
</pre>
</details>




### An Example with GIS Data

## Wrapping Up

TODO
