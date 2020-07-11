requireNamespaceQuietStop <- function(package) {
  if (!requireNamespace(package, quietly = TRUE))
    stop(paste('package',package,'is required to use this function'), call. = FALSE)
}

tree <- function(title, root, children, settings) {

  if (settings$type %in% "spacy") {
    spans <- list(pull_word_span(title, root$dat[[settings$child_id]]))
  } else {
    spans <- list(list(start = 0, end = nchar(title)))
  }

  tree <- list(
    text = title,
    root = list(
      nodeType = root$dat[[settings$node_type]],
      word = root$dat[[settings$child]],
      attributes = pull_attr(root$dat, settings$attributes),
      spans = spans,
      children = children$children)
  )

  if (!is.null(settings$node_type_to_style)) {
    tree$nodeTypeToStyle <- settings$node_type_to_style
  }


  if (!is.null(settings$link_to_positions)) {
    tree$linkToPosition <- settings$link_to_positions
  }

  if (!is.null(settings$link_name_to_label)) {
    tree$linkNameToLabel <- settings$link_name_to_label
  }

  tree

}


hierplane_settings <- function(type = "hier",
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

add_styles <- function(settings,
                       node_type_to_style = NULL,
                       link_to_positions = NULL,
                       link_name_to_label = NULL) {

  settings$node_type_to_style <- format_styles(node_type_to_style, "node_type_to_style")
  settings$link_to_positions <- format_styles(link_to_positions, "link_to_positions")
  settings$link_name_to_label <- format_styles(link_name_to_label, "link_name_to_label")

  settings
}

format_styles <- function(x, name) {

  if (is.null(x)) return(NULL)
  if (!"list" %in% class(x)) stop(paste(name, "must be a list."), call. = F)

  if (name %in% "node_type_to_style") {
    return(lapply(x, function(x) if (!is.list(x)) as.list(x) else x))
  } else {
    return(x)
  }

}

check_style <- function(x, settings, setting_type, setting_target) {

  selected <- settings[[setting_type]]
  bad_vals <- setdiff(names(selected), x[[settings[[setting_target]]]])
  bad_settings <- setdiff(unlist(selected), hierplane::style_options[[setting_type]])
  dupes_vals <- names(selected)[duplicated(names(selected))]

  if (length(bad_vals) > 0) {
    warning(paste(setting_type, "names contain value(s) that is not in",
                  settings[[setting_target]], "column:",
                  paste(bad_vals, collapse = ", ")),
         call. = F)
  }

  if (length(dupes_vals) > 0) {
    warning(paste(setting_type, "names contain duplicated value(s) from",
                  settings[[setting_target]], "column:",
               paste(dupes_vals, collapse = ", "),
               "\n Values should be unique."),
         call. = F)
  }

  if (length(bad_settings) > 0 & !setting_type %in% "link_name_to_label") {
    stop(paste0(setting_type,
                " settings contain value(s) that is not in available options: ",
                paste(bad_settings, collapse = ", "),
                "\nSee `hierplane::style_options$", setting_type,
                "` to see all available options."),
         call. = F
    )
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

