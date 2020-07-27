hierplane_settings <- function(type = "hier",
                               parent_id = "parent_id",
                               child_id = "child_id",
                               child = "child",
                               node_type = "node_type",
                               link = "link",
                               root_tag = "ROOT",
                               attributes = NULL) {
  x <- list(
    type = type,
    parent_id = parent_id,
    child_id = child_id,
    child = child,
    node_type = node_type,
    link = link,
    root_tag = root_tag,
    attributes = attributes
  )

  check_settings(x)

  structure(x, class = c("hierplane_settings", class(x)))

}

check_settings <- function(x) {

  issues <- c()

  required_settings <- c("type", "parent_id", "child_id", "child",
                         "node_type", "link", "root_tag")
  optional_settings <- "attributes"

  if (any(x$parent_id == x$child_id)) {
    issues <- c(issues,
                "parent_id must be different from child_id.")
  }

  if (any(x$parent_id == x$child)) {
    issues <- c(issues,
                "parent_id must be different from child.")
  }

  wrong_lengths <- sapply(required_settings,
                          function(y) length(x[[y]])) > 1
  if (any(wrong_lengths)) {
    wrong_settings <- required_settings[wrong_lengths]
    issues <- c(issues,
                paste0("The following fields must not have length > 1: ",
                       paste(wrong_settings, collapse = ", ")))
  }

  wrong_vals <- sapply(required_settings,
                       function(y) isTRUE(is.na(x[[y]])) | is.null(x[[y]]))
  if (any(wrong_vals)) {
    wrong_settings <- required_settings[wrong_vals]
    issues <- c(issues,
                paste0("The following fields must not be NULL or NA: ",
                       paste(wrong_settings, collapse = ", ")))
  }

  if (length(issues) > 0) {
    stop(paste(c("The following parameters require review:", issues),
               collapse = " \n      * "),
         call. = F)
  }

}
