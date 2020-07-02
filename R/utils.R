spacy_tibble <- function(txt, ...) {
  tibble::as_tibble(spacyr::spacy_parse(
    x = txt,
    entity = TRUE,
    dependency = TRUE,
    tag = TRUE,
    additional_attributes = c(
      "ent_type_",
      "dep_",
      ...
    )
  ))
}

pull_tree_data <- function(x, root_col, root_val, type = "root") {
  if (type == "root")
    x[x[[root_col]] %in% root_val, ]
  else if (type == "child")
    x[!x[[root_col]] %in% root_val, ]
}

pull_word_span <- function(txt, word) {
  x <- stringr::str_locate(txt, word)
  list(
    start = x[1] - 1,
    end = x[2]
  )
}

parse_children <- function(txt, child, nodetype, word, link, attributes, parent_id, child_id) {
  list(
    nodeType = child[[nodetype]],
    word = child[[word]],
    link = child[[link]],
    attributes = I(child[[attributes]]),
    parent_id = child[[parent_id]],
    child_id = child[[child_id]],
    spans = list(
      list(
        start = pull_word_span(txt, child[[word]])$start,
        end = pull_word_span(txt, child[[word]])$end
      )
    )
  )
}

parse_hierplane <- function(txt, root, children, nodetype, word, link, attributes, word_id, parent_id, child_id) {
  list(
    text = txt,
    root = list(
      nodeType = root[[nodetype]],
      word = root[[word]],
      link = root[[link]],
      attributes = I(root[[attributes]]),
      spans = list(
        list(
          start = pull_word_span(txt, root[[word]])$start,
          end = pull_word_span(txt, root[[word]])$end
        )
      ),
      children = lapply(unname(split(children, children[[word_id]])), function(x) {
        parse_children(
          txt = txt,
          child = x,
          nodetype = nodetype,
          word = word,
          link = link,
          attributes = I(attributes),
          parent_id = parent_id,
          child_id = child_id
        )
      })
    )
  )
}

hierplane_js <- function(x) {
  shinyjs::runjs(paste0("const tree = ", x, "; hierplane.renderTree(tree);"))
}
