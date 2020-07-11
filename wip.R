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
hierplane_spacy("Bob has three daughters and a grandson.", theme = "dark")

# ----
# styles from list

node_type_to_style <- list("gen1" = c("color1", "strong"), "gen2" = list("color6"), "gen3" = list("placeholder"))
link_to_positions <- list(daughter = "down", son = "right")
link_name_to_label <- list(daughter = "D", son = "S")
settings <- construct_settings(attributes = c("height", "age"),
                               node_type_to_style = node_type_to_style,
                               link_to_positions = link_to_positions,
                               link_name_to_label = link_name_to_label)

hierplane(a, title = "Family Tree", settings = settings)

# ----
# styles from df
node_type_to_style <- data.frame(item = c("gen1", "gen2", "gen3"),
                                 settings = c("color1", "color3", "color5"))
link_to_positions <- data.frame(item = c("daughter", "son"),
                                settings = c("down", "right"))
link_name_to_label <- data.frame(item = c("daughter", "son"),
                                 settings = c("D", "S"))
settings <- construct_settings(attributes = c("height", "age"),
                               node_type_to_style = node_type_to_style,
                               link_to_positions = link_to_positions,
                               link_name_to_label = link_name_to_label)

hierplane(a, title = "Family Tree", settings = settings)

