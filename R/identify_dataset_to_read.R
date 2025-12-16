#' Identify datasets to read from the registry
#'
#' Decide which dataset names should be read based on the user input.
#'
#' @param datasets Character vector of dataset names, or a single value
#'   `installed` (all installed datasets) or `all` (all available
#'   datasets in the registry).
#' @param registry  A data.frame representing the registry.
#' @return A character vector with the names of datasets to read, or
#'   `invisible(NULL)` if no valid datasets were selected.
#' @keywords internal
#' @noRd
#'
.identify_datasets_to_read <- function(datasets, registry) {

  if (length(datasets) == 1 && identical(datasets, "installed")) {
    datasets_to_read <- registry$name[registry$installed]

  } else if (length(datasets) == 1 && identical(datasets, "all")) {
    datasets_to_read <- registry$name

  } else {
    datasets_to_read <- .validate_datasets(datasets, registry, FALSE)
  }

  if (length(datasets_to_read) == 0) {
    cli::cli_alert_warning(
      "No valid datasets selected. Provide at least one valid dataset name, or set
       `datasets = 'installed'` to load all installed datasets, or
       `datasets = 'all'` to load all available datasets."
    )
    return(invisible(NULL))
  }

  datasets_to_read
}
