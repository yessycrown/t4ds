# R package TDA tutorial

[![Build Status](https://travis-ci.com/jordans1882/rpackage_tutorials.svg?branch=master)](https://travis-ci.com/jordans1882/rpackage_tutorials)

## Developing new tutorials

Tutorials are written in Rmarkdown and compiled into a website using
[jekyll](https://jekyllrb.com/) and the R package servr. The simplest way to
get going writing your own is to clone the repository and open the
`rpackage_tutorials.Rproj` file in Rstudio. Opening the R project file will
automatically load the environment from the .Rprofile file in the root folder of
the directory. When opening the environment, R will automatically load (and
install if needed) the TDA package in R. It also loads a number of useful
functions for generating and serving the tutorials. First, we want to generate
and serve the current version of the tutorials. We first need to make sure we
have the bundler and jekyll ruby gems installed. Setting up these ruby gems is
easy!! From the command line run in the root directory of the project repo, run:

     $ gem install bundler jekyll
     $ bundle install

Now, in RStudio, first run the following two commands to generate and serve the
tutorial files:

      `gen_blog()`
      `serve_blog()`

If all goes well, the server should start and you should see something like the
following output:

    Configuration file: .../rpackage_tutorials/_config.yml
                Source: .../rpackage_tutorials
           Destination: .../rpackage_tutorials/_site
     Incremental build: disabled. Enable with --incremental
          Generating...
           Jekyll Feed: Generating feed for posts
                        done in 0.464 seconds.
     Auto-regeneration: enabled for '.../rpackage_tutorials'
        Server address: http://127.0.0.1:4000/rpackage_tutorials/
      Server running... press ctrl-c to stop.

The blog should automatically show up in the viewer pane of RStudio and you can
navigate what the tutorials webpage should look like when changes are commited.

You can also enter the value for `Server address` into your browser and you
should see the site that you are creating.

To make a new post create a file in `_posts` with named formmatted as
`<date>_<topic>.md`. At the beginning of the file add a header with the
following:

    ---
    layout: "post"
    title: "Title of your tutorial"
    author: "Your name"
    ---

    # Name of your tutorial

    .... then add your content ....

That is it, everything you make a change, jekyll will recompile your tutorial
and you can reload your site.

Issue a PR whenever you are ready to start the discussion and thank you for
collaborating!!


