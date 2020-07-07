#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
hierplane <- function(tree, width = NULL, height = NULL, elementId = NULL) {

  # forward options using x
  x = list(
    tree = tree
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'hierplane',
    x,
    width = width,
    height = height,
    package = 'hierplane',
    elementId = elementId
  )
}

#' Shiny bindings for hierplane
#'
#' Output and render functions for using hierplane within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a hierplane
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name hierplane-shiny
#'
#' @export
hierplaneOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'hierplane', width, height, package = 'hierplane')
}

#' @rdname hierplane-shiny
#' @export
renderHierplane <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, hierplaneOutput, env, quoted = TRUE)
}
