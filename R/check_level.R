#' Validate and expand level selection
#'
#' Decide which dataset levels should be used based on the user input.
#'
#' @param level Character scalar specifying the level(s) to use. Must be
#'   one of `"all"`, `"features"`, `"languages"`, or `"families"` or a combination of these.
#'   The value `"all"` is expanded to include all available levels.
#' @return A character vector of valid levels. If `"all"` is supplied,
#'   returns `c("features", "languages", "families")`.
#' @keywords internal
#' @noRd
#'
.check_level <- function(
    level = c("all", "features", "languages", "families")
) {
  allowed <- c("features", "languages", "families")

  if ("all" %in% level) {
    return(allowed)
  }

  level <- match.arg(level, choices = allowed, several.ok = TRUE)
  level
}

