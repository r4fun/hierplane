#' Add styling options
#'
#' @param node_type_to_style A named list of mappings from node type to styles.
#' See `hierplane::styles$node_type_to_style` for available options.
#' @param link_to_positions A named list of mappings from link to node placements.
#' See `hierplane::styles$link_to_positions` for available options.
#' @param link_name_to_label A named list of mappings from link names to labels (e.g. from "Episode" to "Ep").
#'
#' @export

hierplane_styles <- function(node_type_to_style = NULL,
                             link_to_positions = NULL,
                             link_name_to_label = NULL) {
  list(
    node_type_to_style = format_styles(node_type_to_style, "node_type_to_style"),
    link_to_positions = format_styles(link_to_positions, "link_to_positions"),
    link_name_to_label = format_styles(link_name_to_label, "link_name_to_label")
  )
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

check_style <- function(x, settings, styles, style_type, style_target) {

  if (is.null(styles)) return(NULL)

  selected <- styles[[style_type]]
  bad_vals <- setdiff(names(selected), x[[settings[[style_target]]]])
  bad_styles <- setdiff(unlist(selected), style_options[[style_type]])
  dupes_vals <- names(selected)[duplicated(names(selected))]

  if (length(bad_vals) > 0) {
    warning(paste(style_type, "names contain value(s) that is not in",
                  settings[[style_target]], "column:",
                  paste(bad_vals, collapse = ", ")),
            call. = F)
  }

  if (length(dupes_vals) > 0) {
    warning(paste(style_type, "names contain duplicated value(s) from",
                  settings[[style_target]], "column:",
                  paste(dupes_vals, collapse = ", "),
                  "\n Values should be unique."),
            call. = F)
  }

  if (length(bad_styles) > 0 & !style_type %in% "link_name_to_label") {
    stop(paste0(style_type,
                " styles contain value(s) that is not in available options: ",
                paste(bad_styles, collapse = ", "),
                "\nSee `hierplane::style_options$", style_type,
                "` to see all available options."),
         call. = F
    )
  }

}


