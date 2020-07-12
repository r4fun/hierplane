#' Create a hierplane object from dataframe
#'
#' Creating a hierplane object from a dataframe requires a bit more work because
#' we need input from the user to construct valid JSON. Construction requires the
#' user to provide a dataframe, title, and a list of settings.
#'
#' @param .data A dataframe with valid hierachical features (child_id, parent_id, etc.).
#' @param settings Assign your dataframes columns to hierplane attributes, additionally apply rendering styles.
#' @param title A title, defaults to "Hierplane", this serves as the header/title of the hierplane.
#'
#' @md
#' @export
hp_dataframe <- function(.data, settings, title = "Hierplane") {
  x <- build_tree(.data, title, settings)
  structure(x, class = c("hierplane", "hierplane_dataframe", class(x)))
}
