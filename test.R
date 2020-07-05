library(spacyr)
library(stringr)
library(jsonlite)
library(shiny)
library(dplyr)

source("r/build_tree.R")
source("r/utils.R")
source("r/use_hierplane.R")

spacyr::spacy_initialize()

txt <- "i paid $90 for this piece of paper"

tree <- build_tree(txt)

ui <- fluidPage(
  use_hierplane(),
  shinyjs::useShinyjs()
)

server <- function(input, output, session) {
  hierplane_js(tree$t_json)
}

shinyApp(ui, server)

