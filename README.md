
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hierplane

<!-- badges: start -->

<!-- badges: end -->

The goal of `hierplane` is to visualize tokenized, parsed, and annotated
tokens returned by calling `spacyr::spacy_parse()`. This is an
htmlwidget that was made possible thanks to the original javascript
library: <https://github.com/allenai/hierplane>.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("tyluRp/hierplane")
```

Additionally, you will need to set up `spacyr` to get things working.
Please take a look here: <https://github.com/quanteda/spacyr>.

## Example

Rendering a hierplane is as simple as providing a string of text:

``` r
library(hierplane)

# initilize spacy
spacyr::spacy_initialize()

# render in the RStudio viewer
hierplane("Welcome to hierplane")
```

And with shiny you just need to use the output and render functions:

``` r
library(hierplane)
library(shiny)

# initilize spacy
spacyr::spacy_initialize()

ui <- fluidPage(
  hierplaneOutput("hplane")
)

server <- function(input, output, session) {
  output$hplane <- renderHierplane({
    hierplane("Welcome to hierplane")
  })
}

shinyApp(ui, server)
```

<img src="man/figures/hierplane-example.png" width="100%" />
