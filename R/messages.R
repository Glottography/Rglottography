# Messages and warnings informing the user

#' Warn about datasets not installed
#'
#' Prints a warning with the given datasets listed as bullets, informing the
#' user that they will be skipped. Does not return any value.
#'
#' @param datasets Character vector of dataset names not installed.
#' @return Invisibly returns \code{NULL}.
#' @keywords internal
#' @noRd
#'
.skip_not_installed_warning <- function(datasets) {
  cli::cli_warn(c(
  "x" = "The following datasets are not installed and will be skipped:",
  setNames(datasets, rep("*", length(datasets))),
  "i" = "Set {.code install = TRUE} to install them or use {.fun install_datasets}."
  ))
  invisible(NULL)
}

.install_information <- function(datasets) {
  cli::cli_inform(c(
    "i" = "The following datasets are not available locally and will be installed:",
    setNames(datasets, rep("*", length(datasets)))
  ))
  invisible(NULL)
}

