#' Check if a dataset exists in the registry
#'
#' @param dataset character string. Name of the dataset to check.
#' @param registry data.frame containing available dataset names.
#'
#' @return Logical. `TRUE` if the dataset exists, `FALSE` otherwise.
#' @keywords internal
#' @noRd
.dataset_exists <- function(dataset, registry) {
  dataset %in% registry$name
}

