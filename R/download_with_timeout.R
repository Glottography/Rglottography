#' Download a (Glottography dataset) with a custom timeout
#'
#' Downloads a file from a URL to a local path, temporarily increasing
#' the R download timeout to accommodate large Glottography datasets
#'
#' @param url Character string specifying the URL of the file to download.
#' @param zip_path Character string specifying the local file path where the
#'   downloaded file should be saved.
#' @param timeout Numeric. The download timeout in seconds (default is 600).
#'
#' @return `NULL`. The function is called for downloading
#'   the file.
#' @keywords internal
#' @noRd
#'
.download_with_timeout <- function(url, zip_path, timeout = 600) {

  old_timeout <- getOption("timeout")
  on.exit(options(timeout = old_timeout))
  options(timeout = timeout)
  utils::download.file(url, zip_path, mode = "wb", quiet = TRUE)
  return(NULL)
}
