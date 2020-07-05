spacy_tibble <- function(txt, ...) {
  tibble::as_tibble(spacyr::spacy_parse(
    x = txt,
    entity = TRUE,
    dependency = TRUE,
    tag = TRUE,
    additional_attributes = c(
      "ent_type_",
      "dep_",
      "is_currency",
      "like_url",
      "like_email",
      ...
    )
  ))
}

transform_logical <- function(sp_tib) {
  for (bool_col in which(sapply(sp_tib, is.logical))) {
    bool_name <- names(sp_tib)[bool_col]
    sp_tib[[bool_col]] <- if_else(sp_tib[[bool_col]],
                                  gsub(".*_", "", bool_name),
                                  "")
  }
  sp_tib
}



pull_word_span <- function(txt, word_id) {

  tokens <- spacyr::spacy_tokenize(txt)[[1]]

  word <- tokens[word_id]


  # present symbol from being interpreted as regex
  is_punct <- grepl("^[[:punct:]]$", word)
  if (is_punct) word <- paste0("[", word, "]")

  # count all prior occurences
  which_loc <- 1 + str_count(paste(tokens[1:word_id - 1],
                                      collapse = " "), word)
  word_locs <- stringr::str_locate_all(txt, word)[[1]][which_loc, ]

  list(start = word_locs[["start"]] - 1,
       end = word_locs[["end"]])

}

pull_attr <- function(sp_tib, attributes) {
  sapply(attributes, function(x) sp_tib[[x]]) %>%
    unlist %>%
    as.vector %>%
    .[nchar(.) > 0] %>%
    as.list
}

hierplane_js <- function(x, theme = "light") {
  shinyjs::runjs(paste0("const tree = ", x, ";
                        hierplane.renderTree(tree, { target: '#hierplane_output', theme: '",
                        theme,"' });"))
}
