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
  "cat cats CAT CATTTTT",
  "I like cats. She likes dogs? He likes turtles."
)
max_sents <- 10
ui <- fluidPage(
  use_hierplane(),
  shinyjs::useShinyjs(),
  selectInput(inputId = "text", label = "pick sentence", choices = txt),
  textInput(inputId = "user_text", label = "or enter your own text",
            placeholder = "enter text to parse"),
  selectInput(inputId = "theme", label = "pick theme",
              choices = c("light", "dark")),
  actionButton(inputId = "go", label = "Go!"),
  br(),
  lapply(1:max_sents, function(i) div(id = paste0("plane", i)))
)


server <- function(input, output, session) {
  observeEvent(input$go, {
    cur_txt <- ifelse(nchar(input$user_text) == 0,
                      input$text,
                      input$user_text)
    tree <- lapply(get_sents(cur_txt), build_tree)[1:max_sents]
    lapply(1:length(tree),
           function(i) {
             cur_div <- paste0("plane", i)

             hierplane_js(tree[[i]]$t_json,
                          div_name = cur_div,
                          theme = input$theme)
           })
  })

}

shinyApp(ui, server)

