invisible(lapply(list.files("R", full.names = T), source))

a <- as.data.frame(dplyr::tribble(
  ~parent_id,  ~child_id,    ~child,      ~node_type,     ~link,      ~height,  ~age,
  "Bob",       "Bob",        "Bob",       "gen1",         "ROOT",     "100 cm", "60 yo",
  "Bob",       "Angelica",   "Angelica",  "gen2",         "daughter", "100 cm", "30 yo",
  "Bob",       "Eliza",      "Eliza",     "gen2",         "daughter", "90 cm",  "25 yo",
  "Bob",       "Peggy",      "Peggy",     "gen2",         "daughter", "50 cm",  "10 yo",
  "Angelica",  "John",       "John",      "gen3",         "son",      "10 cm",  "0.5 yo",
  "Bob",       "Jess",       "Jess",      "ext",          "cousin",   "70 cm",  "150 yo"
))

hierplane(a, title = "Family Tree",
          settings = hierplane_settings(attributes = c("height", "age")))
hierplane_spacy("Bob has three daughters and a grandson.")

# ----
# styles from list
library(magrittr) # for pipe
node_type_to_style <- list("gen1" = c("color1", "strong"),
                           "gen2" = list("color6"),
                           "gen3" = list("color4"),
                           "ext" = list("placeholder"))
link_to_positions <- list(cousin = "right")
link_name_to_label <- list(daughter = "dtr", son = "son", cousin = "cuz")
settings <- hierplane_settings(attributes = c("height", "age")) %>%
  add_styles(
    node_type_to_style = node_type_to_style,
    link_to_positions = link_to_positions,
    link_name_to_label = link_name_to_label
  )

hierplane(a, title = "Family Tree", settings = settings, theme = "dark")

# check styling input and show warnings for unmatched values
# hierplane will still plot, but unmatched are ignored hence the warnings
# TLDR bad LHS assignments throw warnings
node_type_to_style <- list("gen1" = c("color1", "strong", "color2"),
                           "gen2" = list("color6"),
                           "gen2" = list("color4"), # repeat label
                           "ext" = list("placeholder"))
link_to_positions <- list(cousssssin = "right") # bad name
link_name_to_label <- list(daughter = "D", son = "S", son = "SS") # repeat label
settings <- hierplane_settings(attributes = c("height", "age")) %>%
  add_styles(
    node_type_to_style = node_type_to_style,
    link_to_positions = link_to_positions,
    link_name_to_label = link_name_to_label
  )

hierplane(a, title = "Family Tree", settings = settings, theme = "dark")

# check styling input and throw error mismatched styling options
# hierplane will fail to plot hence the errors
# TLDR bad RHS assignments throw errors

## example 1
node_type_to_style <- list("gen1" = c("color1", "strong", "color2"),
                           "gen2" = list("colr6"), # bad option
                           "ext" = list("placeholder"))
settings <- hierplane_settings(attributes = c("height", "age")) %>%
  add_styles(
    node_type_to_style = node_type_to_style
  )

hierplane(a, title = "Family Tree", settings = settings, theme = "dark")

## example 2
link_to_positions <- list(cousssssin = "top") # bad option
settings <- hierplane_settings(attributes = c("height", "age")) %>%
  add_styles(
    link_to_positions = link_to_positions
  )

hierplane(a, title = "Family Tree", settings = settings, theme = "dark")

# spacy styling demo
node_type_to_style <- list(ROOT = list("color1", "strong"),
                           dobj = list("color6"),
                           nsubj = list("color2"),
                           punct = list("placeholder"))
link_to_positions <- list(nsubj = "left", dobj = "right")
link_name_to_label <- list(nsubj = "subj", dobj = "obj")
settings <- spacy_default() %>%
  add_styles(node_type_to_style = node_type_to_style,
             link_to_positions = link_to_positions,
             link_name_to_label = link_name_to_label)

hierplane_spacy("Bob has three daughters and a grandson.",
                settings = settings, theme = "dark")

# bad nesting that is fixed automatically in format_style
node_type_to_style <- list(ROOT = c("color1", "strong"),
                           dobj = list("color6"),
                           nsubj = "color2",
                           punct = "placeholder")
settings <- spacy_default() %>%
  add_styles(node_type_to_style = node_type_to_style,
             link_to_positions = link_to_positions,
             link_name_to_label = link_name_to_label)

hierplane_spacy("Bob has three daughters and a grandson.",
                settings = settings, theme = "dark")
