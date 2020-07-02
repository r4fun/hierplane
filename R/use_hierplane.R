use_hierplane <- function() {
  shiny::addResourcePath(
    prefix = "resources",
    directoryPath = system.file("www", package = "hierplane")
  )

  shiny::singleton(
    shiny::tags$head(
      shiny::tags$script(
        src = file.path("resources", "hierplane", "hierplane.min.js")
      ),
      shiny::tags$link(
        rel = "stylesheet",
        href = file.path("resources", "hierplane", "hierplane.min.css")
      )
    )
  )
}
