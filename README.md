
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hierplane

<!-- badges: start -->

[![R build
status](https://github.com/tyluRp/hierplane/workflows/R-CMD-check/badge.svg)](https://github.com/tyluRp/hierplane/actions)
[![Codecov test
coverage](https://codecov.io/gh/tyluRp/hierplane/branch/master/graph/badge.svg)](https://codecov.io/gh/tyluRp/hierplane?branch=master)
<!-- badges: end -->

:warning: Work in progress :warning:

The goal of `hierplane` is to visualize trees. This is an HTML widget
that uses source code from the [original javascript
library](https://github.com/allenai/hierplane). A handful of functions
are provided that allow R users to render hierplanes in shiny.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("tyluRp/hierplane")
```

## Example

Rendering a hierplane requires you to: 1. Create a hierplane object with
`hp_` functions 2. Render the hierplane with `hierplane()`

A hierplane object can be created from different input data. At the time
of writing this, a `data.frame` or string:

``` r
library(hierplane)

# requires spacyr package
hp_spacyr("Sam likes boats")
#> <hierplane_tree object: from hp_spacyr>
```

With this, we can render a hierplane in shiny:

``` r
library(hierplane)
library(shiny)

ui <- fluidPage(
  hierplaneOutput("hplane")
)

server <- function(input, output, session) {
  output$hplane <- renderHierplane({
    x <- hp_spacyr("Sam likes boats")
    hierplane(x)
  })
}

shinyApp(ui, server)
```

<img src="man/figures/hierplane_spacyr.png" width="100%" />

While hierarchical data isn’t common in a `data.frame` centric language
like R, we are working on a way to parse a `data.frame` to hierplane
ready data. This works by using `hp_dataframe()`:

``` r
df <- structure(
  list(
    parent_id = c("Bob", "Bob", "Bob", "Bob", "Angelica", "Bob"),
    child_id = c("Bob", "Angelica", "Eliza", "Peggy", "John", "Jess"),
    child = c("Bob", "Angelica", "Eliza", "Peggy", "John", "Jess"),
    node_type = c("gen1", "gen2", "gen2", "gen2", "gen3", "ext"),
    link = c("ROOT", "daughter", "daughter", "daughter", "son", "cousin"),
    height = c("100 cm", "100 cm", "90 cm", "50 cm", "10 cm", "70 cm"),
    age = c("60 yo", "30 yo", "25 yo", "10 yo", "0.5 yo", "150 yo")
  ),
  row.names = c(NA, -6L),
  class = c("data.frame")
)

df_dataframe <- hp_dataframe(
  .data = df,
  title = "Family",
  settings = hierplane_settings(
    attributes = c("height", "age")
  )
)

df_dataframe
#> <hierplane_tree object: from hp_dataframe>
```

<img src="man/figures/hierplane_dataframe.png" width="100%" />

## Acknowledgements

  - [`allenai/hierplane`](https://github.com/allenai/hierplane): The
    original javascript library that this package uses
  - [`DeNeutoy/spacy-vis`](https://github.com/DeNeutoy/spacy-vis): Spacy
    models using hierplane
