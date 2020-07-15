#' Create a hierplane object using spacyr
#'
#' Creating a hierplane object from a string is possible by using the `spacyr`
#' package. More specifically, we rely on `spacyr::spacy_parse()` to tokenize and
#' tag the string provided. Note that this functionality requires the `spacyr`
#' package.
#'
#' @param .data A string of text.
#' @param settings Assign your dataframes columns to hierplane variables.
#' @param styles Assign styles to hierplane.
#' @param ... Additional parameters to pass to `spacyr::spacy_parse`
#' @md
#' @export
hp_spacyr <- function(.data, settings = spacyr_default(), styles = NULL, ...) {
  requireNamespaceQuietStop("spacyr")
  x <- build_tree(
    x = transform_logical(spacyr_df(.data, ...)),
    title = .data,
    settings = settings,
    styles = styles
  )
  structure(x, class = c("hierplane_tree", "hierplane_spacyr", class(x)))
}

spacyr_df <- function(txt, ...) {
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
    ),
    ...
  )
}

spacyr_attributes <- function() c("ent_type_", "pos", "is_currency", "like_url", "like_email")

spacyr_default <- function() {
  list(
    type = "spacyr",
    parent_id = "head_token_id",
    child_id = "token_id",
    child = "token",
    node_type = "dep_",
    link = "dep_",
    root_tag = "ROOT",
    attributes = spacyr_attributes())
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
