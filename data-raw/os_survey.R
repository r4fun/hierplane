os_survey <- dplyr::tribble(
  ~"Survey",              ~"Operating System", ~"OS Version", ~"users",
  "OS Students 2014/15",  "OS X"             , "Yosemite",    16,
  "OS Students 2014/15",  "OS X"             , "Leopard",     43,
  "OS Students 2014/15",  "Linux"            , "Debian",      27,
  "OS Students 2014/15",  "Linux"            , "Ubuntu",      36,
  "OS Students 2014/15",  "Windows"          , "Win7",        31,
  "OS Students 2014/15",  "Windows"          , "Win8",        32,
  "OS Students 2014/15",  "Windows"          , "Win10",       4
)

usethis::use_data(os_survey, overwrite = T)
