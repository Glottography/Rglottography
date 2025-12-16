#' Determine which datasets to load
#'
#' Computes the datasets that should be read, optionally installing any
#' missing datasets. Handles warnings for datasets that are not installed
#' if `install_missing = FALSE`.
#'
#' @param datasets Character vector giving the names of datasets to load, or one
#'   of the following special values:
#'   - `"installed"`: all datasets already installed and available locally
#'   - `"all"`: all datasets (attempts to install any missing datasets)
#' @param install_missing Logical; if `TRUE`, missing datasets are
#'  downloaded and installed.
#' @param sync_registry Logical; if `TRUE`, the registry is
#'   synchronised before determining which datasets to read.
#' @return A character vector of dataset names to read, or `NULL` if no
#'   datasets are available.
#' @keywords internal
#' @noRd
#'
.get_load_instructions <- function(datasets, install_missing = FALSE,
                                   sync_registry = FALSE) {

  registry <- .get_registry(sync = sync_registry)

  datasets_to_read <- .identify_datasets_to_read(datasets, registry)
  datasets_to_install <- .identify_datasets_to_install(datasets_to_read, registry)

  if (length(datasets_to_install) == 0) {
    return(datasets_to_read)
  }

  if (install_missing) {
    .install_information(datasets_to_install)
    .download_datasets(datasets_to_install, registry)
    return(datasets_to_read)
  }

  # If not installing missing, skip and adjust
  .skip_not_installed_warning(datasets_to_install)
  datasets_to_read <- setdiff(datasets_to_read, datasets_to_install)

  if (length(datasets_to_read) == 0) {
    cli::cli_alert_warning(
      "No valid datasets selected. Provide at least one valid dataset, or set
       `datasets = 'installed'` to load all installed datasets, or
       `datasets = 'all'` to load all available datasets."
    )
    return(NULL)
  }

  datasets_to_read
}
