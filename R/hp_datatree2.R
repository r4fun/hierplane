# library(data.tree)
# library(dplyr)
# library(hierplane)
#
# acme <- Node$new("Acme Inc.")
# accounting <- acme$AddChild("Accounting")
# software <- accounting$AddChild("New Software")
# standards <- accounting$AddChild("New Accounting Standards")
# research <- acme$AddChild("Research")
# newProductLine <- research$AddChild("New Product Line")
# newLabs <- research$AddChild("New Labs")
# it <- acme$AddChild("IT")
# outsource <- it$AddChild("Outsource")
# agile <- it$AddChild("Go agile")
# goToR <- it$AddChild("Switch to R")
#
# acme$Accounting$`New Software`$cost <- 1000000
# acme$Accounting$`New Accounting Standards`$cost <- 500000
# acme$Research$`New Product Line`$cost <- 2000000
# acme$Research$`New Labs`$cost <- 750000
# acme$IT$Outsource$cost <- 400000
# acme$IT$`Go agile`$cost <- 250000
# acme$IT$`Switch to R`$cost <- 50000
#
# acme$Accounting$`New Software`$p <- 0.5
# acme$Accounting$`New Accounting Standards`$p <- 0.75
# acme$Research$`New Product Line`$p <- 0.25
# acme$Research$`New Labs`$p <- 0.9
# acme$IT$Outsource$p <- 0.2
# acme$IT$`Go agile`$p <- 0.05
# acme$IT$`Switch to R`$p <- 1
#
# acme$IT$Outsource$AddChild("India")
# acme$IT$Outsource$AddChild("Poland")
#
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
  root <- dt_root_df(.data)
  df <- vctrs::vec_rbind(dt_collect(.data), root)

  # should only expect a single NA in the link column, this is NA comes
  # from binding the root dataframe to the tree. If there are multiple
  # NAs, then the there are missing links
  missing_links <- "TRUE" %in% names(table(is.na(df[[link]])))
  if (missing_links) {
    if (table(is.na(df[[link]]))[["TRUE"]] > 1) {
      warning(paste0(
        "There are >1 missing values in the link column [", link, "]",
        "\n* Only the row containing the root can have a missing link value",
        "\n* Setting link to column [to]"
      ), call. = FALSE)
      link <- "to"
    }
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
  print(df)

  hp_dataframe(
    .data = df,
    title = title,
    styles = styles,
    settings = hierplane_settings(
      parent_id = "from",
      child_id = "to",
      child = "to",
      root_tag = root$from,
      node_type = "from",
      link = link,
      attributes = attributes
    )
  )
}

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

