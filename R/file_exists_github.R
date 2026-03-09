#' Check whether a file exists on GitHub via the API
#'
#' Sends a request to a GitHub REST API URL (typically a `/contents/` endpoint)
#' and checks whether the referenced file exists.
#'
#' @param file_url Character string specifying the full GitHub API URL
#'   of the file.
#'
#' @return Logical scalar:
#'   - `TRUE` if the file exists (HTTP status 200)
#'   - `FALSE` otherwise (e.g., 404 or other non-200 status)
#'
#' @keywords internal
#' @noRd
.file_exists_github <- function(file_url) {
  res <- tryCatch(
    httr2::request(file_url) |>
      httr2::req_method("HEAD") |>
      httr2::req_perform(),
    error = function(e) return(NULL))

  if (is.null(res)) return(FALSE)
  httr2::resp_status(res) == 200
}

