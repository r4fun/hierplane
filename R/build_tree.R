#' Build hierarchical tree
#'
#' Wrapper for `build_node` to Recursively build hierarchical tree from children nodes.
#'
#' @txt A string of txt to build tree for.
#' @return A list containing tree in list and JSON formats.
#'
#' @md
#' @export

build_tree <- function(txt) {
  attributes <- c("ent_type_", "pos", "is_currency", "like_url", "like_email")
  x <- transform_logical(spacy_df(txt))

  root <- parse_root(x)
  child <- parse_children(x, txt, root$id)

  children <- build_nodes(sp_tib = child,
                          nodetype = "dep_",
                          word = "token",
                          link = "dep_",
                          attributes = attributes,
                          word_id = "token_id")

  out_list <- list(
    text = txt,
    root = list(
      nodeType = root$dat$dep_,
      word = root$dat$token,
      attributes = pull_attr(root$dat, attributes),
      spans = list(pull_word_span(txt, root$dat$token_id)),
      children = children$children)
  )

  jsonlite::toJSON(out_list, pretty = TRUE, auto_unbox = TRUE)

}

#' Build Hierarchical Tree Nodes
#'
#' Build children nodes.
#' https://stackoverflow.com/questions/23839142/transform-a-dataframe-into-a-tree-structure-list-of-lists
#'
#' @param sp_tib Tibble generated from `spacy_tibble`.
#' @param root Reference to first headtoken in sp_tib.
#' @param nodetype,word,link,attributes,word_id Reference to fields used to populate node.
#' @md
build_nodes <- function(sp_tib,
                        root = sp_tib[1, 1],
                        parent_id = "head_token_id",
                        parent = "head_token",
                        nodetype = "dep_",
                        link = "dep_",
                        attributes = c("ent_type_", "pos",
                                       "is_currency",
                                       "like_url",
                                       "like_email"),
                        word = "token",
                        word_id = "token_id") {


  if (is.factor(root))
    root <- as.character(root)


  r <- list()

  cur_tib <- sp_tib[sp_tib[, word_id] == root,]

  r$nodeType <- cur_tib[[nodetype]]
  r$word <- cur_tib[[word]]
  r$attributes <- pull_attr(cur_tib, attributes)
  r$link <- cur_tib[[link]]

  if (!is.null(r$word) & length(r$word) > 0) {
    r$spans <- list(pull_word_span(sp_tib$txt[1],
                                   cur_tib[[word_id]]))
  }

  children <- sp_tib[sp_tib[, parent_id] == root, 2]

  if (is.factor(children))
    children <- as.character(children)

  if (length(children) > 0) {
    r$children <- lapply(children, build_nodes, sp_tib = sp_tib)
  }

  r

}


