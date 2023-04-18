---
title: Topological Descriptors
layout: post
post-image: "https://www.nps.gov/npgallery/GetAsset/99BDDE56-1DD8-B71B-0BF0D34E843D9014/proxy/hires?"
description: The theory behind computational topology, along with intuitive examples
tags:
- persistent homology
- height filtration
- vietoris-rips filtration
---

## Overview

To round off day 1, we will combine what you learned in the first two sessions to cover
the basics of computational topology. After learning the requisite theory,
we will present relevant examples in R for students to gain hands on experience.

This session is presented jointly by Brittany and Ben. Brittany will cover most of the
theory, and Ben will lead R programming sections.

### Objectives

After this session, we hope that you will  be able to:

> - Understand how topological shape can exist in data
> - Gain a working knowledge of persistence barcodes and diagrams
> - Gain exposure to the Vietoris-Rips and other complexes
> - Know how to begin the topological data analysis pipeline in R
> - Know how to conduct the Vietoris-Rips and the height filtration in R

---

## Getting Started

We begin this session by introducing simplicial complexes, which are 
a type of data that holds intrinsic topological meaning.

---

### Triangle appreciation

Of course we are all familiar with triangles, and to understand computational topology, we must first conceptualize triangles of differing dimensions. That is, triangles of increasing dimension ranging from 0 to n. (Where the -1th dimensional triangle being a null value).

![n dimensional triangles](https://i.stack.imgur.com/O6xtg.png)

Intuitively, we call an $n$-dimensional triangle an *n-simplex*.

More rigorously,
an *n-simplex* is the smallest convex set of $n+1$ points,
$v_0,...,v_{n}$ where $v_1-v_0,...,v_{n}-v_0$ are linearly independent.
An $n$-simplex has $n+1$ *faces* of dimension $n-1$. For example,
a 2-simplex has three 1-dimensional faces (edges).

We can link simplices together to form a *simplicial complex*. In particular, a *simplicial complex* $K$
is a finite collection of simplices, such that:
1. If $\sigma \in K$ and $\tau \subset \sigma$, then $\tau \in K$.
2. If $\sigma, \sigma'\in K$, then $\sigma \cap \sigma'$ is either empty or a face of both $\sigma, \sigma'$.



![complex subsets](https://comptag.github.io/t4ds/assets/images/tda-rips/asc.svg)


Using a simplicial complex, we can interpret topological features in a computational setting.

---

#### Simplicial Complexes in R

For a quick example to drive home the intuition, let's
create a simplicial complex in R.

Create a new R script for this session in your project, and call it something like
`TDA-Intro`. This afternoon we're getting our feet wet with topological data analysis,
so we'll need to install and import the R TDA package.

```
install.packages("TDA")
library(TDA)
```

In the R TDA package, simplicial complexes are typically represented as lists.
We haven't seen lists yet, but they are quite simple to create:

```
myFirstList <- list(1, TRUE, "There's a string in my list too!")
```

Knowing this, we can create a simplicial complex using only the `list()`
and `c()` functions to create a list object and `combine` function, which we saw earlier.
Typically, we label each vertex in a simplicial complex with an integer, and build the
complex accordingly. Here's how to do it for two vertices joined by an edge.

```
simpleK <- list(1, 2, c(1,2))
```

Try it yourself! See if you can create the simplicial complex in the example above,
combinatorially defined by the set $A$.

<details>
<summary style="color:red">See the Answer</summary>
<br>
<pre style="background-color:lightcoral">
<code>
> K <- list(1,2,3,4,c(1,2),c(1,3),c(1,4),c(2,3),c(2,4),c(3,4),c(1,2,3))
> K
[[1]]
[1] 1

[[2]]
[1] 2

[[3]]
[1] 3

[[4]]
[1] 4

[[5]]
[1] 1 2

[[6]]
[1] 1 3

[[7]]
[1] 1 4

[[8]]
[1] 2 3

[[9]]
[1] 2 4

[[10]]
[1] 3 4

[[11]]
[1] 1 2 3
</code>
</pre>
</details>


---

### From Point Cloud Data to Simplicial Complexes

Now, you might be wondering, "how could I go from typical data,
like a set of points, to a simplicial complex?"

This gets at a major area of study in topological data analysis: finding topology in point cloud data.
It turns out that there are tons of ways to study topology in point cloud data. 
One simple method uses what is called the Vietoris-Rips complex.

Let $S$ be finite set of points in $\mathbb{R}^n$. Let $r\geq 0$. The Rips complex of $S$
and $r$ is the abstract simplicial complex of $\text{VR}(S, r)$ consisting of all subsets
of diameter at most $r$:

$ \text{VR}(S, r):=\{\sigma\subset S \mid \text{ diam}(\sigma)\leq r\} $

where the *diameter* of a set of points is the maximum distance between any two points in the set.

Geometrically, we can constuct the Rips complex by considering balls of radius $\frac{r}{2}$,
centered at each point in $S$. Whenever $n$-balls have pairwise intersections, we add an $n-1$
dimensional simplex.

You may be familiar with *contact graphs* where the vertices represent a geometric object such as a
circle, curve, or polygon, and an edge between two vertices exists if the corresponding two objects
intersect. The Rips complex is a generalization of contact graphs.

Here are some examples of Rips complexes:

![rips complexes](../assets/images/tda-rips/ripscomplex.svg)

---

### The Vietoris-Rips Filtration

A *filtration* of a simplicial complex, $K$, is a nested sequence of subcomplexes starting at the
empty set and ending with the full simplicial complex, i.e.,

$\emptyset \subset K_0 \subset K_1 \subset ... \subset K_n=K.$

Going back to the Rips complex, we consider $r$ to be a free parameter. If we vary $r$, we
get different Rips complexes. In many data analysis situations, the value of $r$ that best describes
the data is unknown or does not exist, so why not look at all of them!? Observe if we increase $r$
continuously, then we get a family of nested Rips complexes; the *Rips filtration*.

Let's work through an example. Let $S:=\{(0,0),(1,3),(2,-1),(3,2)\}\subset \mathbb{R}^2$. We
want to compute a Rips filtration on $S$ for all $r\geq 0$.

![rips filtration](../assets/images/tda-rips/ripsfilt.svg)

Observe:

* When $r<\sqrt{5}$, none of the balls of radius $\frac{r}{2}$ intersect and so $\text{VR}(S,r$) is
four points.
* When $r=\sqrt{5}$, the balls of radius $\frac{\sqrt{5}}{2}$ centered at $(0,0)$ and
$(2,-1)$ intersect which means we add a 1-simplex between $(0,0)$ and $(2,-1)$. Similarly,
we add a 1-simplex between $(1,3)$ and $(3,2)$.
* When $r\in (\sqrt{5},\sqrt{10})$, no additional balls of radius $\frac{r}{2}$ intersect which means $\text{VR}(S, r)=\text{VR}(S, \sqrt{5}$).
* When $r=\sqrt{10}$, we add a two more 1-simplices between $(0,0), (1,3)$, and $(2,-1),
(3,2)$.
* When $r \in (\sqrt{10},\sqrt{13})$, $\text{VR}(S,r)=\text{VR}(S, \sqrt{10}).$
* When $r=\sqrt{13}$, we add two 2-simplices between $(0,0),(1,3),(2,-1)$ and
$(1,3),(2,-1),(3,2)$.
* When $r \in (\sqrt{13},\sqrt{17})$, $\text{VR}(S,r)=\text{VR}(S, \sqrt{13}).$
* When $r=\sqrt{17}$, we add a 3-simplex.
* When $r>\sqrt{17}$, $\text{VR}(S,r)=\text{VR}(S, \sqrt{17}).$

Hopefully this makes sense! 

<details>
<summary style="color:blue">If not, we also made a movie:</summary>
<br>
<pre>
<img src="https://comptag.github.io/t4ds/assets/images/tda-rips/rips_example.gif" alt="gallatin plot">
</pre>
</details>

---

#### A Rips Filtration

In practice, we can create Rips complexes in R

---




## Wrapping Up

TODO
