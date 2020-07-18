add_root <- function(.data, root, attribute = NULL) {
  out <- data.frame(
    parent_id = root,
    child_id = root,
    child = root,
    node_type = "ROOT",
    link = "ROOT"
  )

  if (!is.null(attribute)) {
    for (i in 1:length(attribute)) {
      out[[paste0("attribute", i)]] <- attribute[i]
    }
  }

  attr(out, "source") <- .data
  out
}


add_layer <- function(.data,
                      child_col,
                      parent_col = NULL,
                      child_id_col = NULL,
                      node_type_col = NULL,
                      link_col = NULL,
                      attribute_cols = NULL,
                      parent_vals = NULL,
                      node_type_vals = NULL,
                      link_vals = NULL) {
  source <- attr(.data, "source")

  cols <- c(parent_col,
            child_col,
            node_type_col,
            link_col,
            attribute_cols)
  cols <- cols[!is.null(cols)]

  clean <- transform_logical(unique(source[cols]))

  # set dataframe size by first defining children
  out <- data.frame(child = clean[[child_col]])

  # add child_id col
  if (!is.null(child_id_col)) {
    out$child_id <- clean[[child_id_col]]
  } else {
    out$child_id <- clean[[child_col]]
  }

  if (any(duplicated(na.omit(out$child_id)))) {
    stop(paste0("Duplicates detected in child_id with different parents. ",
                "Verify that there are no duplicates in child column or specify a child_id_col with unique values."),
         call. = T)
  }

  # add parent_id col
  if (!is.null(parent_col)) {
    out$parent_id <- clean[[parent_col]]
  } else if(!is.null(parent_vals)) {
    out$parent_id <- parent_vals
  } else {
    stop("Must define either `parent_col` or parent_vals`.",
         call. = F)
  }

  # add link col
  if (!is.null(link_col)) {
    out$link <- clean[[link_col]]
  } else if(!is.null(link_vals)) {
    out$link <- link_vals
  } else {
    stop("Must define either `link_col` or link_vals`.",
         call. = F)
  }

  # add node_type col
  if (!is.null(node_type_col)) {
    out$node_type <- clean[[node_type_col]]
  } else if(!is.null(node_type_vals)) {
    out$node_type <- node_type_vals
  } else {
    stop("Must define either `node_type_col` or node_type_vals`.",
         call. = F)
  }

  # add attributes cols
  if (!is.null(attribute_cols)) {
    for (i in 1:length(attribute_cols)) {
      out[[paste0("attribute", i)]] <- clean[[attribute_cols[i]]]
    }
  }

  layer <- out[!is.na(out$child) & !is.na(out$link) & !is.na(out$node_type), ]

  attr(layer, "source") <- source
  dplyr::bind_rows(.data, layer)
}

