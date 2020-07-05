library(spacyr)
library(stringr)
library(jsonlite)
library(shiny)
library(dplyr)

source("r/build_tree.R")
source("r/utils.R")
source("r/use_hierplane.R")

spacyr::spacy_initialize()

txt <- c(
  "i paid $90,000 for this piece of paper",
  "tylurp just completed a $2,000,000 transaction addressed to nigerian.prince@notscam.com. ",
  "look @ him go",
  "cat cats CAT CATTTTT"
)


ui <- fluidPage(
  use_hierplane(),
  shinyjs::useShinyjs(),
  selectInput(inputId = "text", label = "pick sentence", choices = txt),
  selectInput(inputId = "theme", label = "pick theme",
              choices = c("light", "dark")),
  div(id = "hierplane_output")
)

server <- function(input, output, session) {
  observeEvent(c(input$text,
                 input$theme), {

    tree <- build_tree(input$text)
    hierplane_js(tree$t_json, theme = input$theme)

  })

}

shinyApp(ui, server)

