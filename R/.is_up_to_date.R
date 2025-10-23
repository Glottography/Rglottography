#' Check if a dataset is up-to-date
#' A dataset is up-to-date if it
#' - has  been downloaded to the local cache
#' - is the latest available version
#' - includes all latest changes
#' @param dataset character string. Name of the dataset to check.
#' @param registry data.frame containing meta information of versioning and chenges
#'
#' @return Logical. `TRUE` if the dataset is up-to-date, `FALSE` otherwise.
#' @keywords internal
#' @noRd
.is_up_to_date <- function(dataset, registry) {
  .download_exists(dataset, registry) &&
    .is_latest_version(dataset, registry) &&
    .includes_latest_changes(dataset, registry)
}
