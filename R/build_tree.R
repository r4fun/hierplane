build_tree <- function(txt) {
  attributes <- c("ent_type_", "pos", "is_currency", "like_url", "like_email")
  x <- transform_logical(spacy_df(txt))

  root <- parse_root(x)
  child <- parse_children(x, txt, root$id)

  children <- build_nodes(x = child)

  out_list <- list(
    text = txt,
    root = list(
      nodeType = root$dat$dep_,
      word = root$dat$token,
      attributes = pull_attr(root$dat, attributes),
      spans = list(pull_word_span(txt, root$dat$token_id)),
      children = children$children)
  )

  jsonlite::toJSON(out_list, pretty = TRUE, auto_unbox = TRUE)

}

build_nodes <- function(x, root = x[1, 1]) {
  attributes <- c("ent_type_", "pos", "is_currency", "like_url", "like_email")

  if (is.factor(root))
    root <- as.character(root)


  r <- list()

  cur_tib <- x[x[, "token_id"] == root,]

  r$nodeType <- cur_tib$dep_
  r$word <- cur_tib$token
  r$attributes <- pull_attr(cur_tib, attributes)
  r$link <- cur_tib$dep_

  if (!is.null(r$word) & length(r$word) > 0) {
    r$spans <- list(pull_word_span(x$txt[1],
                                   cur_tib$token_id))
  }

  children <- x[x[, "head_token_id"] == root, 2]

  if (is.factor(children))
    children <- as.character(children)

  if (length(children) > 0) {
    r$children <- lapply(children, build_nodes, x = x)
  }

  r

}


