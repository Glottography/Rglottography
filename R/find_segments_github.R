#' Find segment folders in a CLDF directory on GitHub
#'
#' Retrieves the names of all subfolders within the `cldf/` directory
#' of a GitHub repository.
#'
#' The function queries the GitHub Contents API for the `cldf/` path
#' and returns only entries of type `"dir"`.
#'
#' @param github_parts Named list with elements `owner`, `repo`, and `tag`
#'
#' @return Character vector of subfolder names inside `cldf/`.
#'
#' @keywords internal
#' @noRd
.find_segments_github <- function(github_parts) {
  folder_url <- .make_github_api_url(github_parts)

  resp <- httr2::request(folder_url) |>
    httr2::req_perform()

  data <- httr2::resp_body_json(resp)

  folder_names <- vapply(data, function(x) {
    if (x$type == "dir") x$name else NA_character_
  }, character(1))

  folder_names <- folder_names[!is.na(folder_names)]

  folder_names
}

