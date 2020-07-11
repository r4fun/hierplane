invisible(lapply(list.files("R", full.names = T), source))

a <- as.data.frame(dplyr::tribble(
  ~parent_id,  ~child_id,    ~child,      ~node_type,     ~link,      ~height,  ~age,
  "Bob",       "Bob",        "Bob",       "gen1",         "ROOT",     "100 cm", "60 yo",
  "Bob",       "Angelica",   "Angelica",  "gen2",         "daughter", "100 cm", "30 yo",
  "Bob",       "Eliza",      "Eliza",     "gen2",         "daughter", "90 cm",  "25 yo",
  "Bob",       "Peggy",      "Peggy",     "gen2",         "daughter", "50 cm",  "10 yo",
  "Angelica",  "John",       "John",      "gen3",         "son",      "10 cm",  "0.5 yo"
))

hierplane(a, title = "Family Tree", settings = construct_settings(attributes = c("height", "age")))
hierplane_spacy("Bob has three daughters and a grandson.")

# ----
# styles from list

node_type_to_style <- list("gen1" = c("color1", "strong"), "gen2" = list("color6"), "gen3" = list("placeholder"))
link_to_positions <- list(daughter = "down", son = "right")
link_name_to_label <- list(daughter = "D", son = "S")
settings <- hierplane_settings(attributes = c("height", "age")) %>%
  add_styles(
    node_type_to_style = node_type_to_style,
    link_to_positions = link_to_positions,
    link_name_to_label = link_name_to_label
  )

hierplane(a, title = "Family Tree", settings = settings, theme = "dark")

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

# ----
# styles from df
node_type_to_style <- data.frame(item = c("gen1", "gen2", "gen3"),
                                 settings = c(list("color1"),
                                              list("color3"),
                                              list("color5")))
link_to_positions <- data.frame(item = c("daughter", "son"),
                                settings = c("down", "right"))
link_name_to_label <- data.frame(item = c("daughter", "son"),
                                 settings = c("D", "S"))
settings <- hierplane_settings(attributes = c("height", "age"),
                               node_type_to_style = node_type_to_style,
                               link_to_positions = link_to_positions,
                               link_name_to_label = link_name_to_label)

hierplane(a, title = "Family Tree", settings = settings)

