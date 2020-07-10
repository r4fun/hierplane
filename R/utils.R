tree <- function(title, root, children, settings) {

  if (settings$type %in% "spacy") {
    spans <- list(pull_word_span(title, root$dat[[settings$child_id]]))
  } else {
    spans <- list(list(start = 0, end = nchar(title)))
  }

  list(
    text = title,
    root = list(
      nodeType = root$dat[[settings$node_type]],
      word = root$dat[[settings$child]],
      attributes = pull_attr(root$dat, settings$attributes),
      spans = spans,
      children = children$children)
  )
}


construct_settings <- function(type = "hier",
                               parent_id = "parent_id",
                               child_id = "child_id",
                               child = "child",
                               node_type = "node_type",
                               link = "link",
                               root_tag = "ROOT",
                               attributes = c("attribute1",
                                              "attribute2")) {
  list(
    type = type,
    parent_id = parent_id,
    child_id = child_id,
    child = child,
    node_type = node_type,
    link = link,
    root_tag = root_tag,
    attributes = attributes
  )

}

parse_root <- function(x, settings) {
  list(
    id = x[x[[settings$link]] %in% settings$root_tag, settings$child_id],
    dat = x[x[[settings$link]] %in% settings$root_tag, ]
  )
}

parse_children <- function(x, title, root_id, settings) {
  x <- x[!x[[settings$parent_id]] == x[[settings$child_id]], ]
  x$sort_order <- ifelse(x[[settings$parent_id]] %in% root_id, 0, 1)
  x <- x[with(x, order(x$sort_order, x[[settings$child_id]])), ]
  x[c(
    settings$parent_id,
    settings$child_id,
    settings$child,
    settings$link,
    settings$node_type,
    settings$attributes,
    "sort_order"
  )]
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



pull_attr <- function(x, attributes) {
  x <- as.vector(unlist(sapply(attributes, function(i) x[[i]])))
  as.list(x[nchar(x) > 0])
}
