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
# dt_root <- function(x) {
#   names(x$Get("level", filterFun = data.tree::isRoot))
# }
#
# dt_root_df <- function(x) {
#   x <- dt_root(x)
#   data.frame(
#     from = x,
#     to = x
#   )
# }
#
# dt_collect <- function(x) {
#   source <- ToDataFrameNetwork(x)
#   out <- lapply(x$fieldsAll, function(attribute) {
#     ToDataFrameNetwork(x, attribute)[3]
#   })
#
#   vctrs::vec_cbind(source, do.call(vctrs::vec_cbind, out))
# }
#
# hp_datatree <- function(.data, title = "Hierplane", settings = hierplane_settings(), styles = NULL) {
#   root <- dt_root_df(.data)
#
#   df <- vctrs::vec_rbind(dt_collect(.data), root)
#
#   print(tail(tibble::as_tibble(df)))
#   hp_dataframe(
#     .data = df,
#     title = title,
#     styles = styles,
#     settings = settings
#   )
# }
#
# # hierplane
# acme %>%
#   hp_datatree(
#     title = "Acme Inc.",
#     settings = hierplane_settings(
#       parent_id = "from",
#       child_id = "to",
#       child = "to",
#       root_tag = "Acme Inc.",
#       node_type = "from",
#       link = "to",
#       attributes = c(
#         "cost",
#         "p"
#       )
#     )
#   ) %>%
#   hierplane(
#     theme = "dark",
#     width = "auto",
#     height = "auto"
#   )
#
