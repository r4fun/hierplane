#' Render a Hierplane from Text using Spacy
#' @param txt A sentence to be parsed and rendered as hierplane
#' @param settings A hierplane settings object.
#' @param ... Parameters to pass to `hierplane()`
#'
#' @md
#'
#' @export

hierplane_spacy <- function(txt, settings = spacy_default(), ...) {
  x <- transform_logical(spacy_df(txt))
  hierplane(x = x, settings = settings, title = txt, ...)
}

spacy_df <- function(txt) {
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
      "like_email"
    )
  )
}

spacy_attributes <- function() c("ent_type_", "pos", "is_currency", "like_url", "like_email")

spacy_default <- function() {
  list(
    type = "spacy",
    parent_id = "head_token_id",
    child_id = "token_id",
    child = "token",
    node_type = "dep_",
    link = "dep_",
    root_tag = "ROOT",
    attributes = spacy_attributes())
}

pull_word_span <- function(txt, word_id) {
  tokens <- unlist(spacyr::spacy_tokenize(txt), use.names = FALSE)
  word <- tokens[word_id]

  # prevent symbol from being interpreted as regex
  is_punct <- grepl("^[[:punct:]]$", word)
  if (is_punct) word <- paste0("[", word, "]")

  # count all prior occurrences
  which_loc <- 1 + stringr::str_count(paste(tokens[1:word_id - 1], collapse = " "), word)
  word_locs <- stringr::str_locate_all(txt, word)[[1]][which_loc, ]

  list(
    start = word_locs[["start"]] - 1,
    end = word_locs[["end"]]
  )
}


get_sents <- function(txt, delims = c(".", "?", "!")) {
  delims <- paste(paste0("\\", delims), collapse = "|")
  unlist(strsplit(txt, paste0("(?<=", delims,")\\s(?=[A-Z])"), perl = TRUE))
}
