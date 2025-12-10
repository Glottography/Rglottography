.check_level <- function(level =  c("all", "features",
                                    "languages", "families")) {

  level <- match.arg(level)
  if (identical(level, "all")) level <- c("features", "languages", "families")
  level
}

