#' Add Root for hierarchical dataframe
#'
#' Lays foundation for hierarchical dataframe used for use with `hp_dataframe()`.
#'
#' @param .data Dataframe to construct hierarchical dataframe from (source data).
#' @param root Value to display as root.
#' @param attribute Values to tag root (i.e. top level) plane with.
#'
#' @examples
#' os_survey %>% add_root("OS Students 2014/15")
#'
#' @export
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
  attr(out, "root") <- root
  out
}

#' Add Layer for hierarchical dataframe
#'
#' Used in conjunction with `add_root()` to generate dataframe for use with
#' `hp_dataframe()`.
#'
#' @param .data Output from `add_root()` or `add_layer()`.
#' @param child_col Column to generate children from.
#' @param node_type_col,node_type_vals Column or values to use as node_type.
#' If not specified, all node types will be assigned as blank (" ") for the layer.
#' @param link_col,link_vals Column or values to use as link.
#' If not specified, all links will be assigned as blank (" ") for the layer.
#' @param attributes
#'
#' @examples
#' os_survey %>%
#'   add_root("OS Students 2014/15") %>%
#'   add_layer(
#'     child_col = "Operating System",
#'     link_vals = "OS",
#'     node_type_vals = "OS"
#'   ) %>%
#'   add_layer(
#'     child_col = "OS Version",
#'     link_vals = "Ver",
#'     node_type_vals = "Sub",
#'     attribute_cols = "users"
#'   ) %>%
#'   hp_dataframe(
#'     title = "Survey Results of Most Popular OS in 2014/15",
#'     settings = hierplane_settings(attributes = "attribute1"),
#'     styles = hierplane_styles(
#'       link_to_positions = list(Ver = "right")
#'     )
#'   ) %>%
#'   hierplane()
#'
#' @export
add_layer <- function(.data,
                      child_col,
                      node_type_col = NULL,
                      node_type_vals = " ",
                      link_col = NULL,
                      link_vals = " ",
                      attribute_cols = NULL) {

  source <- attr(.data, "source")

  if (any(sapply(.data, class) %in% "logical")) {
    source <- transform_logical(source)
  }

  if (!"path" %in% names(source)) {
    source$path <- attr(.data, "root")
  }

  cols <- c("path",
            child_col,
            node_type_col,
            link_col)
  cols <- cols[!is.null(cols)]

  clean <- unique(source[cols])
  clean <- clean[with(clean, order(path, get(child_col))), ]

  # set dataframe size by first defining children
  out <- data.frame(parent_id = clean$path,
                    child = clean[[child_col]])

  # add child_id col
  out$child_id <- paste(out$parent_id, out$child, sep = "--")

  # add link col
  if (!is.null(link_col)) {
    out$link <- clean[[link_col]]
  } else {
    out$link <- link_vals
  }

  # add node_type col
  if (!is.null(node_type_col)) {
    out$node_type <- clean[[node_type_col]]
  } else {
    out$node_type <- node_type_vals
  }


  # add attributes cols
  if (!is.null(attribute_cols)) {

    source$tag <- paste(source$path, source[[child_col]])

    for (i in 1:length(attribute_cols)) {
      a <- unname(sapply(
        split(source[[attribute_cols[i]]], source$tag),
        FUN = function(x)
          unique(x)
      ))

      out[[paste0("attribute", i)]] <- as.list(a)
    }
  }

  layer <- out[!is.na(out$child) & !is.na(out$link) & !is.na(out$node_type), ]

  out <- vctrs::vec_rbind(.data, layer)


  # set latest path as path
  source$path <- paste(source$path,
                       source[[child_col]],
                       sep = "--")

  attr(out, "source") <- source


  out
}


