#' Download a file from a GitHub URL to a local path
#'
#' Downloads a file from a given GitHub URL and saves it to the specified local
#' file path. The function temporarily adjusts the R download timeout
#' option and restores it on exit.
#'
#' @param file_url Character string. The full URL of the file to download.
#' @param file_path Character string. The local file path where the file
#'   should be saved.
#' @param timeout Numeric. The download timeout in seconds (default is 1200).
#'
#' @return `NULL` (invisibly). The function is called for its side effect
#'   of downloading the file.
#' @keywords internal
#' @noRd
.download_file_github <- function(file_url, file_path,
                                  timeout = 1200) {

  old_timeout <- getOption("timeout")
  on.exit(options(timeout = old_timeout))
  options(timeout = timeout)

  utils::download.file(file_url, file_path, mode = "wb", quiet = TRUE)

  return(invisible(NULL))
}
