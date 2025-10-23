#' Check if a local download of the dataset exists
#' @param dataset character string. Name of the dataset to check.
#' @param registry data.frame containing meta information of versioning and chenges
#'
#' @return Logical. `TRUE` if the dataset has already been downloaded, `FALSE` otherwise.
#' @keywords internal
#' @noRd
.download_exists <- function(dataset, registry) {
  dataset %in% registry$downloaded
}
