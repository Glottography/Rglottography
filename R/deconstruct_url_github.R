#' Deconstruct a GitHub repository URL
#'
#' Parses a GitHub repository URL of the form
#' `https://github.com/{owner}/{repo}/tree/{tag}` and extracts
#' the repository owner, repository name, and tag
#'
#' @param github_repository Character string specifying the GitHub repository URL.
#'
#' @return A named list containing:
#'   - `owner`: repository owner (character)
#'   - `repo`: repository name (character)
#'   - `tag`: tag name (character)
#'
#' @keywords internal
#' @noRd
.deconstruct_url_github <- function(github_repository) {
  repo_part <- sub("^https://github.com/", "", github_repository)
  parts <- strsplit(repo_part, "/")[[1]]

  list(
    owner = parts[1],
    repo = parts[2],
    tag = parts[4]
  )
}
