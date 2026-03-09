#' Construct a GitHub API URL
#'
#' @param github_parts Named list with elements `owner`, `repo`, and `tag`.
#'
#' @return Character string: a GitHub API URL
#' @keywords internal
#' @noRd
.make_github_api_url <- function(github_parts) {

  base_url <- "https://api.github.com/repos"

  path <- paste0(base_url, "/",
                 github_parts$owner, "/",
                 github_parts$repo, "/contents/cldf")

  url <- paste0(path, "?ref=", github_parts$tag)
  url
}
