#' Check if the local dataset includes all latest changes on Zenodo
#'
#' @param md_local character. Modification date of the local dataset.
#' @param md character. Last modification date of the dataset on Zenodo.
#' @return Logical `TRUE` if the local modification date is more recent or equal than the one on Zenodo, `FALSE` otherwise.
#' @keywords internal
#' @noRd
.includes_latest_changes <- function(md_local, md) {
  ifelse(
    !is.na(md_local) & !is.na(md),
    md_local >= md,
    FALSE
  )
}
