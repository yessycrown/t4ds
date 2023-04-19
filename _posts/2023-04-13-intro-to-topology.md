---
title: A Brief Introduction to Topology
layout: post
post-image: "https://upload.wikimedia.org/wikipedia/commons/5/5d/Konigsberg_bridges.png"
description: A light and fast introduction to the pure math subject of topology, and its computational interface.
tags:
- topology
- topological data analysis
- TDA
- computational topology
- shape
- data
---

---
## Overview

In this session, we will have a light and fast introduction to the subject of
topology, a field of mathematics that stems from pure mathematics, but has
applications in data analysis that makes it an interesting subject to applied
mathematicians, statisticians, computer scientists, data scientists, and other
data scientists alike.

This session is presented by Brittany.

***Objectives***: After this session, we hope you will be able to:
> - Define `shape` of data
> - Describe topological and geometric properties of a space/shape

---
## 1. Getting Started

We are glad that you are here with us for this workshop!  The first activity is
hands-on, literally.

We will stand in a circle.  Then, raise right hands and grab someone's hand from
across the circle.  Then, raise left hands and grab someone else's hand.  Can we
unknot ourselves?

Knot theory is fun!  If we can unknot ourselves and are one connected component,
then we have formed **the unknot**, or the most basic/fundamental of all knots.
If we created two cycles (each an unknot or not), then we have formed a link.

[![unknotting](https://img.youtube.com/vi/UmF0-Tz1oWc/hqdefault.jpg)](https://www.youtube.com/watch?v=UmF0-Tz1oWc)

Other knots that are interesting (and not equivelent to the unknot) are the
trefoil knot and the figure 8 knot.

TODO:figure

Variants to try (in smaller groups):

1. If you start facing each other and hold your neighbor's hands, can you
   turn your circle "inside-out" and have your backs facing inward?
2. Can you form the trefoil knot?
3. What about the figure 8 knot?

---
## 2. What is Shape (in Data Science)?

Write down your answer to the question: what is shape?  Write three words that
come to mind [in this Slido poll](https://app.sli.do/event/jq8wgrEpgBwThxABcHRxja)

Discuss with your neighbors.

<details>
<summary>See the Answer</summary>
<br>
<pre style="background-color:lightcoral">
From Meriam Webster:
<ul>
  <li>The visible makeup characteristic of a particular item or kind of items</li>
  <li>Spatial form or contour</li>
  <li>A standard or universally recognized spatial form</li>
</ul>
<br>
From Brittany: shape is a way of putting meaning or interpretability to a set. 
<br>
</pre>
</details>

Often, when we think of shapes, we think of their **geometry**: length, witdth,
angles, curvature, area, etc.  In this workshop, we explore the **topology** of
shape/data.  Topology studies the connectivity between and among data.

---
## 3. Koenigsberg

The bridges of Koenigsberg:

![bridges of Koenigsberg](https://upload.wikimedia.org/wikipedia/commons/5/5d/Konigsberg_bridges.png)

![Koenigsberg](https://github.com/compTAG/t4ds/blog/gh-pages/assets/images/bridges.jpg)

<details>
<summary>See the Answer</summary>
<br>
<pre style="background-color:lightcoral">
<br>
![bridges with map](https://github.com/compTAG/t4ds/blog/gh-pages/assets/images/bridges-map-and-graph.png)
![just map](https://github.com/compTAG/t4ds/blog/gh-pages/assets/images/bridges-graph.png)
<br>
</details>

---
## 4. Are Two Shapes the Same or Different?

This is a question that we will come back to tomorrow.

First, we need to understand what a **topological space** is.  It is a set
(e.g., the real line) with a notion of what **open sets** are that follow the
following two rules:

1. The intersection of a finite number of open sets is open.
2. Any (potentially infinite) union of open sets is open.

An example is the real line, with open sets as we know them (in fact, this is
called the standard topology on the reals).  From now on, when we say "shape",
we mean a topological space.

### Maps and Homeomorphisms

If we have an understanding of open sets, we can define a **continuous map** as:

> $ f : A \to B$ is continuous iff for all open sets $U$ in $B$, $f^{-1}(U)$ is open in $A$.

The strongest form of shape equivalence is that of a homeomorphism:

> Two shapes, A and B, are homeomorphic iff there exists a bi-continuous
> bijective map $H:A \to B$.

What this means is the perspective of $a \in A$ "looks like" the perspective of
$b \in B$.  In other words, the two shapes are "the same" if all you care about
are the neigghborhoods.

[![isotopic](https://commons.wikimedia.org/wiki/File:Mug_and_Torus_morph_frame.png)](https://commons.wikimedia.org/wiki/File:Mug_and_Torus_morph.gif#/media/File:Mug_and_Torus_morph.gif)

### Topological Invariants

Can we explore every map $A \to B$? Nope!  Instead, we study topological
invariants.

The first invariant we consider is that of a homotopy.

> TODO: define homotopy

The isotopy we saw above of the donut and the coffee mug is a homotopy.  Also,
deformation retracts (think: continuously morphing by contracting) are homotopies!

Herea are a couple examples:

* [deformation retract of a punctured torus](https://www.youtube.com/watch?v=j2HxBUaoaPU)
* [homotopy between two curves](https://www.youtube.com/watch?v=o7p9AJ5VCHo)

The problem with classifying shapes up to homotopy is that they are $\#P$-hard
to compute.  So, we need to be able to compute some things.

The **Euler characteristic** of a shape is found by first representing the shape
as a cellular structure (for us, this means finding a parttition into vertices,
edges (that do not include their endpoints), and triangles or squares (that do
not include their boundaries). 

What is the Euler characteristic of the sphere?

<details style="color:red">
<br>
<summary>See the Answer</summary>
<br>
<pre style="background-color:lightcoral">
    The Euler characteristic of the sphere is 2.  One topological model of the
    sphere is that of a box: it has 8 corners, 12 edges, and 6 squares. 8-12+6=2.
    Alternatively, we can think of it as the surface of a tetrahedron, which has
    4 vertices, 6 edges, and 4 triangles. 4-6+4+2.

    Fun fact: the sphwere is the one-point "compactification" of the plane
    $\mathbb{R}^2$.  Add one point (equal to the limit point in every direction) and we
    can construct a homeomorphism between $\mathbb{S}^2$ and $\mathbb{R}^1$.
</pre>
<br>
</details>

Finally, we come to **homology**, a topological invaraint that we'll use quite a
bit in our exploration.

> TODO: define homology

TODO: a question on homology

---
## 5. Wrapping Up

Congrats! We've made it through the first session.  A quick recap:

> - We made a human knot, unknot, or link! 
> - We discussed the meaning of shape.
> - We saw an example where an everyday problem (finding a walking path
>   satisfying some constraints) can be turned into a graph problem.
> - We defined some topological invariants (more on these later ...)

We have a break coming up.  If you have any "muddy points" write them down and
post it to the "muddy point board".

### Credits

* The human knot is a popular ice breaking game (it even has a [Wikipedia][2]
  page!)  However, most do not realize that realizing the unknot is not always
  feasible. Whoops!  See a [math blog post][3] explaining.
* Koenigsberg Bridge photo (teaser): [Wikimedia][1], CC BY-SA 3.0
* Euler's maps: from Euler's solution to the Bridges of Koenigsberg problem in
  Solutio Problematis ad Geometriam Situs Pertinentis (The solution of a problem
  Relating to the Geometry of Position), [Euler Arxiv, Enestrom Number 53][4].

[1]: <https://upload.wikimedia.org/wikipedia/commons/5/5d/Konigsberg_bridges.png> (bridges of Koenigsberg)
[2]: https://en.wikipedia.org/wiki/Human_knot 
[3]: https://mathlesstraveled.com/2010/11/19/the-mathematics-of-human-knots/
[4]: <https://scholarlycommons.pacific.edu/euler-works/53/> 
