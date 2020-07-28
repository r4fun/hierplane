#' Create a hierplane object from dataframe
#'
#' Creating a hierplane object from a dataframe requires a bit more work because
#' we need input from the user to construct valid JSON. Construction requires the
#' user to provide a dataframe, title, and a list of settings.
#'
#' @param .data A dataframe with valid hierachical features (child_id, parent_id, etc.).
#' @param title A title, defaults to "Hierplane", this serves as the header/title of the hierplane.
#' @param settings A named list of dataframe columns to hierplane variables generated from `hierplane_settings()`.
#' @param styles Assign styles to hierplane generated from `hierplane_styles()`.
#'
#' @md
#' @export
hp_dataframe <- function(.data,
                         title = "Hierplane",
                         settings = hierplane_settings(),
                         styles = NULL) {

  if (is.null(settings$attributes)) {
    settings$attributes <- grep("attribute",
                                names(.data),
                                value = T,
                                ignore.case = T)

  }

  x <- build_tree(.data, title, settings, styles)
  structure(x, class = c("hierplane_tree", class(x)))
}
