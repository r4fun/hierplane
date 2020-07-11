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
