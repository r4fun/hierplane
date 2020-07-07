spacy_df <- function(txt, ...) {
  spacyr::spacy_parse(
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
  )
}

parse_root <- function(x) {
  list(
    id = x$token_id[x$dep_rel %in% "ROOT"],
    dat = x[x$dep_rel %in% "ROOT", ]
  )
}

parse_children <- function(x, txt, root_id) {
  x <- x[!x$head_token_id == x$token_id, ]
  x$sort_order <- ifelse(x$head_token_id %in% root_id, 0, 1)
  x$txt <- txt
  x <- x[with(x, order(x$sort_order, x$token_id)), ]
  x[c("head_token_id", "token_id", c("doc_id", "sentence_id", "token", "lemma", "pos",
                                     "tag", "dep_rel", "entity", "ent_type_", "dep_",
                                     "is_currency", "like_url", "like_email",
                                     "sort_order", "txt"))]
}

get_sents <- function(txt, delims = c(".", "?", "!")) {
  delims <- paste(paste0("\\", delims), collapse = "|")
  unlist(strsplit(txt, paste0("(?<=", delims,")\\s(?=[A-Z])"), perl = TRUE))
}

transform_logical <- function(x) {
  for (bool_col in which(sapply(x, is.logical))) {
    bool_name <- names(x)[bool_col]
    x[[bool_col]] <- ifelse(
      test = x[[bool_col]],
      yes = gsub(".*_", "", bool_name),
      no = ""
    )
  }
  x
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
