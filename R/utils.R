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

parse_root <- function(x) {
  list(
    id = x$token_id[x$dep_rel %in% "ROOT"],
    dat = x[x$dep_rel %in% "ROOT", ]
  )
}

spacy_attributes <- function() c("ent_type_", "pos", "is_currency", "like_url", "like_email")
spacy_default <- function() {
  list(
    parent_id = "head_token_id",
    child_id = "token_id",
    child = "token",
    node_type = "dep_",
    link = "dep_",
    attributes = spacy_attributes())
}

tree <- function(title, root, children, attributes) {
  list(
    text = title,
    root = list(
      nodeType = root$dat$dep_,
      word = root$dat$token,
      attributes = pull_attr(root$dat, attributes),
      spans = list(pull_word_span(title, root$dat$token_id)),
      children = children$children)
  )
}

parse_children <- function(x, title, root_id, settings = spacy_default()) {
  x <- x[!x[[settings$parent_id]] == x[[settings$child_id]], ]
  x$sort_order <- ifelse(x[[settings$parent_id]] %in% root_id, 0, 1)
  x$txt <- title
  x <- x[with(x, order(x$sort_order, x[[settings$child_id]])), ]
  x[c(
    settings$parent_id,
    settings$child_id,
    settings$child,
    settings$link,
    settings$attributes,
    "sort_order",
    "txt"
  )]
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
  tokens <- unlist(spacyr::spacy_tokenize(txt), use.names = FALSE)
  word <- tokens[word_id]

  # present (prevent?) symbol from being interpreted as regex
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

pull_attr <- function(x, attributes) {
  x <- as.vector(unlist(sapply(attributes, function(i) x[[i]])))
  as.list(x[nchar(x) > 0])
}
