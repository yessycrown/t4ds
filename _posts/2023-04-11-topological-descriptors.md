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

To round off day 1, we combine what you learned in the first two sessions to cover
the basics of topological data analysis (TDA). After learning the requisite theory,
we present relevant examples in R in order to gain hands-on experience with TDA.

This session is presented jointly by Brittany and Ben. Brittany will cover most of the
theory, and Ben will lead R programming sections.

***Objectives***: After this session, we hope you will be able to:
> - Recognize topological shape in data
> - Explain persistence barcodes/diagrams at a high leve
> - Create the Vietoris-Rips and other complexes in R

---

## Getting Started

We begin this session by introducing simplicial complexes, which are 
a type of data that holds intrinsic topological meaning.

---

### Triangle Appreciation

Of course we are all familiar with triangles, and to understand computational topology, we must first conceptualize triangles of differing dimensions. That is, triangles of increasing dimension ranging from $0$ to $n$. (Where the -1th dimensional triangle being a null value).

![n dimensional triangles](https://i.stack.imgur.com/O6xtg.png)

Intuitively, we call an $n$-dimensional triangle an *n-simplex*.

More rigorously,
a *geometric n-simplex* is the smallest convex set of $n+1$ affinely independent points.
An *abstract $n$-simplex* is a set of $n+1$ elements (here, the elements
represent the points).
An $n$-simplex has $n+1$ *faces* of dimension $n-1$ (namely, one for leaving out
each point). For example,
a two-simplex has three one-dimensional faces (edges).

<details>
<summary style="color:DarkOrange">More Info</summary>
<br>
<pre style="background-color:Gold">
We say that the set of points $\{ v_0, v_1, \ldots, v_n\}$ is <i>affinely
independent</i>
iff the vectors $v_1-v_0,...,v_{n}-v_0$ are <i>linearly independent</i>.
</pre>
</details>


We can collect simplices together to form a *simplicial complex*. In particular, a *simplicial complex* $K$
is a finite collection of simplices, such that:
1. If $\sigma \in K$ and $\tau \subset \sigma$, then $\tau \in K$.
2. If $\sigma, \sigma'\in K$, then $\sigma \cap \sigma'$ is either empty or a face of both $\sigma, \sigma'$.



![complex subsets](https://comptag.github.io/t4ds/assets/images/tda-rips/asc.svg)


We can use a simplicial complex to represent shapes (and data). 
Then, we can interpret topological features in a computational setting.

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

$ \text{VR}(S, r):=\left\{\sigma\subset S \mid \text{ diam}(\sigma)\leq r\right\}, $

where the *diameter* of a set of points is the maximum distance between any two points in the set.

Geometrically, we constuct the Rips complex by considering balls of radius $\frac{r}{2}$,
centered at each point in $S$. Whenever $n$-balls pairwise intersect, we add an $n-1$
dimensional simplex.

You may be familiar with *contact graphs* where the vertices represent a geometric object such as a
circle, curve, or polygon, and an edge between two vertices exists if the corresponding two objects
intersect. The Rips complex is a generalization of contact graphs.

Here are some examples of Rips complexes:

![rips complexes](https://comptag.github.io/t4ds/assets/images/tda-rips/ripscomplex.svg)

<details>
<summary style="color:DarkOrange">More Info</summary>
<br>
<pre style="background-color:Gold">
The Vietoris-Rips complex is an approximation of the &#268;ech complex.
The <b>&#268;ech complex</b> is an abstract simplicial complex that is homotopy
equivalent to a union of balls.  It is created by adding a vertex for each ball,
an edge between vertices correspoding to intersecting balls (so far, we're in
the same setting as the Rips filtration), and adding an $n$-simplex for each
$(n+1)$-way intersection of balls. To see where they differ, consider the
two-complex above that is created when three balls pairwise intersect in the
Rips complex.  If there is not a three-way intersection, the triangle is not
added to the &#268;ech complex.
<figure>
<img src="https://comptag.github.io/t4ds/assets/images/tda-rips/cechrips.svg" alt="cechcplx" style="width:100%">
<figcaption>&#268;ech complex.</figcaption>
</figure>
</pre>
</details>


---

### The Vietoris-Rips Filtration

Going back to the Rips complex, we consider $r$ to be a free parameter. If we vary $r$, we
get different Rips complexes. So, which one do we pick?
In many data analysis situations, the value of $r$ that best describes
the data is unknown or does not exist, so why not look at all of them!? Observe if we increase $r$
continuously, the complex only changes a finite number of radii, say at $r_0 <
r_1 < \ldots < r_n$. 
Then, we get a family of nested Rips complexes; the *Rips filtration*.

$\emptyset < K_0 \subset K_1 \subset \ldots \subset K_n=K.$

More generall, a *filtration* of a simplicial complex, $K$, is a nested sequence of subcomplexes starting at the
empty set and ending with the full simplicial complex.

Let's work through an example. Let $S:=\{(0,0),(1,3),(2,-1),(3,2)\}\subset \mathbb{R}^2$. 
For a visualization, this is easy to plot in R:

```
x <- c(0,1,2,3)
y <- c(0,3,-1,2)
plot(x=x, y=y)
```

<details>
<summary style="color:blue">Expected Output</summary>
<br>
<pre>
<img src="https://comptag.github.io/t4ds/assets/images/rips-pts-basic.jpg" alt="rips pts">
</pre>
</details>


We want to compute a Rips filtration on $S$ for all $r\geq 0$.

![rips filtration](https://comptag.github.io/t4ds/assets/images/tda-rips/ripsfilt.svg)

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

Hopefully the Vietoris-Rips filtration, and the idea behind filtrations more generally, is clearer
with an example in mind.

<details>
<summary style="color:blue">If not, we also made a movie:</summary>
<br>
<pre>
<img src="https://comptag.github.io/t4ds/assets/images/tda-rips/rips_example.gif" alt="gallatin plot">
</pre>
</details>

---

#### A Rips Filtration in R

In R, we can use the `ripsFiltration` function in the TDA package to conduct filtrations.
Let's try it out for $r<\sqrt{5}$, using the same 4 example points from above.

```
# create our cloud of four points
x <- c(0,1,2,3)
y <- c(0,3,-1,2)
X <- cbind(x,y)

# set largest allowed radius of balls < sqrt(5)
maxscale <- 2

# set other necessary parameters (more on those to come)
maxdimension <- 4
dist <- "euclidean"
library <- "Dionysus"

# conduct Rips filtration
FltRips <- ripsFiltration(X = X, maxdimension = maxdimension,
                          maxscale = maxscale, dist = "euclidean", library = "Dionysus",
                          printProgress = TRUE)
```

<details>
<summary style="color:blue">Expected Output</summary>
<br>
<pre style="background-color:lightblue">
<code>
> FltRips <- ripsFiltration(X = X, maxdimension = maxdimension,
+                           maxscale = maxscale, dist = dist, library = library,
+                           printProgress = TRUE)
# Generated complex of size: 4 
</code>
</pre>
</details>


Try on your own to view the resulting Rips complex, and see if it confirms what
we thought the complex should be above. (HINT: to view the Rips complex, you will need
to use the `$` syntax for attributes of the filtration)

<details>
<summary style="color:red">See the Answer</summary>
<br>
<pre style="background-color:lightcoral">
<code>
> FltRips$cmplx
[[1]]
[1] 1

[[2]]
[1] 2

[[3]]
[1] 3

[[4]]
[1] 4
</code>
</pre>
</details>

You should see that the complex is 4 points, as we expected! Let's try increasing the
radius further:

```
# set largest allowed radius of balls = sqrt(5)
maxscale <- sqrt(5)

# conduct Rips filtration
FltRips <- ripsFiltration(X = X, maxdimension = maxdimension,
                          maxscale = maxscale, dist = "euclidean", library = "Dionysus",
                          printProgress = TRUE)
FltRips$cmplx
```

<details>
<summary style="color:blue">Expected Output</summary>
<br>
<pre style="background-color:lightblue">
<code>
> maxscale <- sqrt(5)
> # conduct Rips filtration
> FltRips <- ripsFiltration(X = X, maxdimension = maxdimension,
+                           maxscale = maxscale, dist = "euclidean", library = "Dionysus",
+                           printProgress = TRUE)
# Generated complex of size: 6 
> FltRips$cmplx
[[1]]
[1] 1

[[2]]
[1] 2

[[3]]
[1] 3

[[4]]
[1] 4

[[5]]
[1] 1 3

[[6]]
[1] 2 4
</code>
</pre>
</details>

On your own, try doing this setting $r=\sqrt{13}$ and $r=\sqrt{17}$. You should get
the same results that we found by hand.

<details>
<summary style="color:red">See the Answer for sqrt(13)</summary>
<br>
<pre style="background-color:lightcoral">
<code>
> maxscale <- sqrt(13)
> # conduct Rips filtration
> FltRips <- ripsFiltration(X = X, maxdimension = maxdimension,
+                           maxscale = maxscale, dist = "euclidean", library = "Dionysus",
+                           printProgress = TRUE)
# Generated complex of size: 11 
> FltRips$cmplx
[[1]]
[1] 1

[[2]]
[1] 2

[[3]]
[1] 3

[[4]]
[1] 4

[[5]]
[1] 1 3

[[6]]
[1] 2 4

[[7]]
[1] 1 2

[[8]]
[1] 3 4

[[9]]
[1] 1 4

[[10]]
[1] 1 2 4

[[11]]
[1] 1 3 4

</code>
</pre>
</details>

<details>
<summary style="color:red">See the Answer for sqrt(17)</summary>
<br>
<pre style="background-color:lightcoral">
<code>
> maxscale <- sqrt(17)
> # conduct Rips filtration
> FltRips <- ripsFiltration(X = X, maxdimension = maxdimension,
+                           maxscale = maxscale, dist = "euclidean", library = "Dionysus",
+                           printProgress = TRUE)
# Generated complex of size: 15 
> FltRips$cmplx
[[1]]
[1] 1

[[2]]
[1] 2

[[3]]
[1] 3

[[4]]
[1] 4

[[5]]
[1] 1 3

[[6]]
[1] 2 4

[[7]]
[1] 1 2

[[8]]
[1] 3 4

[[9]]
[1] 1 4

[[10]]
[1] 1 2 4

[[11]]
[1] 1 3 4

[[12]]
[1] 2 3

[[13]]
[1] 1 2 3

[[14]]
[1] 2 3 4

[[15]]
[1] 1 2 3 4

</code>
</pre>
</details>

Now that we have a good sense of Vietoris-Rips complexes,
and the filtration that results treating $r>0$ as a free variable,
we now will discuss useful data structures to store and interpret filtrations.

---

### Introduction to Persistence Barcodes

TODO: Brittany add to this, if we want to do barcodes still

Intuitively, in this simple Rips filtration, we can see that
for certain $r$, homology features are either being created or going away.
For example, when $r=0$, we vacuously have four connected components (just the vertices).
When $r=\sqrt{5}$, we only have two connected components. When $r=\sqrt{10}$,
we have only one connected component and a cycle. It would be nice if there
were some clean way to keep track of this information...

Fortunately, so-called *barcodes* were created to do just that.
Barcodes denote the time at which a homology feature is "born",
and when the same feature "dies".

The R TDA package has a function `ripsDiag`
that creates diagrams corresponding to the Rips filtration. Let's view the barcode resulting
from our example filtration:

```
persistDiag <- ripsDiag(X, maxdimension = 4, maxscale=sqrt(17), dist = dist,
                    printProgress = TRUE)
plot(persistDiag[["diagram"]], barcode=TRUE)
```

<details>
<summary style="color:blue">Expected Output</summary>
<br>
<pre>
<img src="https://comptag.github.io/t4ds/assets/images/barcode.jpg" alt="rips barcode">
</pre>
</details>

Here, 1d homology is represented in black, and 2d homology is in red. We can track the birth and death
of this cycle, along with all of the other connected components, by seeing the times
at which segments begin and end in the barcode.


---
### Introduction to Persistence Diagrams

TODO: Brittany and Ben jointly here

In the example above, it would be convenient if we could store the changes resulting from
a filtration in some way. This is the purpose of persistence diagrams, which keep track of
the "times" at which topological features are created or destroyed. That is, persistence
diagrams record the persistence of homology in different dimensions.

If we wanted to record the filtration from earlier in a persistence diagram, we can 
do so in R using the `ripsDiag` function, where `X` is the dataset of four points and maxscale
is $\sqrt{17}$:

```
persistDiag <- ripsDiag(X, maxdimension, maxscale=maxscale, dist = dist,
                    printProgress = TRUE)
persistDiag
```

<details>
<summary style="color:blue">Expected Output</summary>
<br>
<pre style="background-color:lightblue">
<code>
> persistDiag <- ripsDiag(X, maxdimension, maxscale=maxscale, dist = dist,
+                     printProgress = TRUE)
# Generated complex of size: 15 
# Persistence timer: Elapsed time [ 0.000000 ] seconds
> persistDiag
$diagram
     dimension    Birth    Death
[1,]         0 0.000000 4.123106
[2,]         0 0.000000 3.162278
[3,]         0 0.000000 2.236068
[4,]         0 0.000000 2.236068
[5,]         1 3.162278 3.605551
</code>
</pre>
</details>

As an object this is not particularly helpful, though we can get insight into birth/death times.
Let's use the built in plotting functionality for persistence diagrams to get a better look:

```
plot(persistDiag[["diagram"]])
```

<details>
<summary style="color:blue">Expected Output</summary>
<br>
<pre>
<img src="https://comptag.github.io/t4ds/assets/images/persistdiag1.jpg" alt="rips pts">
</pre>
</details>

We can see that the persistence diagram picks up on the birth and death of
all four individual points, as well as the cycle created at $r=\sqrt{10}$
and destroyed at $r=\sqrt{13}$. By the end of the filtration,
there is one 0-dimensional homology group (connected component) persisting as well.

---

#### A Rips Filtration On GIS Data

So far, we have mostly only been working with toy examples. Let's work now with a
big data set, which will illuminate some of the considerations that data scientists
must make in practice. 

We will again use the Montana County data from this morning. You should be able to access
it while working in the same project, even if you are working in a different R script.
Try accessing it in your current script.

```
names(counties)
```

<details>
<summary style="color:blue">Expected Output</summary>
<br>
<pre style="background-color:lightblue">
<code>
> names(counties)
 [1] "NAME"       "NAMEABBR"   "COUNTYNUMB" "PKEY"      
 [5] "SQMILES"    "PERIMETER"  "ACRES"      "ALLFIPS"   
 [9] "FIPS"       "LAST_UPDAT" "NAMELABEL"  "BAS_ID"    
[13] "ID_UK"      "Shape_Leng" "Shape_Area"
</code>
</pre>
</details>

On your own, try selecting the spatial data corresponding to Flathead, Missoula, and Sanders county.
(HINT: Remember we can use the `which()` function to get the index of a given element)

```
# get the three counties surrounding Lake county, and Flathead lake.
lakeNeighbors <- # select Flathead, Missoula, and Sanders county
```

<details>
<summary style="color:red">See the Answer</summary>
<br>
<pre style="background-color:lightcoral">
<code>
lakeNeighbors <- counties[c(which(counties$NAME=="FLATHEAD"), which(counties$NAME=="MISSOULA"), which(counties$NAME=="SANDERS")), ]
</code>
</pre>
</details>

If you did this correctly, you should be able to achieve the following plot:

```
plot(lakeNeighbors)
```

<details>
<summary style="color:blue">Expected Output</summary>
<br>
<pre>
<img src="https://comptag.github.io/t4ds/assets/images/lakeneighbors.jpg" alt="lake">
</pre>
</details>

Now that we have these counties selected, use the `spsample` function to sample 4000
points at random from the three counties, and save the sample in a new variable
`lakeSample`.

<details>
<summary style="color:red">See the Answer</summary>
<br>
<pre style="background-color:lightcoral">
<code>
lakeSample <- spsample(lakeNeighbors, n=4000, "random")
</code>
</pre>
</details>

You can plot the result, which should match the shape of the three counties you've selected.

```
plot(lakeSample, pch=20, cex=.5)
```

<details>
<summary style="color:blue">Expected Output</summary>
<br>
<pre>
<img src="https://comptag.github.io/t4ds/assets/images/lakesample.jpg" alt="lake">
</pre>
</details>

Now let's try a Rips filtration on this GIS data. Intuitively, we should expect to find
a cycle in the place of Lake County. Though, now we are working with huge data!
This is where the parameters we've set really come into play. For a few minutes,
discuss shortcomings of the Rips filtration in this setting, and potential remedies.

```
# be sure to cast lakeSample as a data frame
X <- as.data.frame(lakeSample)
persistDiag <- ripsDiag(X, ... ) # how should we compute this?
```

<details>
<summary style="color:red">See Possible R Solution</summary>
<br>
One remedy is to cap the size of r, as well as the dimension that we're allowed to compute.
If we set maxdimension=1 and maxscale=20000, we should be able to compute this ok, while still detecting a cycle. There is no perfect solution!

<pre style="background-color:lightcoral">
<code>
> X <- as.data.frame(lakeSample)
> persistDiag <- ripsDiag(X, maxdimension=1, maxscale=20000, dist = "euclidean",
+                         printProgress = TRUE)
# Generated complex of size: 9907872 
# Persistence timer: Elapsed time [ 0.000000 ] seconds
> plot(persistDiag[["diagram"]])
</code>
</pre>
</details>

<details>
<summary style="color:red">See Resulting Persistence Diagram</summary>
<br>
<pre>
<img src="https://comptag.github.io/t4ds/assets/images/bigripspd.jpg" alt="rips pts">
</pre>
</details>

---

### The Height Filtration

TODO: Brittany discuss the theory behind this, Ben create examples.

Another common filtration in TDA is the height filtration.
This takes a different form from the Vietoris-Rips filtration,
in that all data is not born from the onset of the filtration.
In contrast, we can intuitively think of the height filtration as a
curtain rising on a simplicial complex.

TODO: Brittany add theory here, and perhaps motivate the height filtration a bit

TODO: Ben expand/improve this example. Maybe use toy example chosen by Brittany.

One especially useful function in the TDA package is `circleunif`, which creates
a point cloud by randomly sampling on the unit circle. This is handy when getting familiar
with TDA as an easy way to create data with interesting topology.
We will randomly sample in this way from the unit circle, and then create a Rips complex.
Once we've done that, we will conduct a height filtration on the Rips complex.

```
X <- circleUnif(n=6, r=1)
```

Then we create a rips complex:

```
FltRips <- ripsFiltration(X = X, maxdimension = 2,
                          maxscale = 1.5, dist = "euclidean", library = "Dionysus",
                          printProgress = TRUE)
```

Assign height function values to each vertex,
and conduct a height filtration:

```
FUNvalues <- X[, 1] + X[, 2]
FltFun <- funFiltration(FUNvalues = FUNvalues, cmplx = FltRips[["cmplx"]])
```

Be sure to visualize your resulting simplicial complex after the filtration:

```
FltFun$cmplx
```




---

## Wrapping Up

Thanks for your attention to end today's workshop materials! To summarize our accomplishments
this afternoon:

> - We learned about simplicial complexes, and worked with them in R
> - We learned about Vietoris-Rips complexes, and used them in R
> - We learned about filtrations
> - We learned about persistence diagrams and barcodes, and implemented them in R
> - We learned about the height filtration

---
### Credits

- This material was based on [other tutorials](https://comptag.github.io/rpackage_tutorials/)
  developed by Robin Belton, Ben Holmgren (name familiar?), and Jordan Schupbach. We thank
  them for giving us a head start on this material!

