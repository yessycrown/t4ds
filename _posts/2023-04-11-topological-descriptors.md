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
the basics of topological data analysis (TDA). While learning the requisite theory,
we present relevant examples in R in order to gain hands-on experience with TDA.

This session is presented jointly by Brittany and Ben. Brittany will cover most of the
theory, and Ben will lead R programming sections.

***Objectives***: After this session, we hope you will be able to:
> - Recognize topological shape in data
> - Define a filtration, and give at least two examples of different
>   filtrations
> - Explain persistence barcodes/diagrams at a high level
> - Create the Vietoris-Rips and other complexes in R
> - Compute a persistence diagram in R

---
---
## 1.Getting Started

We begin this session by introducing simplicial complexes in R.

---
### Simplicial Complexes in R

For a quick example to drive home the intuition 
on [simplicial complexes from Session 1](https://comptag.github.io/t4ds/blog/intro-to-topology), let's
create a simplicial complex in R.

Create a new R script for this session in your project, and name it 
`session-3`. This afternoon we're getting our feet wet with topological data analysis,
so we'll need to install and import the R TDA package.

```
install.packages("TDA")
library(TDA)
```

In the R TDA package, simplicial complexes are typically represented as lists.
Remember they are quite simple to create:

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

Once we have a simplicial complex representing our data, we can compute homology
and other topological invaraints. Thus,
finding a simplicial complex from data gives us the tools necessary to find topology in data.
It turns out that there are tons of ways to study topology in point cloud data. 

As a first example, we consider point cloud data.  That is, a *point cloud*, $S \subset
\mathbb{R}^n$, is a finite set of points in (usually Euclidean) space.  Such data sets arise in many ways.
Mathematically, maybe there is an underlying, unaccessible shape that we can
sample from (such as the torus):

![torus sample](https://upload.wikimedia.org/wikipedia/commons/4/4c/Point_cloud_torus.gif)

Note that manifolds (like the torus) can represent various things. For example,
the torus parameterizes the configuration space of a two-arm linkage (with one
fixed point).  

Other examples of point cloud data can come from locations, such as locations of
[speed traps](https://data.cityofchicago.org/Transportation/Map-Speed-Camera-Locations/7ajp-yjhe)
or
[wildfires](https://www.kaggle.com/datasets/rtatman/188-million-us-wildfires).

Once we have a point cloud, we need to organize it.
You may be familiar with *contact graphs* where the represent a geometric object such as a
circle, curve, or polygon, and an edge between two vertices exists if the corresponding two objects
intersect. The Vietoris-Rips (VR) complex, which we investigate next,
is a generalization of contact graphs.

> Let $S$ be finite set of points in $\mathbb{R}^n$. Let $r\geq 0$. The *Vietoris-Rips (VR) complex* of $S$
> and $r$ is the abstract simplicial complex, denoted $\text{VR}(S, r)$, consisting of all subsets
> of diameter at most $r$:
>
> $ \text{VR}(S, r):=\\{\sigma\subset S \mid \text{ diam}(\sigma)\leq r \\}, $
>
> where the *diameter* of a set of points is the maximum distance between any two points in the set.

Geometrically, we constuct the Vietoris-Rips (VR)-complex by considering balls of radius $\frac{r}{2}$,
centered at each point in $S$. Whenever we have a set of $n$ balls that pairwise intersect, we add an $n-1$
dimensional simplex.  Consider the following sets and their corresponding
simplex:

![rips complexes](https://comptag.github.io/t4ds/assets/images/tda-rips/rips-simplex.svg)

Checking all subsets of $S$, we can find our a simplicial complex:

<img src="https://comptag.github.io/t4ds/assets/images/tda-rips/ripscomplex.svg" 
    height="50"
    alt="Example VR-Complex" 
    style="width:100%">

<details>
<summary style="color:DarkOrange">More Info</summary>
<br>
<pre style="background-color:Gold">
The VR-complex is an approximation of the &#268;ech complex.
The <b>&#268;ech complex</b> is an abstract simplicial complex that is homotopy
equivalent to a union of balls.  It is created by adding a vertex for each ball,
an edge between vertices correspoding to intersecting balls (so far, we're in
the same setting as the Rips filtration), and adding an $n$-simplex for each
$(n+1)$-way intersection of balls. To see where they differ, consider the
two-complex above that is created when three balls pairwise intersect in the
VR-complex.  If there is not a three-way intersection, the triangle is not
added to the &#268;ech complex.
<figure>
<img src="https://comptag.github.io/t4ds/assets/images/tda-rips/cechrips.svg" 
    height="50"
    alt="cechcplx" style="width:100%">
<figcaption>&#268;ech complex.</figcaption>
</figure>
</pre>
</details>


---
## 2. Filtrations

### The Vietoris-Rips Filtration

In the VR-complex, $r$ is a parameter. If we vary $r$, we
get different VR-complexes. So, which one do we pick?
In many data analysis situations, the value of $r$ that best describes
the data is unknown or does not exist, so why not look at all of them!? Observe if we increase $r$
continuously, the complex only changes a finite number of radii, say at $r_0 <
r_1 < \ldots < r_n$. 
Then, we get a family of nested VR-complexes that we call the *Vietoris-Rips filtration* (or simply the Rips filtration).

$\emptyset < K_0 \subset K_1 \subset \ldots \subset K_n=K,$

where $K_i=\text{VR}(S,r_i)$

More generall, a *filtration* of a simplicial complex, $K$, is a nested sequence of subcomplexes starting at the
empty set $\emtpyset$ and ending with the $K$.

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
<pre style="background-color:lightblue">
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
<pre style="background-color:lightblue">
<img src="https://comptag.github.io/t4ds/assets/images/tda-rips/rips_example.gif" alt="gallatin plot">
</pre>
</details>

---

### A Rips Filtration in R

In R, we can use the `ripsFiltration` function in the TDA package to conduct filtrations.
Let's try it out for $r<\sqrt{5}$, using the same four example points from above.  If $r<\sqrt{5}$, 
above, we noted that the complex is simply four points.

```
# create our cloud of four points
x <- c(0,1,2,3)
y <- c(0,3,-1,2)
X <- cbind(x,y)

# set largest allowed radius of balls < sqrt(5)
mymaxscale <- 2

# set other necessary parameters (more on those to come)
mymaxdimension <- 4
mydist <- "euclidean"
mylibrary <- "Dionysus"

# conduct Rips filtration
FltRips <- ripsFiltration(X = X, maxdimension = mymaxdimension,
                          maxscale = mymaxscale, dist = mydist, library = mylibrary,
                          printProgress = TRUE)
```

<details>
<summary style="color:blue">Expected Output</summary>
<br>
<pre style="background-color:lightblue">
<code>
> FltRips <- ripsFiltration(X = X, maxdimension = mymaxdimension,
+                           maxscale = mymaxscale, dist = mydist, library = mylibrary,
+                           printProgress = TRUE)
# Generated complex of size: 4 
</code>
</pre>
</details>


Try on your own to view the resulting Rips complex, and see if it confirms what
we thought the final complex should be above. (HINT: to view the Rips complex, you will need
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
FltRips <- ripsFiltration(X = X, maxdimension = mymaxdimension,
                          maxscale = mymaxscale, dist = "euclidean", library = "Dionysus",
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
> FltRips <- ripsFiltration(X = X, maxdimension = mymaxdimension,
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
> FltRips <- ripsFiltration(X = X, maxdimension = mymaxdimension,
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
> FltRips <- ripsFiltration(X = X, maxdimension = mymaxdimension,
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

Keep this example in your workspace, as we will come back to it shortly.

---
### Images and Lower-Star Filtrations

The Rips filtration is great for creating connections within a point cloud.
However, sometimes, we already know what these connections are.  And, many times
there is a function defined over the topological space that is of interest.  A
simple example to start is an image.  The underlying topological space is a
square or a rectangle (pretty boring topologically).  Images decompose this square domain into
smaller squares called pixels and assign a color to each pixel.  We'll restrict ourselves to
monochromatic images, so we can think of the color as a number between $0$ and
$1$.

In R, let's create and plot a random image:

```
n=20
vals <- array(runif(n*n),c(n,n))
image(vals)
```

<details>
<summary style="color:blue">Expected Output</summary>
<br>
<pre style="background-color:lightblue">
<img src="https://comptag.github.io/t4ds/assets/images/beautiful-image.png" alt="random image">
</pre>
</details>

To construct a complex that represents an image, we create a vertex for each
pixel, add an edge between vertices if their pixels are adjacent.  From here, we
can add squares to get a cubical complex, and draw diagonals in the squares if
we want a simplicial complex.
Here's a small example:

![image to grid](https://comptag.github.io/t4ds/assets/images/grids.svg)

What you might notice is that we started with a discrete set of function vales,
one for each pixel.  The vertices of our complex can inherit that value.  But,
what value do we assign to the edges and two-cells?  Discuss some ideas with
your neighbors.

<details>
<summary style="color:red">See the Answer</summary>
<br>
<pre style="background-color:lightcoral">
There are various ways that we can do this, actually.  The one that we will use
today assigns to each cell the maximum value assigned to any of the vertices
defining the cell.  By doing so, every lower-level set (collection of cells
below a given value) is a complex.  By considering the increasing sequence of
such subcomplexes, we arrive at the <b>lower-star filtration</b>.
</pre>
</details>

For images, the function is actually a surface created by raising each vertex up
to the height equal to it's function value.  Then, edges and two-cells are
interpolated.  The lower-star filtration is exactly the one that arises
by raising our ``height'' parameter and considering subcomplex of the
surface that appears entirely at or below the current height
parameter.  Here's a quick example to demonstrate:

```
newfcn <- function(x, y){jitter(-2*x^2+y^2+x+3*y-6*x+x*y,30)}
x <- seq(-5,5)
y <- seq(-5,5)
persp(x,y,outer(x,y,newfcn),zlab="height",theta=55,phi=25,col="palegreen1",shade=0.5)
```

<details>
<summary style="color:blue">Expected Output</summary>
<br>
<pre style="background-color:lightblue">
<img src="https://comptag.github.io/t4ds/assets/images/surface.png" alt="a surface">
</pre>
</details>

We can contruct the lower-star filtration from the values in our image as
follows:

```
myfilt <- gridFiltration(FUNvalues=vals, sublevel = TRUE, printProgress = TRUE)
```

The output is a complex of 11 simplices, along with a function value assigned to
each simplex.  Can you find what those simplices and function values are?
(Hint: the output of `gridFiltration` has attributes `$cmplx` and
`$values` that stores the simplicial complex and function values for each
simplex, respectively). 

<details>
<summary style="color:red">See the Answer</summary>
<br>
<pre style="background-color:lightcoral">
To see the list of simplices in the complex:
<code>
> myfilt$cmplx
[[1]]
[1] 4

[[2]]
[1] 3

[[3]]
[1] 4 3

[[4]]
[1] 2

[[5]]
[1] 4 2

[[6]]
[1] 1

[[7]]
[1] 2 1

[[8]]
[1] 3 1

[[9]]
[1] 4 1

[[10]]
[1] 4 1 2

[[11]]
[1] 4 3 1
</code>

And the function values:
<code>
> myfilt$values
 [1] 0.1952117 0.4001437 0.4001437 0.5358404 0.5358404 0.6333039
 [7] 0.6333039 0.6333039 0.6333039 0.6333039 0.6333039
</code>
</pre>
</details>


Again, keep this example in your workspace, as we will come back to it shortly.

---
## 3. Introduction to Persistent Homology: Barcodes and Diagrams

Let's step back for a moment and think of a painting.  Museums and art experts
vary on their advice for the best distance to stand from a painting or print:

* [Lightscape Creations](https://www.lightscapecreations.co.uk/blog/2019/10/the-perfect-viewing-distance) 
  says to first "measure the diagonal of the [artwork] from bottom left corder
  to the top right corner".  Then, the viewer should be at a distance equal to 1.5 to 2 times the diagonal.
* [John Paul Caponigro](https://www.johnpaulcaponigro.com/blog/93/printing-ideal-viewing-distance/)
  also uses the diagonal in his calculation, but says that the viewer should be
  three times the diagonal away.
* [Data Genetics](http://datagenetics.com/blog/december42018/index.html) uses
  math to answer this question.
* [J Ken Spencer](https://jkenspencer.com/blog/165155/savoring-a-painting-the-20-6-1-rule)
  advocates for the 20-6-1 rule; that is, there are three distances: 20 feet, 6
  feet, and 1 foot away fom the artwork.

Let's give this a try.  Setup in groups of 3.  Hold up a picture.  Identify
three features of this photo.  Mark the ground with a strip of masking tape to
represent the interval of distances you can see the features clearly.  For
example, you can use Starry Night by Van Gogh:

![starry Night](https://www.vangoghgallery.com/catalog/image/0612/Starry-Night.jpg)

The strips of masking tape create a *barcode*.  The endpoints of the strip are
placed at the minimum and maximum distances that you can view that feature.
Is it possible 

<details>
<summary style="color:red">See Example Answer</summary>
<br>
<pre style="background-color:lightcoral">
<figure>
<img src="https://comptag.github.io/t4ds/assets/images/vangogh-scales-05all.jpg" 
     alt="Starry Night barcode" style="width:100%">
<figcaption>Example barcode for select features in Starry Night. Note that in order to
see the constellation Aries, you need to stand far away from the painting that
you can no longer see individual brush strokes. So, one viewing distance is not
enough.  And, in data, often, one scale is not enough.</figcaption>
</figure>
</pre>
</details>

**Now is a good time for a quick break (if we haven't taken one recently).**

### Diagram for a Rips Filtration

Back to our Rips filtration, we can see that
for certain $r$, homology features are either being created (e.g., loop forming) or going away (e.g., loop being filled in). Let's look more closely at the example from before.

![rips filtration](https://comptag.github.io/t4ds/assets/images/tda-rips/ripsfilt.svg)

For example, when $r=0$, we have four connected components (just the vertices).
When $r=\sqrt{5}$, we only have two connected components. When $r=\sqrt{10}$,
we have only one connected component, but also note that a nontrivial one-cycle appears. It would be nice if there
were some clean way to keep track of this information ...

Fortunately, *persistence barcodes* and *persistence diagrams* can do just that!
Persistence tracks the parameters (time, distance, height) at which a homology feature is "born" $b$
as well as when the same feature "dies" $d$.  Barcodes encode this as an
interval $(b,d) \subset \mathbb{R}$.  Persistence diagrams encode this as a
point $(b,d) \in \mathbb{R}^2$.

<details>
<summary style="color:DarkOrange">More Info</summary>
<br>
<pre style="background-color:Gold">
There is more to it than we say here. A feature of the underlying topological
space ($K$) is called an <b>essential class</b> and never dies.  Thus, the death
parameter can be infinite.  For this reason, we often use the extended real
plane $\overline{\mathbb{R}}^2$,
where $\overline{\mathbb{R}}=\mathbb{R} \cup \{ \infty \}$.  
Even more generally, the parameter space can be an arbitrary
poset.  But, that is more than we need in T4DS.
</pre>
</details>

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
<pre style="background-color:lightblue">
<img src="https://comptag.github.io/t4ds/assets/images/barcode.jpg" alt="rips barcode">
</pre>
</details>

Here, 1d homology (corresponding to the connected components) is represented in black,
and 2d homology (corresponding to the one-cycles) is in red. We can track the birth and death
of the connected components as well as the one-cycle, by seeing the parameters at which segments begin and end in the barcode.

So, being able to plot it is great, but what if we want to work with the
function values (e.g., in order to compare two diagrams)?  We do have direct
access to the coordinates of all points.

```
persistDiag
```

<details>
<summary style="color:blue">Expected Output</summary>
<br>
<pre style="background-color:lightblue">
<code>
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

Finally, if you want to see the persistence diagram instead of the barcode, use:
```
plot(persistDiag[["diagram"]])
```
<details>
<summary style="color:blue">Expected Output</summary>
<br>
<pre style="background-color:lightblue">
<img src="https://comptag.github.io/t4ds/assets/images/persistdiag1.jpg" alt="rips pts">
</pre>
</details>

The barcode and the diagram are visualizations of the same information: the
persistence of homoology generators as a parameter changes. Some researchers
prefer one visualization over an another, but they're ultimately the same object.
How you might be inclined to work with them might differ based on your choice.

---
### Diagram for a Lower-Star Filtration

Recall the image `vals` that we created above.  There is a function in the R
package TDA that computes the persistence diagram:

```
pd=gridDiag(FUNvalues = vals)
plot(pd[["diagram"]])
```

<details>
<summary style="color:blue">Expected Output</summary>
<br>
<pre style="background-color:lightblue">
<img src="https://comptag.github.io/t4ds/assets/images/image-diagram.png" alt="diagram of a random image">
</pre>
</details>

Change $n$ and recompute the diagram.  What pattern do you see?

<details>
<summary style="color:red">See the Answer</summary>
<br>
<pre style="background-color:lightcoral">
Overall, the zero-dimensional persistence points (black dots) are to the left
and below the one-dimensional ones (red triangles).  This makes sense, as in
order for loops to form, there have to be connected components first. The
pattern that arises here is something that has been studied, and can be used for
hypothesis testing (is my image just pure random noise, or is there a feature
hidden in there?)
</pre>
</details>

### Other Filtrations and Diagrams

The general framework of persistence is this: there is an underlying topological
space, $K$, and a "nice" function $f : K \to \mathbb{R}$.  The co-domain is our
*parameter space* and can represent various things: height (in a particular
direction), distance (away from a point or set), time, etc.  As the parameter
$t$ increases, we consider all sublevel sets: $f^{-1}(-\infty,t]$.  These are
subcomplexes of $K$ (or else $f$ was not "nice").  Here's another example that
we call "the (upside down) V example":

![Height and LS Filtrations](https://comptag.github.io/t4ds/assets/images/lsfilt.svg)

In our example, we have a simplicial complex in $\mathbb{R}^2$ and the function
$f$ takes a simplex $\sigma$ to the maximum height of any vertex in the simplex:

$ f(\sigma) = \max_{\text{vertex} v \preceq \sigma} f(v).$

Note that the height of a point (or vertex) $p \in \mathbb{R}^n$ in
direction $d \in \mathbb{S}^{n-1}$ is simply the dot product $v \cdot d$.
Examples to consider are polygons (representing county boundaries, for example)
and [3d scanned object](http://graphics.stanford.edu/data/3Dscanrep/).

Create a complex in R to match the V-example above. (Hint: remember from earlier that a
complex is a list of simplices, and a simplex is a "combination" of vertices).

<details>
<summary style="color:red">See the Answer</summary>
<br>
<pre style="background-color:lightcoral">
<code>
# create vertices
a <- 1; b=2; c=3
# edges
ac <- c(1,3); cb=c(2,3)
# a complex is a list of simplices
vcplx <- list(a,b,c,ac,cb)
</code>
</pre>
</details>

Next, let's use `cbind` to create a data structure to store the coordiantes
(note: you can make up coordinates).

<details>
<summary style="color:red">See the Answer</summary>
<br>
<pre style="background-color:lightcoral">
<code>
x <-c(0,2,1)
y <- c(0,0,1)
vcoords <- cbind(x,y)
</code>
</pre>
</details>

And, the final piece left is to compute the function values for the vertices!
Like above, we can use the z-coordinate of the highest vertex.  For now, we can
do this by hand and create a numeric array.  (Challenge: compute this from
vcoords!)

<details>
<summary style="color:red">See the Answer</summary>
<br>
<pre style="background-color:lightcoral">
<code>
vvals <- c(0,0,1)
</code>
</pre>
</details>


Once we have these elements, we can use the `funFiltration` to create our
filtration and compute the diagram as follows:
```
vfilt <- funFiltration(vvals,vcplx)
vdiag <- filtrationDiag(vfilt,maxdimension=2)
vdiag$diagram
```


<details>
<summary style="color:blue">Expected Output</summary>
<br>
<pre style="background-color:lightblue">
<code>
> vdiag$diagram
     dimension Birth Death
[1,]         0     0   Inf
[2,]         0     0     1
</code>
</pre>
</details>

---

## 4. Wrapping Up

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
- The illustration of representing an image with a cubical or simplicial complex
  is from an upcoming paper by Brittany and her colleagues, Jessi Cisewski-Kehe
  and Dhanush Giriyan.
- The photo of Starry Night is from [The VanGogh Gallery](https://www.vangoghgallery.com/catalog/Painting/508/Starry%20Night.html)
