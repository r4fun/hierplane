library(shiny)
library(spacyr)
library(dplyr)
library(stringr)

Sys.setenv(RETICULATE_PYTHON = "/Users/tylerlittlefield/opt/miniconda3/envs/spacy_condaenv/bin/python")
spacyr::spacy_initialize()

hierplane(
  tree = build_tree("To paraphrase provocatively machine learning is statistics minus any checking of models and assumptions")$t_json
)

# ui <- fluidPage(
#   hierplaneOutput("tree")
# )
#
# server <- function(input, output, session) {
#   output$tree <- renderHierplane(
#     hierplane(
#       tree = build_tree("sam likes boats")$t_json
#     )
#   )
# }
#
# shinyApp(ui, server)
