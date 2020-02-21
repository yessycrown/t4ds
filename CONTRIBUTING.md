# Dependencies

This website is build using Rmarkdown documents for development of the workshops
and [Jekyll](https://jekyllrb.com/) for building and serving the website. As a
dependency for building the website, you will need:

 - [Git](https://git-scm.com/)
 - [Ruby](https://www.ruby-lang.org/en/)
 - [RubyGems](https://rubygems.org/)
 - [R](https://cran.r-project.org/)
 - [Jekyll](https://jekyllrb.com/)
 - [Bundler](https://bundler.io/)

Follow the instructions for your system on each of these sites to obtain the
first four dependencies. The last two are ruby gems and can be obtained by
running the command:

```bash
gem install bundler
gem install jekyll
```

Once you have each of these, you will need to make sure your `PATH` environment
variable is set so that it can find your ruby gems . This may have been done
automatically when you installed RubyGems, but double check via the method for
your operating system.

You will also need to make sure that when R is loaded it also has access to this
`PATH` environment variable. Sometimes it might use a `PATH` associated to a
different shell, so it's important to double check this if you run into any
errors that says R can't find bundle or jekyll. You can double check what R
thinks your path environment variable is by running:

```r
Sys.getenv("PATH")
```

If you don't have your ruby gems folder set in your `PATH` environment variable
in R, find and copy your system `PATH` environment variable and in the
`.Rprofile` file in your **home** directory, put the following line of code:

```r
Sys.setenv(PATH = "your full PATH variable here")
```

The `.Rprofile` file in the project root will source this file.

# Development

A number of helper functions for building and serving the website are loaded via
the `.Rprofile` file located in the project root directory. Use the
`new_draft()` function to create a skeleton of a workshop:

```r
new_draft("my_workshop_name.r")
```

This will create a folder with a skeleton of a workshop in the `_drafts` folder.
Now, you can edit this file to make the workshop. But before editing the file,
make sure that you can build and serve the drafts. First run

```r
gen_drafts()
```

to have




TODO: write something about bibiliography setup
