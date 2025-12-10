#' Identify which datasets need to be installed
#'
#' Given a set of dataset names that the user wants to read, determine which of
#' them are not yet installed according to the registry.
#'
#' @param datasets_to_read Character vector of dataset names requested by the user.
#' @param registry  A data.frame representing the registry.
#
#' @return A character vector of dataset names that still need to be installed.
#'   Returns an empty vector if none are required.
#' @keywords internal
#' @noRd
identify_datasets_to_install <- function(datasets_to_read, registry) {
  registry$name[
    registry$name %in% datasets_to_read & !registry$installed
  ]
}
