#' Assign column names to hierplane
#'
#' Hierplane requires a specific data structure with things like parent IDs,
#' child IDs, the root ID, etc. This function requires the user to identify
#' which columns in their dataframe represent each of these requirements.
#'
#' @param type Either `hier` for standard hierplane or `spacy` for a spacy hierplane.
#' @param parent_id Column to be used for linkage references when generating children nodes.
#' @param child_id Column to be used for *generating* children nodes.
#' @param child Column to be used for *labeling* children nodes.
#' @param node_type Column to be used as node type (used for plane styling).
#' @param link Column to be used to generate lane tags (i.e. connections between planes).
#' @param root_tag Keyword in `link` field to be used to identify top-level plane. Defaulted to "ROOT".
#' @param attributes Column(s) to be used for generating the attribute tags.
#' If not specified (i.e. NULL), all columns with "attribute" in the name will be used.
#'
#' @export
hierplane_settings <- function(type = "hier",
                               parent_id = "parent_id",
                               child_id = "child_id",
                               child = "child",
                               node_type = "node_type",
                               link = "link",
                               root_tag = "ROOT",
                               attributes = NULL) {
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
