build_tree <- function(txt, attributes = spacy_attributes()) {
  x <- transform_logical(spacy_df(txt))

  root <- parse_root(x)
  children <- build_nodes(parse_children(x, txt, root$id), root$id)

  jsonlite::toJSON(
    x = tree(txt, root, children, attributes),
    pretty = TRUE,
    auto_unbox = TRUE
  )
}

build_nodes <- function(x, root, attributes = spacy_attributes()) {

  if (is.factor(root))
    root <- as.character(root)

  r <- list()

  cur_tib <- x[x[, "token_id"] == root,]

  r$nodeType <- cur_tib$dep_
  r$word <- cur_tib$token
  r$attributes <- pull_attr(cur_tib, attributes)
  r$link <- cur_tib$dep_

  if (!is.null(r$word) & length(r$word) > 0) {
    r$spans <- list(pull_word_span(x$txt[1], cur_tib$token_id))
  }

  children <- x[x[, "head_token_id"] == root, 2]

  if (is.factor(children))
    children <- as.character(children)

  if (length(children) > 0) {
    r$children <- lapply(children, build_nodes, x = x)
  }

  r
}


