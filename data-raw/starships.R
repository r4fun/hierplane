library(dplyr)

starwars_sup <- tribble(
  ~films,                    ~episode,  ~film_year,  ~timeline,
  "The Phantom Menace",      "Ep 1",    "1999",      "Prequel",
  "Attack of the Clones",    "Ep 2",    "2002",      "Prequel",
  "Revenge of the Sith",     "Ep 3",    "2005",      "Prequel",
  "A New Hope",              "Ep 4",    "1977",      "Original",
  "The Empire Strikes Back", "Ep 5",    "1980",      "Original",
  "Return of the Jedi",      "Ep 6",    "1983",      "Original",
  "The Force Awakens",       "Ep 7",    "2015",      "Sequel"
)

starwars_clean <- starwars %>%
  tidyr::unnest(vehicles, keep_empty = T) %>%
  tidyr::unnest(starships, keep_empty = T) %>%
  tidyr::unnest(films, keep_empty = T) %>%
  mutate_if(is.character, ~tidyr::replace_na(., "unknown")) %>%
  left_join(starwars_sup, by = "films") %>%
  filter(!starships %in% "unknown")



starships <- starwars_clean %>%
  add_root("Star Wars Movies") %>%
  add_layer(child_col = "timeline",
            link_col = "timeline",
            node_type_col = "timeline") %>%
  add_layer( child_col = "films",
            link_col = "episode",
            node_type_col = "timeline",
            attribute_cols = "film_year") %>%
  add_layer( child_col = "starships",
            link_vals = "ship",
            node_type_vals = "ship",
            attribute_cols = "name")


usethis::use_data(starships, overwrite = TRUE)
