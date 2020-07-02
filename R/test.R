library(shiny)
library(spacyr)
library(dplyr)
library(tidyr)

# this part isn't reproducible, pick YOUR path, not mine
Sys.setenv(RETICULATE_PYTHON = "/Users/tylerlittlefield/opt/miniconda3/envs/spacy_condaenv/bin/python")
spacy_initialize()

source("R/utils.R")

txt <- "Sam likes boats and cars"
x <- spacy_tibble(txt)

df_root <- pull_tree_data(
  x = x,
  root_col = "dep_rel",
  root_val = "ROOT",
  type = "root"
)

df_child <- pull_tree_data(
  x = x,
  root_col = "dep_rel",
  root_val = "ROOT",
  type = "child"
)

mylist <- parse_hierplane(
  txt = txt,
  root = df_root,
  children = df_child,
  nodetype = "tag",
  word = "token",
  link = "pos",
  attributes = "ent_type_",
  word_id = "token_id",
  child_id = "head_token_id",
  parent_id = "token_id"
)

out <- jsonlite::toJSON(
  x = mylist,
  auto_unbox = TRUE,
  pretty = TRUE
)

ui <- fluidPage(
  hierplane:::use_hierplane(),
  shinyjs::useShinyjs()
)

server <- function(input, output, session) {
  hierplane_js(out)
}

shinyApp(ui, server)

