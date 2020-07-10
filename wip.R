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

node_type_to_style <- list(gen1 = "color1", gen2 = "color5", gen3 = "color4", gen3 = "color5")

settings <- construct_settings(attributes = c("height", "age"),
                               node_type_to_style = node_type_to_style)
check_style(a, settings, "node_type_to_style", "node_type")

link_to_position <- list(daughter = "color1", son = "color5")
