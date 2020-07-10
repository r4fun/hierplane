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
                                              "attribute2"),
                               node_type_to_style = NULL,
                               link_to_positions = NULL,
                               link_name_to_label = NULL) {

  node_type_to_style <- format_styles(node_type_to_style)
  link_to_positions <- format_styles(link_to_positions)
  link_name_to_label <- format_styles(link_name_to_label)

  list(
    type = type,
    parent_id = parent_id,
    child_id = child_id,
    child = child,
    node_type = node_type,
    link = link,
    root_tag = root_tag,
    attributes = attributes,
    node_type_to_style = node_type_to_style,
    link_to_positions = link_to_positions,
    link_name_to_label = link_name_to_label
  )

}

format_styles <- function(x, name) {

  if (!is.null(x) & length(x) >= 1 ) {

    if ("data.frame" %in% class(x) & length(x) == 2) {

      out <- x[, 2]
      names(out) <- x[, 1]
      return(as.list(out))

    } else if ("list" %in% class(x)) {

      return(x)

    } else if ("data.frame" %in% class(x) & length(x) != 2) {

      stop(paste(name, "input dataframe must have two columns."),
           call. = F)

    } else {

      stop(paste(name, "must be a list or a dataframe."),
           call. = F)

    }

  }

}

check_style <- function(x, settings, setting_type, val_col) {
  selected <- settings[[setting_type]]
  bad_vals <- setdiff(names(selected), x[[settings[[val_col]]]])
  bad_settings <- setdiff(unlist(selected), style_options[[setting_type]])
  dupes_vals <- names(selected)[duplicated(names(selected))]

  if (length(bad_vals) > 0) {
    stop(paste(setting_type, "names contain value(s) that is not in",　
               settings[[val_col]], "column:",
               paste(bad_vals, collapse = ", ")),
         call. = F)
  }

  if (length(bad_settings) > 0) {
    stop(paste0(setting_type,
                " settings contain value(s) that is not in",　
                "available options:",
                paste(bad_settings, collapse = ", "),
                "\nSee `style_options$", setting_type,
                "` to see all available options."),
         call. = F
    )
  }

  if (length(dupes_vals) > 0) {
    stop(paste(setting_type, "names contain duplicated value(s) from",　
               settings[[val_col]], "column:",
               paste(dupes_vals, collapse = ", "),
               "\n Values must be unique."),
         call. = F)
  }
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
