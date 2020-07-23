# library(data.tree)
# library(dplyr)
# library(hierplane)
#
# data(acme)
# acme$IT$AddChild("New Labs") # make dupe name for test
# acme$IT$AddChild("Here/There") # what if theres a slash?
# acme$Set(type = c('company', 'department', 'project', 'project', 'department', 'project', 'project', 'department', 'program', 'project', 'project', 'project', 'project'))

dt_root <- function(x) {
  names(x$Get("level", filterFun = data.tree::isRoot))
}

dt_root_df <- function(x) {
  x <- dt_root(x)
  data.frame(
    from = x,
    to = x,
    stringsAsFactors = FALSE
  )
}

dt_collect <- function(x) {
  source <- ToDataFrameNetwork(x)
  out <- lapply(x$fieldsAll, function(attribute) {
    ToDataFrameNetwork(x, attribute)[3]
  })

  vctrs::vec_cbind(source, do.call(vctrs::vec_cbind, out))
}

#' @export
hp_datatree <- function(.data, title = "Hierplane", attributes = NULL, link = "to",
                        styles = NULL) {

  requireNamespaceQuietStop("data.tree")


  # clean up the slashes
  .data$Set(name = gsub("[/]", "~~~placeholder~~~", .data$Get("name")))


  root <- dt_root_df(.data)
  df <- vctrs::vec_rbind(dt_collect(.data), root)


  # should only expect a single NA in the link column, this is NA comes
  # from binding the root dataframe to the tree. If there are multiple
  # NAs, then the there are missing links
  missing_links <- sum(is.na(df[[link]]))
  if (missing_links > 1) {
      warning(paste0(
        "There are >1 missing values in the link column [", link, "]",
        "\n* Only the row containing the root can have a missing link value",
        "\n* Setting link to column [to]"
      ), call. = FALSE)
      link <- "to"
  }


  # Links really shouldn't refer to the parent, otherwise the hierplane
  # becomes distorted, warn the user when this happens and set the link
  # to the child
  if (link == "from") {
    warning(paste0(
      "Node link cannot refer to itself, i.e. column [", link, "]",
      "\n* Setting link to column [to]"
    ), call. = FALSE)
    link <- "to"
  }

  df[[link]] <- ifelse(is.na(df[[link]]), root$from, df[[link]])

  # Deal with duplicated child_id
  df$child <- gsub(".*[/]", "", df[["to"]])
  # change all the `----` back to `/`
  df$from <- gsub("~~~placeholder~~~", "/", df$from)
  df$to <- gsub("~~~placeholder~~~", "/", df$to)
  df$child <- gsub("~~~placeholder~~~", "/", df$child)

  hp_dataframe(
    .data = df,
    title = title,
    styles = styles,
    settings = hierplane_settings(
      parent_id = "from",
      child_id = "to",
      child = "child",
      root_tag = root$from,
      node_type = "from",
      link = link,
      attributes = attributes
    )
  )
}
#
# # hierplane
# acme %>%
#   hp_datatree(
#     title = "Acme Inc.",
#     link = "type",
#     attributes = c("cost", "p")
#   ) %>%
#   hierplane(
#     theme = "light",
#     width = "auto",
#     height = "auto"
#   )
#
