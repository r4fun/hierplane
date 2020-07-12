#' List of all available styles
#'
#' A list containing all available styling options for hierplane
#'
#' Source: \url{https://github.com/allenai/hierplane/}
"styles"

#' Assign column names to hierplane
#'
#' Hierplane requires a specific data structure with things like parent IDs,
#' child IDs, the root ID, etc. This function requires the user to identify
#' which columns in their dataframe represent each of these requirements.
#'
#' @param type Either `hier` for standard hierplane or `spacy` for a spacy hierplane.
#' @param parent_id TODO
#' @param child_id TODO
#' @param child TODO
#' @param node_type TODO
#' @param link TODO
#' @param root_tag TODO
#' @param attributes TODO
#'
#' @export

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
  bad_settings <- setdiff(unlist(selected), style[[setting_type]])
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
                "\nSee `hierplane::style$", setting_type,
                "` to see all available options."),
         call. = F
    )
  }

}


