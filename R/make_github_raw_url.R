#' Construct a GitHub Raw URL
#'
#' @param github_parts Named list with elements `owner`, `repo`, and `tag`.
#' @param file Character string specifying the file name.
#' @param segment Optional character string specifying a subfolder inside `cldf`.
#'
#' @return Character string: a GitHub raw URL pointing to the file.
#' @keywords internal
#' @noRd
.make_github_raw_url <- function(github_parts, file, segment = NULL) {

  if (!is.null(segment) && is.na(segment)) segment <- NULL

  # Construct path
  path <- if (is.null(segment)) {
    paste0("cldf/", file)
  } else {
    paste0("cldf/", segment, "/", file)
  }

  # Build raw URL
  url <- paste0(
    "https://raw.githubusercontent.com/",
    github_parts$owner, "/",
    github_parts$repo, "/",
    github_parts$tag, "/",
    path
  )

  return(url)
}
