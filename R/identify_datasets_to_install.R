#' Identify which datasets would need to be installed prior to loading
#'
#' Given a set of dataset names that the user wants to read, determine which of
#' them are not yet installed according to the registry.
#'
#' @param datasets Character vector of dataset names requested by the user.
#' @param registry  A data.frame representing the registry.
#
#' @return A character vector of dataset names that still need to be installed.
#'   Returns an empty vector if none are required.
#' @keywords internal
#' @noRd
.identify_datasets_to_install <- function(datasets, registry) {
  registry$name[
    registry$name %in% datasets & !registry$installed
  ]
}
