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
  stats::setNames(datasets, rep("*", length(datasets))),
  "i" = "Set {.code install = TRUE} to install them or use {.fun install_datasets}."
  ))
  invisible(NULL)
}

.install_information <- function(datasets) {
  cli::cli_inform(c(
    "i" = "The following datasets are not available locally and will be installed:",
    stats::setNames(datasets, rep("*", length(datasets)))
  ))
  invisible(NULL)
}

.provide_valid_dataset_abort <- function() {
  cli::cli_abort(c(
    "x" = "No valid {.code datasets} provided. Please specify valid {.code datasets} or one of the following special values:",
    "*" = "{.val all}       ->  install all Glottography datasets",
    "*" = "{.val missing}   ->  install datasets missing locally",
    "*" = "{.val outdated}  ->  install datasets that are outdated or missing"
  ), call = NULL)
}


.provide_valid_dataset_message <- function(datasets) {
  if (length(datasets) == 0) return(invisible(NULL))
  cli::cli_warn(
    c("x" = "No Glottography datasets with the following names were found:",
      stats::setNames(paste0("{.code ", datasets, "}"), rep("*", length(datasets))),
      "i" = "Skipping.")
  )
  invisible(NULL)
}

## STOP
.summarise_installation_message <- function(instructions) {

  categories <- c(
    "always"       = "will be installed",
    "missing"      = "are missing and will be installed",
    "outdated"     = "are outdated and will be installed",
    "not missing"  = "are already present and will not be installed",
    "not outdated" = "are up-to-date and will not be installed"
  )

  for (cat in names(categories)) {

    datasets_cat <- instructions$name[instructions$comment == cat]

    if (!length(datasets_cat)) next

    cli::cli_text(paste0("The following datasets ", categories[cat], ":"))
    cli::cli_bullets(stats::setNames(datasets_cat, rep("*", length(datasets_cat))))
  }

  invisible(NULL)
}





