#' Create a hierplane object using spacyr
#'
#' Creating a hierplane object from text is made possible by employing
#' the `spacyr` package. More specifically, the `spacyr::spacy_parse()` function
#' is used to tokenize and tag the sentence(s) provided. Note that this
#' functionality requires the `spacyr` package.
#'
#' If more than one sentence is detected in the input text, a list of hierplane
#' objects is returned.
#'
#' @param .data A sentence.
#' @param node_type `spacyr::spacy_parse()` variable to be used as node type (used for plane styling).
#' @param link `spacyr::spacy_parse()` variable to be used to generate lane tags (i.e. connections between planes).
#' @param attributes `spacyr::spacy_parse()` variable(s) to be used for generating the attribute tags.
#' See full list of available attributes here: [](https://spacy.io/api/token#attributes)
#' @param styles Assign styles to hierplane.
#' @param ... Additional parameters to pass to `spacyr::spacy_parse()`
#'
#' @examples
#' if (FALSE) {
#'
#'   # Custom attribute tags
#'   hp_spacyr("A house cat is genetically 95.6% tiger.", attributes = c("pos", "is_stop")) %>%
#'     hierplane()
#'
#'   # Multiple sentences in input
#'   hp_spacyr("I have a cat. Her name is Mocha. She has a round belly.") %>%
#'     lapply(hierplane)
#'
#' }
#'
#' @md
#' @export
hp_spacyr <- function(.data,
                      node_type = "dep_",
                      link = "dep_",
                      attributes = spacyr_default_attributes(),
                      styles = NULL, ...) {

  requireNamespaceQuietStop("spacyr")

  .data <- gsub("\\s+", " ", .data)

  settings <- hierplane_settings(
      type = "spacyr",
      parent_id = "head_token_id",
      child_id = "token_id",
      child = "token",
      node_type = node_type,
      link = link,
      root_tag = "ROOT",
      attributes = attributes
  )

  additional_attributes <- setdiff(
    c(node_type, link, attributes),
    spacyr_default_cols()
  )

  sents <- get_sents(.data)
  names(sents) <- paste0("sentence", 1:length(sents))

  out <- lapply(sents, function(sent) {
    x <- build_tree(
      x = transform_logical(spacyr_df(sent, additional_attributes, ...)),
      title = sent,
      settings = settings,
      styles = styles
    )

    structure(x, class = c("hierplane_tree", class(x)))
  })

  if (length(out) == 1) out[[1]] else out


}

spacyr_df <- function(txt, additional_attributes = NULL, ...) {
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
      additional_attributes
    ),
    ...
  )
}



spacyr_default_cols <- function() c("doc_id", "sentence_id", "token_id", "token",
                                "lemma", "pos", "tag", "head_token_id", "dep_rel",
                                "entity", "ent_type_", "dep_", "is_currency", "like_url", "like_email")

#' Default settings for hp_spacyr attributes
#'
#' @export
spacyr_default_attributes <- function() c("ent_type_", "pos_",
                                          "is_currency", "like_url",
                                          "like_email")

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
