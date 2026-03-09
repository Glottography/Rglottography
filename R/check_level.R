#' Validate and expand Glottography level selection
#'
#' Validates the requested dataset level(s) and expands the special value
#' `"all"` to include all available levels.
#'
#' @param level Character vector specifying the level(s) to use. Must contain
#'   one or more of `"features"`, `"languages"`, or `"families"`, or the
#'   special value `"all"`. If `"all"` is supplied, it is expanded to all
#'   available levels.
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

