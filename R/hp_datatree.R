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
  source <- data.tree::ToDataFrameNetwork(x)
  out <- lapply(x$fieldsAll, function(attribute) {
    data.tree::ToDataFrameNetwork(x, attribute)[3]
  })

  vctrs::vec_cbind(source, do.call(vctrs::vec_cbind, out))
}

#' Create a hierplane object using data.tree
#'
#' The `data.tree` package is a popular, general purpose hierarchical data
#' structure for R. Therefore, `hp_datatree` tries to make it so hierplane is
#' compatible with `data.tree` objects.
#'
#' @param .data A `data.tree` object of class "Node".
#' @param title A title, defaults to "Hierplane", this serves as the header/title of the hierplane.
#' @param attributes Attributes to assign to the nodes, these are the annotation in the nodes.
#' @param link Link connecting each node, theres are the tabs or connections you see between each node.
#' @param styles Assign styles to hierplane generated from `hierplane_styles()`.
#' @examples
#' \dontrun{
#' library(data.tree)
#' library(yaml)
#'
#' "
#' name: r4fun
#' tyler:
#'   name: Tyler
#'   job: Data Scientist
#'   species: Human
#'   toulouse:
#'     name: Toulouse
#'     job: Systems Engineer
#'     species: Cat
#'     toulouse:
#'       name: Toulouse
#'       job: Systems Engineer
#'       species: Cat
#'   ollie:
#'     name: Ollie
#'     job: Database Administrator
#'     species: Dog
#'   lucas:
#'     name: Lucas
#'     job: R Programmer
#'     species: Rabbit
#' " -> yaml
#'
#' yaml %>%
#'   yaml.load() %>%
#'   as.Node() %>%
#'   hp_datatree(
#'     title = "r4fun github group",
#'     link = "species",
#'     attributes = "job"
#'   ) %>%
#'   hierplane(
#'     theme = "light",
#'     width = "auto",
#'     height = "auto"
#'   )
#' }
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
