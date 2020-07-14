library(dplyr)

starwars_clean <- starwars %>%
  tidyr::unnest(vehicles, keep_empty = T) %>%
  tidyr::unnest(starships, keep_empty = T) %>%
  tidyr::unnest(films, keep_empty = T) %>%
  mutate_if(is.character, ~tidyr::replace_na(., "unknown")) %>%
  mutate(timeline = case_when(
    films %in% c("The Phantom Menace",
                 "Attack of the Clones",
                 "Revenge of the Sith") ~ "Prequel",
    films %in% c("A New Hope",
                 "The Empire Strikes Back",
                 "Return of the Jedi") ~ "Original",
    films %in% c("The Force Awakens") ~ "Sequel"
  ),
  episode = case_when(
    films %in% "The Phantom Menace" ~ "Ep 1",
    films %in% "Attack of the Clones" ~ "Ep 2",
    films %in% "Revenge of the Sith" ~ "Ep 3",
    films %in% "A New Hope" ~ "Ep 4",
    films %in% "The Empire Strikes Back" ~ "Ep 5",
    films %in% "Return of the Jedi" ~ "Ep 6",
    films %in% "The Force Awakens" ~ "Ep 7"
  ),
  film_year = case_when(
    films %in% "The Phantom Menace" ~ "1999",
    films %in% "Attack of the Clones" ~ "2002",
    films %in% "Revenge of the Sith" ~ "2005",
    films %in% "A New Hope" ~ "1977",
    films %in% "The Empire Strikes Back" ~ "1980",
    films %in% "Return of the Jedi" ~ "1983",
    films %in% "The Force Awakens" ~ "2015"
  ))


starwars_root <- data.frame(
  parent_id = "Star Wars Movies",
  child_id = "Star Wars Movies",
  child = "Star Wars Movies",
  link = "ROOT",
  node_type = "ROOT"
)

starwars_layer0 <- starwars_clean %>%
  distinct(timeline) %>%
  mutate(parent_id = "Star Wars Movies",
         child_id = timeline,
         child = timeline,
         link = timeline,
         node_type = timeline)

starwars_layer1 <- starwars_clean %>%
  distinct(films, timeline, episode, film_year) %>%
  mutate(parent_id = timeline,
         child_id = episode,
         child = films,
         link = episode,
         node_type = timeline,
         attribute1 = film_year) %>%
  distinct()

starwars_layer2 <- starwars_clean %>%
  filter(!starships %in% "unknown") %>%
  mutate(parent_id = episode,
         child_id = starships,
         child = starships,
         link = "ship",
         node_type = "ship") %>%
  group_by(parent_id, child_id, child,
           link, node_type) %>%
  summarize(attribute2 = list(unique(name)))

hp_starwars <- bind_rows(starwars_root,
                         starwars_layer0,
                         starwars_layer1,
                         starwars_layer2)

usethis::use_data(hp_starwars, overwrite = TRUE)
