node_styles <- c(
  "color0",
  "color1",
  "color2",
  "color3",
  "color4",
  "color5",
  "color6",
  "color7",
  "color8",
  "color9",
  "strong",
  "seq",
  "placeholder"
)

link_positions <- c(
  "inside",
  "left",
  "right",
  "down"
)

themes <- c(
  "dark",
  "light",
  "pink",
  "grey"
)

style_options <- list(
  node_type_to_style = node_styles,
  link_to_positions = link_positions,
  themes = themes
)

usethis::use_data(style_options, overwrite = T)
