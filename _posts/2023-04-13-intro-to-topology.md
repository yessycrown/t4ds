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

## 0. Getting Started

We are glad that you are here with us for this workshop!  The first activity is
hands-on, literally.

We will stand in a circle.  Then, raise right hands and grab someone's hand from
across the circle.  Then, raise left hands and grab someone else's hand.  Can we
unknot ourselves?

Knot theory is fun!  If we can unknot ourselves and are one connected component,
then we have formed **the unknot**, or the most basic/fundamental of all knots.
If we created two cycles (each unknotted or not), then we have formed a link.

[![unknotting](https://img.youtube.com/vi/UmF0-Tz1oWc/hqdefault.jpg)](https://www.youtube.com/watch?v=UmF0-Tz1oWc)

Other knots that are interesting (and not equivelent to the unknot) are the
trefoil knot and the figure 8 knot.

TODO:figure

Variants to try (in smaller groups):

1. If you start facing each other and hold your neighbor's hands, can you
   turn your circle "inside-out" and have your backs facing inward?
2. Can you form the trefoil knot?
3. What about the figure 8 knot?

## 1. What is Shame (in Data Science)?

Write down your answer to the question: what is shape?  Write three words that
come to mind [in this Slido poll](https://app.sli.do/event/jq8wgrEpgBwThxABcHRxja)

Discuss with your neighbors.

<details>
<summary>A: Meriam Webster</summary>
<br>
<ul>
  <li>The visible makeup characteristic of a particular item or kind of items</li>
  <li>Spatial form or contour</li>
  <li>A standard or universally recognized spatial form</li>
</ul> 
</details>

<details>
<summary>A: Brittany</summary>
<br>
Shape is your interpretation of the connections in data.
</details>

Often, when we think of shapes, we think of their **geometry**: length, witdth,
angles, curvature, area, etc.  In this workshop, we explore the **topology** of
shape/data.  Topology studies the connectivity between and among data.

## 2. Koenigsberg

The [bridges of Koenigsberg][1]

## Wrapping Up

TODO

### Credits

* The human knot is a popular ice breaking game (it even has a [Wikipedia][2]
  page!)  However, most do not realize that realizing the unknot is not always
  feasible. Whoops!  See a [math blog post][3] explaining.
* Koenigsberg Bridge photo: [Wikimedia][1]

[1]: https://upload.wikimedia.org/wikipedia/commons/5/5d/Konigsberg_bridges.png (bridges of Koenigsberg)
[2]: https://en.wikipedia.org/wiki/Human_knot 
[3]: https://mathlesstraveled.com/2010/11/19/the-mathematics-of-human-knots/
