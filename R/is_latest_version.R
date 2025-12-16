#' Check if an installed dataset is the latest available version
#'
#' @param v_local character. Local version of the dataset.
#' @param v character. Latest version of the dataset on Zenodo.
#' @return Logical `TRUE` if the local version is the latest, `FALSE` otherwise.
#' @keywords internal
#' @noRd
.is_latest_version <- function(v_local, v) {
  mapply(function(x, y) {
    if (is.na(x) | is.na(y)) return(FALSE)
    utils::compareVersion(x, y) >= 0
  }, v_local, v)
}


