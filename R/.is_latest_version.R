#' Check if the downloaded dataset is the latest available version
#'
#' @return Logical. `TRUE` if the dataset is the latest available version, `FALSE` otherwise.
#' @keywords internal
#' @noRd
.is_latest_version <- function(dataset, registry) {
  current_version <- registry[registry$name == dataset, "version"]
  latest_version  <- registry[registry$name == dataset, "latest_version"]
  isTRUE(current_version >= latest_version)
}
