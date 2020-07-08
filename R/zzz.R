.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "Welcome to hierplane! This package depends on {spacyr}.\n",
    "* To get started, see: https://github.com/quanteda/spacyr"
  )
}
