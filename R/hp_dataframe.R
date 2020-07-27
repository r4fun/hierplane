#' Create a hierplane object from dataframe
#'
#' Creating a hierplane object from a dataframe requires a bit more work because
#' we need input from the user to construct valid JSON. Construction requires the
#' user to provide a dataframe, title, and a list of settings.
#'
#' @param .data A dataframe with valid hierachical features (child_id, parent_id, etc.).
#' @param title A title, defaults to "Hierplane", this serves as the header/title of the hierplane.
#' @param parent_id Variable to be used for linkage references when generating children nodes.
#' @param child_id Variable to be used for *generating* children nodes.
#' @param child Variable to be used for *labeling* children nodes.
#' @param node_type Variable to be used as node type (used for plane styling).
#' @param link Variable to be used to generate lane tags (i.e. connections between planes).
#' @param root_tag Keyword in `link` field to be used to identify top-level plane. Defaulted to "ROOT".
#' @param attributes Variable(s) to be used for generating the attribute tags.
#' If not specified (i.e. NULL), all variables with "attribute" in the name will be used.
#' @param styles Assign styles to hierplane generated from `hierplane_styles()`.
#'
#' @md
#' @export
hp_dataframe <- function(.data,
                         title = "Hierplane",
                         parent_id = "parent_id",
                         child_id = "child_id",
                         child = "child",
                         node_type = "node_type",
                         link = "link",
                         root_tag = "ROOT",
                         attributes = NULL,
                         styles = NULL) {


  settings <- hierplane_settings(
    type = "hier",
    parent_id = parent_id,
    child_id = child_id,
    child = child,
    node_type = node_type,
    link = link,
    root_tag = root_tag,
    attributes = attributes
  )

  if (is.null(settings$attributes)) {
    settings$attributes <- grep("attribute",
                                names(.data),
                                value = T,
                                ignore.case = T)

  }

  x <- build_tree(.data, title, settings, styles)
  structure(x, class = c("hierplane_tree", "hierplane_dataframe", class(x)))
}
